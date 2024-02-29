//
//  DetailPhotoCollectionViewCell.swift
//  CoPro
//
//  Created by 문인호 on 2/29/24.
//
    import UIKit

class DetailPhotoCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    private let identifier = "DetailPhotoCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        imageView.backgroundColor = .yellow
    }
    
    func setConstraints() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
