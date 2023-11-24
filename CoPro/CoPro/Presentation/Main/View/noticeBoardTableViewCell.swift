//
//  noticeBoardTableViewCell.swift
//  CoPro
//
//  Created by 문인호 on 11/24/23.
//

import UIKit

import SnapKit
import Then

class noticeBoardTableViewCell: UITableViewCell {
    
    //MARK: - UI Components

    static let identifier = "noticeBoardTableViewCell"
    private let postImage = UIImageView()
    private let postTitleLabel = UILabel()
    private let writerNameLabel = UILabel()
    private let postTimeLabel = UILabel()
    private let likeCountIcon = UILabel()
    private let likeCountLabel = UILabel()
    private let sawPostIcon = UILabel()
    private let sawPostLabel = UILabel()
    private let commentCountIcon = UILabel()
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
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        writerNameLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        postTimeLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        likeCountIcon.do {
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        likeCountLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        sawPostIcon.do {
            $0.font = UIFont.systemFont(ofSize: 16)

        }
        sawPostLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        commentCountIcon.do {
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        commentCountLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16)
        }
    }
    private func setLayout() {
        addSubviews(postImage, postTitleLabel, writerNameLabel, postTimeLabel, likeCountIcon ,likeCountLabel,sawPostIcon ,sawPostLabel, commentCountIcon, commentCountLabel)
        
        postImage.snp.makeConstraints {
            $0.height.width.equalTo(72)
            $0.top.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().offset(-16)
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
        }
        likeCountIcon.snp.makeConstraints {
            $0.leading.equalTo(postTitleLabel.snp.leading)
            $0.top.equalTo(writerNameLabel.snp.bottom).offset(6)
        }
        likeCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeCountIcon.snp.trailing).offset(4)
        }
        sawPostIcon.snp.makeConstraints {
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(16)
        }
        sawPostLabel.snp.makeConstraints {
            $0.leading.equalTo(sawPostIcon.snp.trailing).offset(4)
        }
        commentCountIcon.snp.makeConstraints {
            $0.leading.equalTo(sawPostLabel.snp.trailing).offset(16)
        }
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentCountIcon.snp.trailing).offset(4)
        }
    }
    
    func configureCell(_ data: noticeBoardDataModel) {
        postImage.image = data.empathy.image
        postTitleLabel.text = data.title
        writerNameLabel.text = data.author
        postTimeLabel.text = "\(data.timestamp)"
        likeCountLabel.text = "\(data.likes)"
        sawPostLabel.text = "\(data.views)"
        commentCountIcon.text = "\(data.commentCount)"
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
