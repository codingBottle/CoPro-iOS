//
//  MyProfileTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 1/11/24.
//

import UIKit
import SnapKit
import Then

protocol MyProfileTableViewButtonDelegate: AnyObject {
    func didTapEditGitHubURLButton(in cell: MyProfileTableViewCell)
    func didTapWritebyMeButtonTapped(in cell: MyProfileTableViewCell)
    func didTapMyWrittenCommentButtonTapped(in cell: MyProfileTableViewCell)
    func didTapInterestedPostButtonTapped(in cell: MyProfileTableViewCell)
    func didTapInterestedProfileButtonTapped(in cell: MyProfileTableViewCell)
}

class MyProfileTableViewCell: UITableViewCell {
    
    weak var delegate: MyProfileTableViewButtonDelegate?
    
   let titleLabel = UILabel().then {
      $0.setPretendardFont(text: "test", size: 17, weight: .regular, letterSpacing: 1.25)
   }
    
    let heartContainer: UIView = UIView()
        
    let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(systemName: "heart.fill") {
            imageView.image = image
        }
        return imageView
    }()
    
    let heartCountLabel = UILabel().then {
       $0.setPretendardFont(text: "test", size: 17, weight: .regular, letterSpacing: 1.25)
       $0.textColor = UIColor.P2()
    }
    
    let greaterthanContainer: UIView = UIView()
    
    let greaterthanButton = UIButton().then {
        $0.setImage(UIImage(systemName: "greaterthan"), for: .normal)
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
}

extension MyProfileTableViewCell {
    private func setLayout() {
        contentView.addSubviews(titleLabel, heartContainer, greaterthanContainer)
        
        heartContainer.addSubviews(heartImageView, heartCountLabel)
        greaterthanContainer.addSubviews(greaterthanButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        heartContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(340)
            $0.width.equalTo(54)
        }
        
        heartImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(20)
            $0.height.equalTo(17.5)
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(heartImageView)
            $0.leading.equalTo(heartImageView.snp.trailing).offset(3)
            $0.trailing.equalToSuperview()
        }
        
        greaterthanContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(54)
            $0.height.equalTo(50)
        }
        
        greaterthanButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(12)
            $0.height.equalToSuperview().dividedBy(6)
        }
        
    }
    
    func configureButton(at index: Int) {
            
            // 인덱스에 따라 버튼에 다른 액션을 부여합니다.
            switch index {
            case 1:
                greaterthanButton.addTarget(self, action: #selector(didTapEditGitHubURLButtonTapped), for: .touchUpInside)
            case 2:
                greaterthanButton.addTarget(self, action: #selector(didTapMyWrittenPostButtonTapped), for: .touchUpInside)
                
            case 3:
                greaterthanButton.addTarget(self, action: #selector(didTapMyWrittenCommentButtonTapped), for: .touchUpInside)
                
            case 4:
                greaterthanButton.addTarget(self, action: #selector(didTapInterestedPostButtonTapped), for: .touchUpInside)
                
            case 5:
                greaterthanButton.addTarget(self, action: #selector(didTapInterestedProfileButtonTapped), for: .touchUpInside)
            default:
                break
            }
        }
    
    // githuburl 수정
    @objc func didTapEditGitHubURLButtonTapped(_ sender: UIButton) {
        delegate?.didTapEditGitHubURLButton(in: self)
    }
    
    // 작성한 게시물
    @objc func didTapMyWrittenPostButtonTapped(_ sender: UIButton) {
        delegate?.didTapWritebyMeButtonTapped(in: self)
    }
    
    // 작성한 댓글
    @objc func didTapMyWrittenCommentButtonTapped(_ sender: UIButton) {
        delegate?.didTapMyWrittenCommentButtonTapped(in: self)
    }
    
    // 관심 게시물
    @objc func didTapInterestedPostButtonTapped(_ sender: UIButton) {
        delegate?.didTapInterestedPostButtonTapped(in: self)
    }
    
    // 관심 프로필
    @objc func didTapInterestedProfileButtonTapped(_ sender: UIButton) {
        delegate?.didTapInterestedProfileButtonTapped(in: self)
    }
}
