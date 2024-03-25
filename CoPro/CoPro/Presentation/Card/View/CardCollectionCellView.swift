//
//  CardCollectionCellView.swift
//  CoPro
//
//  Created by 박현렬 on 1/22/24.
//

import UIKit
import SnapKit
import Then
import KeychainSwift

protocol CardCollectionCellViewDelegate: AnyObject {
    func didTapChatButtonOnCardCollectionCellView(in cell: CardCollectionCellView, success: Bool)
}

class CardCollectionCellView: UICollectionViewCell {
    private let channelStream = ChannelFirestoreStream()
    let slideCardView = SlideCardView()
    var gitButtonURL: String?
    var likeMemberId: Int?
    var likeCount: Int?
    var isLike: Bool!
    var imageURL: String?
    var email: String?
    weak var CardCollectionCellViewdelegate: CardCollectionCellViewDelegate?
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
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(40)
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
    
    //MARK: - Chat버튼 동작 메소드
    
    @objc func chatButtonTapped(_ sender: UIButton) {
        print("Chat 버튼이 눌렸습니다.")
        let keychain = KeychainSwift()
        guard let receiverurl = imageURL, let receiverEmail = email else {return}
        
        guard let currentUserNickName = keychain.get("currentUserNickName") else {return}
        guard let currentUserProfileImage = keychain.get("currentUserProfileImage") else {return}
        guard let currentUserOccupation = keychain.get("currentUserOccupation") else {return}
        guard let currentUserEmail = keychain.get("currentUserEmail") else {return}
        print("currentUserEmail : \(currentUserEmail)")
        let channelId = [currentUserEmail, receiverEmail].sorted().joined(separator: "-")
        
        channelStream.createChannel(channelId: channelId, sender: currentUserNickName, senderJobTitle: currentUserOccupation, senderProfileImage: currentUserProfileImage, senderEmail: currentUserEmail, receiver: slideCardView.userNameLabel.text ?? "", receiverJobTitle: slideCardView.userPartLabel.text ?? "", receiverProfileImage: receiverurl, receiverEmail: receiverEmail) {error in
            if let error = error {
                // 실패: 오류 메시지를 출력하거나 사용자에게 오류 상황을 알립니다.
                print("Failed to create channel: \(error.localizedDescription)")
                self.CardCollectionCellViewdelegate?.didTapChatButtonOnCardCollectionCellView(in: self, success: false)
            } else {
                // 성공: 채팅 버튼을 탭하거나 필요한 다른 동작을 수행합니다.
                self.CardCollectionCellViewdelegate?.didTapChatButtonOnCardCollectionCellView(in: self, success: true)
            }
        }
        
    }
    // 좋아요 버튼 누르기 횟수를 제한하는 변수
    var likeButtonEnabled = true
    //좋아요 아이콘을 터치했을 때 실행되는 메서드
    @objc func likeIconTapped() {
        // 좋아요 버튼이 활성화되어 있지 않으면 무시
        guard likeButtonEnabled else { return }
        
        // 좋아요 버튼 비활성화
        likeButtonEnabled = false
        if isLike == true{
            self.isLike = false
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
                        
                        print("좋아요 여부 \(String(describing: self.isLike))")
                    }
                }
            }
            
        }else{
            self.isLike = true
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
                        
                        
                        print("좋아요 여부 \(String(describing: self.isLike))")
                    }
                }
            }
        }
        // 1초 후에 좋아요 버튼 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.likeButtonEnabled = true
        }
        
    }
    
    func configure(with imageUrl: String, nickname: String, occupation: String, language: String,gitButtonURL: String,likeCount: Int,memberId: Int,isLike: Bool, email: String) {
        self.email = email
        self.gitButtonURL = gitButtonURL
        self.imageURL = imageUrl
        slideCardView.loadImage(url: imageUrl)
        slideCardView.userNameLabel.text = nickname
        slideCardView.userPartLabel.text = occupation
        slideCardView.userLangLabel.text = language
        slideCardView.likeLabel.text = String(likeCount)
        //직군에 따른 아이콘 변경
        switch occupation{
        case "Mobile":
            slideCardView.userPartImage.image = UIImage(named: "mobileIcon")
        case "Frontend":
            slideCardView.userPartImage.image = UIImage(named: "frontendIcon")
        case "Backend":
            slideCardView.userPartImage.image = UIImage(named: "backendIcon")
        case "AI":
            slideCardView.userPartImage.image = UIImage(named: "aiIcon")
        default:
            slideCardView.userPartImage.backgroundColor = .clear
        }
        self.likeCount = likeCount
        self.likeMemberId = memberId
        self.isLike = isLike
        if isLike == true {
            self.slideCardView.likeIcon.tintColor = UIColor.P2()// 아이콘 색상을 파란색으로 변경
            self.slideCardView.likeLabel.textColor = UIColor.P2()
        }else{
            self.slideCardView.likeIcon.tintColor = UIColor.G1()// 아이콘 색상을 파란색으로 변경
            self.slideCardView.likeLabel.textColor = UIColor.White()
        }
    }
}
