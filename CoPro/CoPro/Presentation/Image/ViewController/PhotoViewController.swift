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
import KeychainSwift
import Alamofire

final class PhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private enum Const {
        static let numberOfColumns = 3.0
        static let cellSpace = 1.0
        static let length = (UIScreen.main.bounds.size.width - cellSpace * (numberOfColumns - 1)) / numberOfColumns
        static let cellSize = CGSize(width: length, height: length)
        static let scale = UIScreen.main.scale
    }
    
    private let keychain = KeychainSwift()

    // MARK: UI
    private let submitButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.setTitleColor(.systemBlue, for: [.normal, .highlighted])
        $0.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
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
    private var selectedImages: [PHAsset] = []
    
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
    @objc func submitButtonTapped() {
            // NotificationCenter를 사용하여 선택된 이미지들을 전달
        NotificationCenter.default.post(name: NSNotification.Name("SelectedImages"), object: nil, userInfo: ["images": selectedImages])
            loadImages(from: selectedImages) { images in
                self.addPhoto(images: images)            }
            // 현재 뷰 컨트롤러를 dismiss
            self.dismiss(animated: true, completion: nil)
        }
    func loadImages(from assets: [PHAsset], completion: @escaping ([UIImage]) -> ()) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat

        var images = [UIImage]()
        for asset in assets {
            manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options) { (image, _) in
                if let image = image {
                    images.append(image)
                }
            }
        }
        completion(images)
    }
//    func addPhoto(images: [UIImage], completionHandler: @escaping () -> Void) {
//        let url = Config.baseURL
//        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
//
//        AF.upload(multipartFormData: { multipartFormData in
//
//            for (idx,image) in images.enumerated() {
//                // UIImage 처리
//                multipartFormData.append(image.jpegData(compressionQuality: 1) ?? Data(),
//                                         withName: "files",
//                                         fileName: "image\(idx).jpeg",
//                                         mimeType: "image/jpeg")
//            }
//
//        }, to: url, method: .post, headers: header)
//        .responseData { response in
//            guard let statusCode = response.response?.statusCode else { return }
//
//            switch statusCode {
//            case 200:
//                print("게시물 등록 성공")
//                completionHandler()
//            default:
//                print("게시물 등록 실패")
//            }
//        }
    func addPhoto(images: [UIImage]) {
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.addPhoto(token: token, imageId: images) { result in
                switch result {
                case .success:
                    print("success")
                case .requestErr(let message):
                    print("Request error: \(message)")
                    
                case .pathErr:
                    print("Path error")
                    
                case .serverErr:
                    print("Server error")
                    
                case .networkFail:
                    print("Network failure")
                    
                default:
                    break
                }
            }
        }
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = dataSource[indexPath.item ]
        let updatingIndexPaths: [IndexPath]
        
        if case .selected = info.selectedOrder {
            dataSource[indexPath.item] = .init(phAsset: info.phAsset, image: info.image, selectedOrder: .none)
            if let index = selectedImages.firstIndex(of: info.phAsset) {
                        selectedImages.remove(at: index)
                    }
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
            print(info)
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
            selectedImages.append(info.phAsset)
            print(info)

        }
//        selectedImages = selectedIndexArray.compactMap { dataSource[$0].phAsset }
        print(selectedImages)
        update(indexPaths: updatingIndexPaths)
    }
    private func update(indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: indexPaths)
        }
    }
}
