//
//  MiniCardGridView.swift
//  CoPro
//
//  Created by 박현렬 on 1/23/24.
//

import UIKit
import SnapKit
import Then
import KeychainSwift

protocol MiniCardGridViewDelegate: AnyObject {
    func didTapChatButtonOnMiniCardGridView(in cell: MiniCardGridView, success: Bool)
}

class MiniCardGridView: UICollectionViewCell {
    private let channelStream = ChannelFirestoreStream()
    let miniCardView = MiniCard()
    var gitButtonURL: String?
    var likeMemberId: Int?
    var likeCount: Int?
    var isLike: Bool!
   var imageURL: String?
   var email: String?
   weak var MiniCardGridViewdelegate: MiniCardGridViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGitButtonTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(miniCardView)
        miniCardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func setupGitButtonTarget() {
        miniCardView.gitButton.addTarget(self, action: #selector(gitButtonTapped), for: .touchUpInside)
        miniCardView.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeIconTapped))
        miniCardView.likeIcon.addTarget(self, action: #selector(likeIconTapped), for: .touchUpInside)
        miniCardView.likeLabel.isUserInteractionEnabled = true
        miniCardView.likeLabel.addGestureRecognizer(tapGesture)
        //        miniCardView.likeIcon.addGestureRecognizer(tapGesture)
        
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
   @objc func chatButtonTapped(_ sender: UIButton) {
      print("Chat 버튼이 눌렸습니다.")
      let keychain = KeychainSwift()
      guard let receiverurl = imageURL, let receiverEmail = email else {return}
          
      guard let currentUserNickName = keychain.get("currentUserNickName") else {return}
      guard let currentUserProfileImage = keychain.get("currentUserProfileImage") else {return}
      guard let currentUserOccupation = keychain.get("currentUserOccupation") else {return}
      var channelId = [currentUserNickName, miniCardView.userNameLabel.text ?? ""].sorted().joined(separator: "-")
      
      channelStream.createChannel(channelId: channelId, sender: currentUserNickName, senderJobTitle: currentUserOccupation, senderProfileImage: currentUserProfileImage, receiver: miniCardView.userNameLabel.text ?? "", receiverJobTitle: miniCardView.userPartLabel.text ?? "", receiverProfileImage: receiverurl, receiverEmail: receiverEmail) {error in
         if let error = error {
            // 실패: 오류 메시지를 출력하거나 사용자에게 오류 상황을 알립니다.
            print("Failed to create channel: \(error.localizedDescription)")
            self.MiniCardGridViewdelegate?.didTapChatButtonOnMiniCardGridView(in: self, success: false)
         } else {
            // 성공: 채팅 버튼을 탭하거나 필요한 다른 동작을 수행합니다.
            self.MiniCardGridViewdelegate?.didTapChatButtonOnMiniCardGridView(in: self, success: true)
         }
      }
      
   }
   
    //좋아요 아이콘을 터치했을 때 실행되는 메서드
    @objc func likeIconTapped() {
        if isLike == true{
            CardAPI.shared.cancelLike(MemberId:likeMemberId!) { success in
                if success {
                    // API 호출이 성공하면 UI 업데이트
                    DispatchQueue.main.async {
                        guard let currentCount = Int(self.miniCardView.likeLabel.text ?? "0") else { return }
                        let newCount = currentCount - 1
                        self.miniCardView.likeLabel.text = "\(newCount)"
                        self.miniCardView.likeIcon.tintColor = UIColor.G3() // 아이콘 색상을 파란색으로 변경
                        self.miniCardView.likeLabel.textColor = UIColor.G3() // 라벨 색상을 파란색으로 변경
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
                        guard let currentCount = Int(self.miniCardView.likeLabel.text ?? "0") else { return }
                        let newCount = currentCount + 1
                        self.miniCardView.likeLabel.text = "\(newCount)"
                        self.miniCardView.likeIcon.tintColor = UIColor.P2() // 아이콘 색상을 파란색으로 변경
                        self.miniCardView.likeLabel.textColor = UIColor.P2() // 라벨 색상을 파란색으로 변경
                        
                        
                        print("좋아요 후 좋아요 수 \(String(describing: self.likeCount))")
                        
                        self.isLike = true
                        print("좋아요 여부 \(String(describing: self.isLike))")
                    }
                }
            }
        }
        
    }
    
   func configure(with imageUrl: String,nickname: String, occupation: String, language: String,old: Int,gitButtonURL: String,likeCount: Int,memberId: Int,isLike: Bool, email: String) {
      self.email = email
        self.gitButtonURL = gitButtonURL
        self.imageURL = imageUrl
        miniCardView.loadImage(url: imageUrl)
        miniCardView.userNameLabel.text = nickname
        miniCardView.userPartLabel.text = occupation
        miniCardView.userLangLabel.text = language
        switch old {
        case 1:
            miniCardView.userCareerLabel.text = "신입"
        case 2:
            miniCardView.userCareerLabel.text = "3년 미만"
        case 3:
            miniCardView.userCareerLabel.text = "3년 이상"
        case 4:
            miniCardView.userCareerLabel.text = "5년 이상"
        case 5:
            miniCardView.userCareerLabel.text = "10년 이상"
        default:
            miniCardView.userCareerLabel.text = "신입"
        }
        miniCardView.likeLabel.text = String(likeCount)
        self.likeCount = likeCount
        self.likeMemberId = memberId
        self.isLike = isLike
        if isLike == true {
            self.miniCardView.likeIcon.tintColor = UIColor.P2() // 아이콘 색상을 파란색으로 변경
            self.miniCardView.likeLabel.textColor = UIColor.P2()
        }else{
            self.miniCardView.likeIcon.tintColor = UIColor.G3() // 아이콘 색상을 파란색으로 변경
            self.miniCardView.likeLabel.textColor = UIColor.G3()
        }
    }
}
