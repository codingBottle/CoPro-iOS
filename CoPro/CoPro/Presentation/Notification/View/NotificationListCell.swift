//
//  NotificationListCell.swift
//  CoPro
//
//  Created by 박현렬 on 2/22/24.
//

import UIKit
import SnapKit
import Then

class NotificationListCell: UITableViewCell {

    let titleLabel = UILabel().then {
        $0.setPretendardFont(text: "", size: 13, weight: .regular, letterSpacing: 1.25)
        }
    let iconImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor.P2()
        }
    
        let messageLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = .gray
            $0.numberOfLines = 2
        }
        
        let timeLabel = UILabel().then {
            $0.setPretendardFont(text: "", size: 9, weight: .regular, letterSpacing: 1.25)
            $0.textColor = .lightGray
            $0.textAlignment = .right
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupViews()
            setLayoutConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupViews() {
            contentView.addSubview(titleLabel)
            contentView.addSubview(iconImageView)
//            contentView.addSubview(messageLabel)
            contentView.addSubview(timeLabel)
            contentView.backgroundColor = UIColor.White()
        }

        private func setLayoutConstraints() {
            iconImageView.snp.makeConstraints {
                        $0.leading.equalToSuperview().offset(15)
                        $0.centerY.equalToSuperview()
                        $0.width.height.equalTo(20) // 적절한 크기로 설정
                    }
            titleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.left.equalTo(iconImageView.snp.right).offset(10)
                $0.centerY.equalToSuperview()
            }

//            messageLabel.snp.makeConstraints {
//                $0.top.equalTo(titleLabel.snp.bottom).offset(5)
//                $0.leading.trailing.equalTo(titleLabel)
//            }
//
            timeLabel.snp.makeConstraints {
//                $0.top.equalTo(titleLabel.snp.bottom).offset(10)
//                $0.left.equalTo(iconImageView.snp.right).offset(10)
//                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-15)
                $0.bottom.equalToSuperview().offset(-10)
            }
        }}
