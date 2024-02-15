//
//  noticeBoardTableViewCell.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import UIKit

import Kingfisher
import SnapKit
import Then

class noticeBoardTableViewCell: UITableViewCell {
    
    //MARK: - UI Components

    static let identifier = "noticeBoardTableViewCell"
    private let postImage = UIImageView()
    private let postTitleLabel = UILabel()
    private let writerNameLabel = UILabel()
    private let postDateLabel = UILabel()
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
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
        }
        postTitleLabel.do {
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
        writerNameLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor.G4()
        }
        postDateLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor.G4()
        }
        postTimeLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor.G4()
        }
        likeCountIcon.do {
            $0.image = UIImage(systemName: "heart")
            $0.tintColor = UIColor.G4()
        }
        likeCountLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor.G4()
        }
        sawPostIcon.do {
            $0.image = UIImage(systemName: "eye")
            $0.tintColor = UIColor.G4()
        }
        sawPostLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor.G4()
        }
        commentCountIcon.do {
            $0.image = UIImage(systemName: "text.bubble")
            $0.tintColor = UIColor.G4()
        }
        commentCountLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor.G4()
        }
    }
    private func setLayout() {
        addSubviews(postImage, postTitleLabel, writerNameLabel, postDateLabel, postTimeLabel, likeCountIcon ,likeCountLabel,sawPostIcon ,sawPostLabel, commentCountIcon, commentCountLabel)
        
        postImage.snp.makeConstraints {
            $0.height.width.equalTo(72)
            $0.trailing.equalToSuperview().offset(-16)
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
        postDateLabel.snp.makeConstraints {
            $0.leading.equalTo(writerNameLabel.snp.trailing).offset(14)
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(8)
        }
        postTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(postDateLabel.snp.trailing).offset(14)
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

    func configureCell(_ data: BoardDataModel) {
        postImage.kf.indicatorType = .activity
        if let url = URL(string: data.imageUrl) {
            postImage.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        } else {
            // URL 변환이 잘못된 경우, 디폴트 이미지를 로드하거나 에러 처리를 합니다.
            postImage.image = UIImage(systemName: "heart")
        }
        postTitleLabel.text = data.title
        writerNameLabel.text = data.nickName
        postDateLabel.text = data.getDateString()
        postTimeLabel.text = data.getTimeString()
        likeCountLabel.text = "\(data.heartCount)"
        sawPostLabel.text = "\(data.viewsCount)"
        commentCountLabel.text = "\(data.commentCount)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
