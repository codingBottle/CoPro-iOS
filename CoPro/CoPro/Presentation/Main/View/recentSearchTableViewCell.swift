//
//  recentSearchTableViewCell.swift
//  CoPro
//
//  Created by 문인호 on 1/3/24.
//

import UIKit

import SnapKit
import Then

class recentSearchTableViewCell: UITableViewCell {
    
    //MARK: - UI Components

    static let identifier = "recentSearchTableViewCell"
    private let postImage = UIImageView()
    private let postTitleLabel = UILabel()
    private let writerNameLabel = UILabel()
    private let postTimeLabel = UILabel()
    private let likeCountIcon = UIImageView()
    private let likeCountLabel = UILabel()
    private let sawPostIcon = UIImageView()
    private let sawPostLabel = UILabel()
    private let commentCountIcon = UIImageView()
    private let commentCountLabel = UILabel()
    
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
        postImage.do {
            $0.roundCorners(cornerRadius: 6, maskedCorners: .layerMaxXMaxYCorner)
        }
        postTitleLabel.do {
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
        writerNameLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor(hex: "6D6E71")
        }
        postTimeLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor(hex: "6D6E71")
        }
        likeCountIcon.do {
            $0.image = UIImage(systemName: "heart")
            $0.tintColor = UIColor(hex: "6D6E71")
        }
        likeCountLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor(hex: "6D6E71")
        }
        sawPostIcon.do {
            $0.image = UIImage(systemName: "eye")
            $0.tintColor = UIColor(hex: "6D6E71")
        }
        sawPostLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor(hex: "6D6E71")
        }
        commentCountIcon.do {
            $0.image = UIImage(systemName: "text.bubble")
            $0.tintColor = UIColor(hex: "6D6E71")
        }
        commentCountLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor(hex: "6D6E71")
        }
    }
    private func setLayout() {
        addSubviews(postImage, postTitleLabel, writerNameLabel, postTimeLabel, likeCountIcon ,likeCountLabel,sawPostIcon ,sawPostLabel, commentCountIcon, commentCountLabel)
        
        postImage.snp.makeConstraints {
            $0.height.width.equalTo(72)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        postTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        writerNameLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(postTitleLabel.snp.leading)
        }
        postTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(writerNameLabel.snp.trailing).offset(14)
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(8)
        }
        likeCountIcon.snp.makeConstraints {
            $0.leading.equalTo(postTitleLabel.snp.leading)
            $0.top.equalTo(writerNameLabel.snp.bottom).offset(6)
        }
        likeCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeCountIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(likeCountIcon.snp.centerY)
        }
        sawPostIcon.snp.makeConstraints {
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(16)
            $0.top.equalTo(writerNameLabel.snp.bottom).offset(6)
        }
        sawPostLabel.snp.makeConstraints {
            $0.leading.equalTo(sawPostIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(likeCountIcon.snp.centerY)
        }
        commentCountIcon.snp.makeConstraints {
            $0.leading.equalTo(sawPostLabel.snp.trailing).offset(16)
            $0.top.equalTo(writerNameLabel.snp.bottom).offset(6)
        }
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentCountIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(likeCountIcon.snp.centerY)
        }
    }
    func configureCell(_ data: noticeBoardDataModel) {
        postImage.image = data.empathy.image
        postTitleLabel.text = data.title
        writerNameLabel.text = data.author
        postTimeLabel.text = "\(data.timestamp)"
        likeCountLabel.text = "\(data.likes)"
        sawPostLabel.text = "\(data.views)"
        commentCountLabel.text = "\(data.commentCount)"
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

