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
            $0.textColor = UIColor(red: 0.429, green: 0.432, blue: 0.446, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        }
        jobLabel.do {
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Regular", size: 13)        }
        contentLabel.do {
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Regular", size: 17)
        }
        dateTimeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        dateLabel.do {
            $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        }
        timeLabel.do {
            $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        }
        recommentButton.do {
            $0.setTitleColor(UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
            $0.contentHorizontalAlignment = .right
            $0.setTitle("답글쓰기", for: .normal)
        }
        
    }
    private func setLayout() {
        addSubviews(cellStackView)
        cellStackView.addArrangedSubviews(nameJobStackView,contentLabel,dateTimeStackView)
        cellStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
        }
        nameJobStackView.addArrangedSubviews(nicknameLabel, jobLabel)
        dateTimeStackView.addArrangedSubviews(dateLabel,timeLabel,recommentButton)
    }
    func configureCell(_ data: CommentData, isChild: Bool = false) {
        nicknameLabel.text = data.writer.nickName
        jobLabel.text = data.writer.occupation
        contentLabel.text = data.content

        // 대댓글의 경우에는 들여쓰기를 적용합니다.
        if isChild {
            cellStackView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20) // 추가적인 여백
                // 나머지 제약 조건
            }
        } else {
            cellStackView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                // 나머지 제약 조건
            }
        }

        // 대댓글이 있는 경우에는 대댓글을 표시하는 로직을 추가합니다.
        if let children = data.children {
            for childComment in children {
                let childCommentCell = commentTableViewCell()
                childCommentCell.configureCell(childComment, isChild: true)
                // childCommentCell을 적절한 위치에 추가합니다.
            }
        }
    }
}
