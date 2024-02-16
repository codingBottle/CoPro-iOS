//
//  ConversionSettingsTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 1/11/24.
//

import UIKit
import SnapKit
import Then

class ConversionSettingsTableViewCell: UITableViewCell {
    
    let labelContainer: UIView = UIView()
    
    let titleLabel: UILabel = UILabel()

    let subTitleLabel: UILabel = UILabel()
    
//    let subTitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Pretendard-Regular", size: 13)
//        label.textColor = UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1)
//        label.text = "협업할 개발자 프로필을 카드뷰나 목록으로 확인할 수 있습니다."
//        return label
//    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let greaterthanLabel: UILabel = {
        let label = UILabel()
        label.text = ">"
        label.font = UIFont(name: "Pretendard-Regular", size: 17)
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.init(hex: "#2577FE")
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        selectedBackgroundView = UIView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        titleLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.23
            $0.attributedText = NSMutableAttributedString(string: "개발자 프로필 화면 설정", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont(name: "Pretendard-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)])
        }
        
        subTitleLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.23
            $0.attributedText = NSMutableAttributedString(string: "협업할 개발자 프로필을 카드뷰나 목록으로 확인할 수 있습니다.", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont(name: "Pretendard-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)])
        }

        
        addSubviews(labelContainer, greaterthanLabel)
        labelContainer.addSubviews(titleLabel, subTitleLabel)
        
        labelContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(greaterthanLabel.snp.leading)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        greaterthanLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(12)
            $0.height.equalTo(17)
        }
    }
}
