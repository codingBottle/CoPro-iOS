//
//  CardCollectionCellView.swift
//  CoPro
//
//  Created by 박현렬 on 1/22/24.
//

import UIKit
import SnapKit
import Then

class CardCollectionCellView: UICollectionViewCell {
    let slideCardView = SlideCardView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(slideCardView)
        slideCardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with imageUrl: String,name: String, occupation: String, language: String) {
        slideCardView.loadImage(url: imageUrl)
        slideCardView.userNameLabel.text = name
        slideCardView.userPartLabel.text = occupation
        slideCardView.userLangLabel.text = language
    }
}
