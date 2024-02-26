//
//  CommentTableViewCell.swift
//  CoPro
//
//  Created by 문인호 on 1/21/24.
//

import UIKit

import SnapKit
import Then

protocol CustomCellDelegate: AnyObject {
    func buttonTapped(commentId: Int)
    func menuButtonTapped(commentId: Int, commentContent: String)
}
final class commentTableViewCell: UITableViewCell, UICollectionViewDelegate {
    
    //MARK: - UI Components
    
    weak var delegate: CustomCellDelegate?
    static let identifier = "commentTableViewCell"
    private let cellStackView = UIStackView()
    private let nameJobStackView = UIStackView()
    private let nicknameLabel = UILabel()
    private let jobLabel = UILabel()
    private let contentLabel = UILabel()
    private let dateTimeStackView = UIStackView()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let recommentButton = UIButton()
    private let menuButton = UIButton()
    var levelConstraint = NSLayoutConstraint()
    var commentId: Int?
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
        cellStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        nameJobStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
        }
        nicknameLabel.do {
            $0.textColor = UIColor.G4()
            $0.font = .pretendard(size: 13, weight: .regular)
        }
        jobLabel.do {
            $0.textColor = UIColor.Black()
            $0.font = .pretendard(size: 13, weight: .regular)
        }
        contentLabel.do {
            $0.textColor = UIColor.Black()
            $0.font = .pretendard(size: 17, weight: .regular)
            $0.numberOfLines = 0
        }
        dateTimeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        dateLabel.do {
            $0.textColor = UIColor.G2()
            $0.font = .pretendard(size: 12, weight: .regular)
        }
        timeLabel.do {
            $0.textColor = UIColor.G2()
            $0.font = .pretendard(size: 12, weight: .regular)
        }
        recommentButton.do {
            $0.setTitleColor(UIColor.Black(), for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(size: 12, weight: .regular)
            $0.contentHorizontalAlignment = .right
            $0.setTitle("답글쓰기", for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
        menuButton.do {
            $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            $0.addTarget(self, action: #selector(menubuttonTapped(_: )), for: .touchUpInside)
            $0.tintColor = UIColor.G4()
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let commentId = commentId {
            delegate?.buttonTapped(commentId: commentId)
            print("data sent\(commentId)")
        }
    }
    @objc func menubuttonTapped(_ sender: UIButton) {
        if let commentId = commentId {
            delegate?.menuButtonTapped(commentId: commentId, commentContent: contentLabel.text ?? "")
        }
    }

    private func setLayout() {
//        addSubviews(cellStackView)
//        cellStackView.addArrangedSubviews(nameJobStackView,contentLabel,dateTimeStackView)
//        cellStackView.snp.makeConstraints {
//            $0.leading.equalToSuperview()
//            $0.top.equalToSuperview().offset(12)
//            $0.bottom.equalToSuperview().offset(-12)
//        }
//        nameJobStackView.addArrangedSubviews(nicknameLabel, jobLabel)
//        dateTimeStackView.addArrangedSubviews(dateLabel,timeLabel,recommentButton)
        addSubviews(nicknameLabel,jobLabel,contentLabel,dateLabel,timeLabel,recommentButton)
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview()
        }
        jobLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(5)
            $0.top.equalTo(nicknameLabel.snp.top)
        }
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            $0.centerY.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(dateLabel.snp.centerY)
        }
        recommentButton.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(timeLabel.snp.centerY)
        }
    }
    func configureCell(_ data: DisplayComment) {
        nicknameLabel.text = data.comment.writer.nickName
        jobLabel.text = data.comment.writer.occupation
        contentLabel.text = data.comment.content
        dateLabel.text = data.comment.getDateString()
        timeLabel.text = data.comment.getTimeString()
        commentId = data.comment.commentId
    }
    func configMenu() {
        addSubview(menuButton)
        menuButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview()
        }
    }
}
