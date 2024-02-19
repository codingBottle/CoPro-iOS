//
//  RelatedPostsToMeTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 2/2/24.
//

import UIKit
import SnapKit
import Then

class RelatedPostsToMeTableViewCell: UITableViewCell {
    
    //MARK: - UI Components
    
    private let containerView = UIView()
    private let leftContainerView = UIView()
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
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setUI() {
        separatorInset.left = 0
        selectionStyle = .none
        
        let labels = [writerNameLabel, postTimeLabel, likeCountLabel, sawPostLabel, commentCountLabel]
        labels.forEach { label in
            label.do {
               $0.setPretendardFont(text: "", size: 13, weight: .regular, letterSpacing: 1)
               $0.textColor = UIColor.G4()
            }
        }

        let icons = [likeCountIcon, sawPostIcon, commentCountIcon]
        icons.forEach { icon in
            icon.do {
               $0.tintColor = UIColor.G3()
            }
        }

        postTitleLabel.do {
           $0.setPretendardFont(text: "", size: 15, weight: .bold, letterSpacing: 1.22)
        }

        likeCountIcon.do {
            $0.image = UIImage(systemName: "heart")
        }

        sawPostIcon.do {
            $0.image = UIImage(systemName: "eye")
        }

        commentCountIcon.do {
            $0.image = UIImage(systemName: "text.bubble")
        }
    }
    
    private func setLayout() {
        
        let standardWidth: CGFloat = 393 // iPhone 14 Pro의 너비
        let width = UIScreen.main.bounds.width * (16 / standardWidth)
        let height = width
        
        addSubview(containerView)
        containerView.addSubviews(leftContainerView, postImage)
        
        leftContainerView.addSubviews(postTitleLabel, writerNameLabel, postTimeLabel, likeCountIcon ,likeCountLabel,sawPostIcon ,sawPostLabel, commentCountIcon, commentCountLabel)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        leftContainerView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.trailing.equalTo(postImage.snp.leading).offset(-25)
        }
        
        postImage.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(leftContainerView.snp.trailing).offset(25)
        }
        
        
        //First Line
        postTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        //secound Line
        writerNameLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(postTitleLabel.snp.leading)
        }
        postTimeLabel.snp.makeConstraints {
            $0.top.equalTo(writerNameLabel.snp.top)
            $0.leading.equalTo(writerNameLabel.snp.trailing).offset(14)
        }
        
        //Third Line
        likeCountIcon.snp.makeConstraints {
            $0.top.equalTo(writerNameLabel.snp.bottom).offset(6)
            $0.leading.equalTo(postTitleLabel.snp.leading)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        likeCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeCountIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(likeCountIcon.snp.centerY)
        }
        sawPostIcon.snp.makeConstraints {
            $0.top.equalTo(likeCountIcon.snp.top)
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(16)
            $0.bottom.equalTo(likeCountIcon.snp.bottom)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        sawPostLabel.snp.makeConstraints {
            $0.leading.equalTo(sawPostIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(likeCountIcon.snp.centerY)
        }
        commentCountIcon.snp.makeConstraints {
            $0.top.equalTo(likeCountIcon.snp.top)
            $0.leading.equalTo(sawPostLabel.snp.trailing).offset(16)
            $0.bottom.equalTo(likeCountIcon.snp.bottom)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentCountIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(likeCountIcon.snp.centerY)
        }
    }
    
    
    func configureCellWritebyMe(_ data: WritebyMeDataModel) {
//        postImage.image = data.imageUrl
        postImage.image = nil
        postTitleLabel.text = data.title
        writerNameLabel.text = data.nickName
        postTimeLabel.text = data.getWritebyMeDateString()
        likeCountLabel.text = "\(data.heart)"
        sawPostLabel.text = "\(data.count)"
        commentCountLabel.text = "\(data.commentCount)"
    }
    
    func configureCellScrapPost(_ data: ScrapPostDataModel) {
//        postImage.image = data.imageUrl
        postImage.image = nil
        postTitleLabel.text = data.title
        writerNameLabel.text = data.nickName
        postTimeLabel.text = data.getScrapPostDateString()
        likeCountLabel.text = "\(data.heart)"
        sawPostLabel.text = "\(data.count)"
        commentCountLabel.text = "\(data.commentCount)"
    }
}

