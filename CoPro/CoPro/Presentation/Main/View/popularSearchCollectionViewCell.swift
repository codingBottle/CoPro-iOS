//
//  popularSearchCollectionViewCell.swift
//  CoPro
//
//  Created by 문인호 on 1/4/24.
//

import UIKit

final class popularSearchCollectionViewCell: UICollectionViewCell {
    static let id = "popularSearchCollectionViewCell"
    
    let searchButton = UIButton()
    
    
    
    @available(*, unavailable)
      required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }
      
      override init(frame: CGRect) {
        super.init(frame: frame)
        
          searchButton.do {
              $0.layer.cornerRadius = 10
              $0.layer.borderWidth = 0.4
              $0.layer.borderColor = UIColor.black.cgColor
              $0.backgroundColor = .clear
              $0.setTitleColor(.black, for: .normal)
              $0.translatesAutoresizingMaskIntoConstraints = false
              $0.titleLabel?.font = UIFont.pretendard(size: 17, weight: .regular)
          }
        self.contentView.addSubview(self.searchButton)
        
        NSLayoutConstraint.activate([
          self.searchButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
          self.searchButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
          self.searchButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
          self.searchButton.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        ])
      }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepare(text: nil)
      }
      
    func prepare(text: String?) {
        self.searchButton.setTitle(text, for: .normal)
        let height = searchButton.frame.height  // 버튼의 현재 높이를 저장합니다.
        searchButton.sizeToFit()  // 버튼의 크기를 텍스트 크기에 맞게 조정합니다.
        searchButton.frame = CGRect(x: searchButton.frame.origin.x, y: searchButton.frame.origin.y, width: searchButton.frame.width, height: height)
    }
    var buttonWidth: CGFloat {
            return searchButton.frame.width
        }
}
