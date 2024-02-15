//
//  CommentTableViewCell.swift
//  CoPro
//
//  Created by 문인호 on 1/21/24.
//

import UIKit

import SnapKit
import Then

final class commentTableViewCell: UITableViewCell, UICollectionViewDelegate {
    
    //MARK: - UI Components
    
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
    var levelConstraint = NSLayoutConstraint()
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
            $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        }
        jobLabel.do {
            $0.textColor = UIColor.Black()
            $0.font = UIFont(name: "Pretendard-Regular", size: 13)        }
        contentLabel.do {
            $0.textColor = UIColor.Black()
            $0.font = UIFont(name: "Pretendard-Regular", size: 17)
        }
        dateTimeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        dateLabel.do {
            $0.textColor = UIColor.G2()
            $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        }
        timeLabel.do {
            $0.textColor = UIColor.G2()
            $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        }
        recommentButton.do {
            $0.setTitleColor(UIColor.G2(), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
            $0.contentHorizontalAlignment = .right
            $0.setTitle("답글쓰기", for: .normal)
        }
    }
    private func setLayout() {
        addSubviews(cellStackView)
        cellStackView.addArrangedSubviews(nameJobStackView,contentLabel,dateTimeStackView)
        cellStackView.snp.makeConstraints {
//            $0.leading.equalToSuperview()
            var levelConstraint = $0.leading.equalToSuperview().offset(0).constraint
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
        }
        nameJobStackView.addArrangedSubviews(nicknameLabel, jobLabel)
        dateTimeStackView.addArrangedSubviews(dateLabel,timeLabel,recommentButton)
    }
    func configureCell(_ data: DisplayComment) {
        nicknameLabel.text = data.comment.writer.nickName
        jobLabel.text = data.comment.writer.occupation
        contentLabel.text = data.comment.content
        dateLabel.text = data.comment.getDateString()
        timeLabel.text = data.comment.getTimeString()
        
        if data.level != 0 {
            recommentButton.isHidden = true
        }
        
        let indentationWidth: CGFloat = 30
            levelConstraint.constant = indentationWidth * CGFloat(data.level)
    }
}
