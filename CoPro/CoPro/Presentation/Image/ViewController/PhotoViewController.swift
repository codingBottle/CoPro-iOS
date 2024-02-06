//
//  PhotoViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/5/24.
//

import UIKit
import Then
import SnapKit
import Photos

final class PhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private enum Const {
        static let numberOfColumns = 3.0
        static let cellSpace = 1.0
        static let length = (UIScreen.main.bounds.size.width - cellSpace * (numberOfColumns - 1)) / numberOfColumns
        static let cellSize = CGSize(width: length, height: length)
        static let scale = UIScreen.main.scale
    }
    
    // MARK: UI
    private let submitButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.setTitleColor(.systemBlue, for: [.normal, .highlighted])
    }
    private let dismissButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 1
            $0.minimumInteritemSpacing = 0
            $0.itemSize = Const.cellSize
        }
    ).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .zero
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CameraCell")
    }
    
    // MARK: Property
    private let albumService: AlbumManager = MyAlbumManager()
    private let photoService: PhotoManager = MyPhotoManager()
    private var selectedIndexArray = [Int]() // Index: count
    
    // album 여러개에 대한 예시는 생략 (UIPickerView와 같은 것을 이용하여 currentAlbumIndex를 바꾸어주면 됨)
    private var albums = [PHFetchResult<PHAsset>]()
    private var dataSource = [PhotoCellInfo]()
    private var currentAlbumIndex = 0 {
        didSet { loadImages() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadAlbums(completion: { [weak self] in
            self?.loadImages()
        })
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubviews(dismissButton,submitButton)
        dismissButton.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        submitButton.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(submitButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func loadAlbums(completion: @escaping () -> Void) {
        albumService.getAlbums(mediaType: .image) { [weak self] albumInfos in
            self?.albums = albumInfos.map(\.album)
            completion()
        }
    }
    
    private func loadImages() {
        guard currentAlbumIndex < albums.count else { return }
        let album = albums[currentAlbumIndex]
        photoService.convertAlbumToPHAssets(album: album) { [weak self] phAssets in
            self?.dataSource = phAssets.map { .init(phAsset: $0, image: nil, selectedOrder: .none) }
            self?.collectionView.reloadData()
        }
    }
    @objc func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        if indexPath.item == 0 {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath)
        //            cell.backgroundColor = .white
        //            let cameraIcon = UIImageView(image: UIImage(systemName: "camera.fill"))
        //            cameraIcon.contentMode = .center
        //            cameraIcon.tintColor = UIColor(hex: "#6D6E72")
        //            cell.addSubview(cameraIcon)
        //            cameraIcon.frame = cell.bounds
        //            return cell
        //        } else {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as? PhotoCell
        else { return UICollectionViewCell() }
        let imageInfo = dataSource[indexPath.item]
        let phAsset = imageInfo.phAsset
        let imageSize = CGSize(width: Const.cellSize.width * Const.scale, height: Const.cellSize.height * Const.scale)
        
        photoService.fetchImage(
            phAsset: phAsset,
            size: imageSize,
            contentMode: .aspectFit,
            completion: { [weak cell] image in
                cell?.prepare(info: .init(phAsset: phAsset, image: image, selectedOrder: imageInfo.selectedOrder))
            }
        )
        return cell
    }
}
//}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if indexPath.item == 0 {
        //            let picker = UIImagePickerController()
        //            picker.delegate = self
        //            picker.sourceType = .camera
        //            present(picker, animated: true, completion: nil)
        //        } else { 
        let info = dataSource[indexPath.item ]
        let updatingIndexPaths: [IndexPath]
        
        if case .selected = info.selectedOrder {
            dataSource[indexPath.item] = .init(phAsset: info.phAsset, image: info.image, selectedOrder: .none)
            
            selectedIndexArray
                .removeAll(where: { $0 == indexPath.item })
            
            selectedIndexArray
                .enumerated()
                .forEach { order, index in
                    let order = order + 1
                    let prev = dataSource[index]
                    dataSource[index] = .init(phAsset: prev.phAsset, image: prev.image, selectedOrder: .selected(order))
                }
            updatingIndexPaths = [indexPath] + selectedIndexArray
                .map { IndexPath(row: $0, section: 0) }
        } else {
            selectedIndexArray
                .append(indexPath.item)
            
            selectedIndexArray
                .enumerated()
                .forEach { order, selectedIndex in
                    let order = order + 1
                    let prev = dataSource[selectedIndex]
                    dataSource[selectedIndex] = .init(phAsset: prev.phAsset, image: prev.image, selectedOrder: .selected(order))
                }
            
            updatingIndexPaths = selectedIndexArray
                .map { IndexPath(row: $0, section: 0) }
        }
        
        update(indexPaths: updatingIndexPaths)
        //        }
    }
    private func update(indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: indexPaths)
        }
    }
}
