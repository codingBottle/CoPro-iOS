//
//  popularSearchTableViewCell.swift
//  CoPro
//
//  Created by 문인호 on 1/3/24.
//

import UIKit

import SnapKit
import Then

final class popularSearchTableViewCell: UITableViewCell, UICollectionViewDelegate {
    
    //MARK: - UI Components
    
    static let id = "popularSearchTableViewCell"
    static let cellHeight = 30.0
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private var items = [String]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Components Property
    
    private func setStyle() {
        separatorInset.left = 0
        selectionStyle = .none
        
        collectionViewFlowLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 8.0
            $0.minimumInteritemSpacing = 0
            $0.itemSize = .init(width: 50, height: popularSearchTableViewCell.cellHeight)
        }
        collectionView.do {
            $0.dataSource = self
            $0.collectionViewLayout = self.collectionViewFlowLayout
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = .zero
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.register(popularSearchCollectionViewCell.self, forCellWithReuseIdentifier: popularSearchCollectionViewCell.id)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    private func setLayout() {
        self.contentView.addSubviews(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(items: [])
    }
    
    func prepare(items: [String]) {
        self.items = items
    }
}

extension popularSearchTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.items.count
    }
    //
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularSearchCollectionViewCell", for: indexPath) as! popularSearchCollectionViewCell
    //            let text = self.items[indexPath.item]
    //            cell.prepare(text: text)
    //        return CGSize(width: cell.buttonWidth, height: 30.0)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularSearchCollectionViewCell", for: indexPath) as! popularSearchCollectionViewCell
        cell.searchButton.setTitle(self.items[indexPath.row], for: .normal)
        cell.searchButton.titleLabel?.sizeToFit()
        let cellWidth = cell.searchButton.frame.width + 16
        
        return CGSize(width: cellWidth, height: 41)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularSearchCollectionViewCell", for: indexPath) as! popularSearchCollectionViewCell
        let text = self.items[indexPath.item]
        cell.prepare(text: text)
        return cell
    }
}
