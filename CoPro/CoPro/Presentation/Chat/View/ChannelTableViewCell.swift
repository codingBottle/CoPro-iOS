//
//  ChannelTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import UIKit
import SnapKit
import Then

class ChannelTableViewCell: UITableViewCell {
    
    var channel: Channel? {
            didSet {
                guard let channel = channel else { return }
                chatRoomLabel.text = channel.name
                projectChip.isHidden = !channel.isProject
            }
        }
    
    var isProject = false
    
    
    lazy var chatRoomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var projectChip: UILabel = {
        let chipLabel = PaddingLabel()
        chipLabel.text = "Project"
        chipLabel.font = UIFont.systemFont(ofSize: 14)
        chipLabel.backgroundColor = UIColor.lightGray
        chipLabel.textColor = UIColor.black
        chipLabel.textAlignment = .center
        chipLabel.layer.cornerRadius = 15
        chipLabel.clipsToBounds = true
        chipLabel.sizeToFit()
        return chipLabel
    }()
    
    lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        contentView.addSubview(chatRoomLabel)
        contentView.addSubview(projectChip)
        contentView.addSubview(detailButton)
        
        chatRoomLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
        
        projectChip.snp.makeConstraints {
            $0.leading.equalTo(chatRoomLabel.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(detailButton).offset(-24)
        }
        
        detailButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
}


class PaddingLabel: UILabel {
    var topInset: CGFloat = 5.0
    var bottomInset: CGFloat = 5.0
    var leftInset: CGFloat = 10.0
    var rightInset: CGFloat = 10.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
