//
//  DetailPhotoViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/29/24.
//

import UIKit


class DetailPhotoViewController: UICollectionViewController {
    
    var images = [UIImage]()
    var initialIndex: Int! // 초기 인덱스
    private var isInitialScroll = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // 0.
        self.collectionView!.register(DetailPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "DetailPhotoCollectionViewCell")
        // 1
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isInitialScroll, let initialIndex = initialIndex {
            self.collectionView.scrollToItem(at: IndexPath(item: initialIndex, section: 0), at: .centeredHorizontally, animated: false)
            self.isInitialScroll = false
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPhotoCollectionViewCell", for: indexPath) as? DetailPhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}
