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
    func configureCell(_ data: CommentData) {
        nicknameLabel.text = data.writer.nickName
        jobLabel.text = data.writer.occupation
        contentLabel.text = data.content
        
        if data.parentId == -1 {
                cellStackView.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(30)  // 여기서 30은 원하는 들여쓰기 크기입니다.
                }
            } else {
                cellStackView.snp.updateConstraints {
                    $0.leading.equalToSuperview()
                }
            }

            // 대댓글 버튼 표시 여부 결정 코드
            recommentButton.isHidden = Bool(data.parentId == -1)
    }
}
