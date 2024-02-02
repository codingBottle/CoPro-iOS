//
//  CardCollectionCellView.swift
//  CoPro
//
//  Created by 박현렬 on 1/22/24.
//

import UIKit
import SnapKit
import Then

class CardCollectionCellView: UICollectionViewCell {
    let slideCardView = SlideCardView()
    var gitButtonURL: String?
    var likeMemberId: Int?
    var likeCount: Int?
    var isLike: Bool!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(slideCardView)
        slideCardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isLike = nil
    }
    private func setupAddTarget() {
        slideCardView.gitButton.addTarget(self, action: #selector(gitButtonTapped), for: .touchUpInside)
        slideCardView.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        // 아이콘을 터치했을 때의 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeIconTapped))
        slideCardView.likeIcon.addGestureRecognizer(tapGesture)
    }
    
    //Github버튼 동작 메소드
    @objc func gitButtonTapped() {
        if let gitURL = gitButtonURL {
            print("Git 버튼이 눌렸습니다. URL: \(gitURL)")
            // Open the URL in Safari
            if gitButtonURL == " "{
                print("URL미등록")
            }else{
                UIApplication.shared.open(URL(string: gitButtonURL!)!, options: [:], completionHandler: nil)
            }
        } else {
            print("Git 버튼이 눌렸지만 URL이 없습니다.")
        }
    }
    //Chat버튼 동작 메소드
    @objc func chatButtonTapped() {
        print("Chat 버튼이 눌렸습니다.")
    }
    //좋아요 아이콘을 터치했을 때 실행되는 메서드
    @objc func likeIconTapped() {
        if isLike == true{
            CardAPI.shared.cancelLike(MemberId:likeMemberId!) { success in
                if success {
                    // API 호출이 성공하면 UI 업데이트
                    DispatchQueue.main.async {
                        guard let currentCount = Int(self.slideCardView.likeLabel.text ?? "0") else { return }
                        let newCount = currentCount - 1
                        self.slideCardView.likeLabel.text = "\(newCount)"
                        self.slideCardView.likeIcon.tintColor = UIColor.G1()
                        self.slideCardView.likeLabel.textColor = UIColor.White()
                        print("좋아요 취소 후 좋아요 수 \(String(describing: self.likeCount))")
                        self.isLike = false
                        print("좋아요 여부 \(String(describing: self.isLike))")
                    }
                }
            }
            
        }else{
            CardAPI.shared.addLike(MemberId:likeMemberId!) { success in
                if success {
                    // API 호출이 성공하면 UI 업데이트
                    DispatchQueue.main.async {
                        guard let currentCount = Int(self.slideCardView.likeLabel.text ?? "0") else { return }
                        let newCount = currentCount + 1
                        self.slideCardView.likeLabel.text = "\(newCount)"
                        self.slideCardView.likeIcon.tintColor = UIColor.P2() // 아이콘 색상을 파란색으로 변경
                        self.slideCardView.likeLabel.textColor = UIColor.P2() // 라벨 색상을 파란색으로 변경
                        
                        
                        print("좋아요 후 좋아요 수 \(String(describing: self.likeCount))")
                        
                        self.isLike = true
                        print("좋아요 여부 \(String(describing: self.isLike))")
                    }
                }
            }
        }
        
    }
    
    func configure(with imageUrl: String,name: String, occupation: String, language: String,gitButtonURL: String,likeCount: Int,memberId: Int,isLike: Bool) {
        self.gitButtonURL = gitButtonURL
        slideCardView.loadImage(url: imageUrl)
        slideCardView.userNameLabel.text = name
        slideCardView.userPartLabel.text = occupation
        slideCardView.userLangLabel.text = language
        slideCardView.likeLabel.text = String(likeCount)
        self.likeCount = likeCount
        self.likeMemberId = memberId
        self.isLike = isLike
        print("configure IsLike\(isLike)")
        if isLike == true {
            self.slideCardView.likeIcon.tintColor = UIColor.P2()// 아이콘 색상을 파란색으로 변경
            self.slideCardView.likeLabel.textColor = UIColor.P2()
        }else{
            self.slideCardView.likeIcon.tintColor = UIColor.G1()// 아이콘 색상을 파란색으로 변경
            self.slideCardView.likeLabel.textColor = UIColor.White()
        }
    }
}
