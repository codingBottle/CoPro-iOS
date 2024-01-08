//
//  popularSearchCollectionViewCell.swift
//  CoPro
//
//  Created by 문인호 on 1/4/24.
//

import UIKit

final class popularSearchCollectionViewCell: UICollectionViewCell {
    static let id = "popularSearchCollectionViewCell"
    
    private let searchButton = UIButton()
    
    @available(*, unavailable)
      required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }
      
      override init(frame: CGRect) {
        super.init(frame: frame)
        
          searchButton.do {
              $0.layer.cornerRadius = 15
              $0.backgroundColor = .yellow
              $0.setTitleColor(.black, for: .normal)
              $0.translatesAutoresizingMaskIntoConstraints = false
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
      }
}
