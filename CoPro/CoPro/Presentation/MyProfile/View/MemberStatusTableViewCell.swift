//
//  MemberStatusTableViewCell.swift
//  CoPro
//
//  Created by 박현렬 on 2/29/24.
//

import UIKit
import SnapKit
import Then
protocol EditMemberStatusButtonDelegate: AnyObject {
    func didTapEditMemberStatusButtonTapped(in cell: MemberStatusTableViewCell)
}

class MemberStatusTableViewCell: UITableViewCell {
    
    weak var delegate: EditMemberStatusButtonDelegate?
    
    let labelContainer: UIView = UIView()
    
   let titleLabel = UILabel().then {
      $0.setPretendardFont(text: "계정 설정", size: 17, weight: .medium, letterSpacing: 1.25)
   }

    let subTitleLabel = UILabel().then {
       $0.setPretendardFont(text: "로그아웃, 또는 회원탈퇴를 진행할 수 있어요.", size: 13, weight: .regular, letterSpacing: 0.8)
       $0.textColor = UIColor.G3()
    }
    let greaterthanContainer: UIView = UIView()
    
    let greaterthanButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.contentVerticalAlignment = .fill
        $0.contentHorizontalAlignment = .fill
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        selectedBackgroundView = UIView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        contentView.addSubviews(labelContainer, greaterthanContainer)
        greaterthanContainer.isUserInteractionEnabled = true
        labelContainer.addSubviews(titleLabel, subTitleLabel)
        greaterthanContainer.addSubviews(greaterthanButton)
        greaterthanButton.addTarget(self, action: #selector(didTapEditMemberStatusButtonTapped), for: .touchUpInside)
        
        labelContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(greaterthanContainer.snp.leading)
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
        
       greaterthanContainer.snp.makeConstraints {
           $0.centerY.equalToSuperview()
           $0.trailing.equalToSuperview().offset(-16)
           $0.width.equalTo(20)
           $0.height.equalTo(20)
       }
       
       greaterthanButton.snp.makeConstraints {
           $0.centerY.equalToSuperview()
           $0.trailing.equalToSuperview()
           $0.width.equalTo(10)
           $0.height.equalTo(13)
       }
    }
    
    @objc func didTapEditMemberStatusButtonTapped(_ sender: UIButton) {
        delegate?.didTapEditMemberStatusButtonTapped(in: self)
    }
}

