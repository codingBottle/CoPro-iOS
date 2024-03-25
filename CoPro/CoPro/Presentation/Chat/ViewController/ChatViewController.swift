//
//  ChatViewController.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Photos
import FirebaseFirestore
import FirebaseAuth
import SnapKit
import KeychainSwift

class ChatViewController: MessagesViewController {
    
   let alertVC = OppositeInfoCardViewController()
   let keychain = KeychainSwift()
   var channelId: String?
   var avatarView: AvatarView?
   var targetEmail: String?
   
   var chatAvatarImage = AvatarView().then {
      $0.clipsToBounds = true
   }
   
   private let currentUserNickName: String
   private let titleName: String
    let chatFirestoreStream = ChatFirestoreStream()
    let channel: Channel
    var messages = [Message]()
    private var isSendingPhoto = false {
      didSet {
        messageInputBar.leftStackViewItems.forEach { item in
          guard let item = item as? InputBarButtonItem else {
            return
          }
          item.isEnabled = !self.isSendingPhoto
        }
      }
    }
    
   init(currentUserNickName: String, channel: Channel, titleName: String) {
        self.currentUserNickName = currentUserNickName
        self.channel = channel
      self.titleName = titleName
        super.init(nibName: nil, bundle: nil)
        title = self.titleName
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    deinit {
        chatFirestoreStream.removeListener()
        navigationController?.navigationBar.prefersLargeTitles = true
       NotificationCenter.default.removeObserver(self)
    }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
      confirmDelegates()
      configure()
      setupMessageInputBar()
      removeOutgoingMessageAvatars()
      removeincomingMessageAvatars()
      listenToMessages()
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      tapGesture.cancelsTouchesInView = false
      messagesCollectionView.addGestureRecognizer(tapGesture)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
   }
   
   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       self.messagesCollectionView.scrollToLastItem(animated: true)
   }
   
   @objc func keyboardWillShow(_ notification: Notification) {
      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
         return
      }
      messagesCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
      messagesCollectionView.scrollIndicatorInsets = messagesCollectionView.contentInset
      messagesCollectionView.scrollToLastItem(animated: true)
   }
       
   @objc func keyboardWillHide(_ notification: Notification) {
      messagesCollectionView.contentInset = .zero
      messagesCollectionView.scrollIndicatorInsets = .zero
   }
    
   
   
   

    private func confirmDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
    }
    
    //채팅창 상단 이름
    private func configure() {

       let titleLabel = UILabel().then {
          $0.setPretendardFont(text: channel.sender, size: 17, weight: .bold, letterSpacing: 1.25)
          $0.textAlignment = .center
          $0.text = self.titleName
       }

       let subtitleLabel = UILabel().then {
          $0.setPretendardFont(text: channel.receiverJobTitle, size: 11, weight: .regular, letterSpacing: 1)
          $0.textAlignment = .center
       }
       

        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
       
       titleView.snp.makeConstraints {
           $0.width.equalTo(110)
          $0.height.equalTo(40)
           $0.centerX.equalTo(titleLabel)
       }
       
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
           $0.height.equalTo(23)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
           $0.height.equalTo(13)
        }
       
       let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(titleViewTapped))
           titleView.isUserInteractionEnabled = true
           titleView.addGestureRecognizer(tapGestureRecognizer)

        navigationItem.titleView = titleView
    }

    
    private func setupMessageInputBar() {
        messageInputBar.inputTextView.tintColor = .primary
        messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
        messageInputBar.inputTextView.placeholder = "Aa"
    }
    
    private func removeOutgoingMessageAvatars() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.setMessageOutgoingAvatarSize(.zero)
        let outgoingLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
   
   private func removeincomingMessageAvatars() {
       guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
       layout.textMessageSizeCalculator.incomingAvatarSize = .zero
       layout.setMessageIncomingAvatarSize(.zero)
       let incomingLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
       layout.setMessageIncomingMessageTopLabelAlignment(incomingLabelAlignment)
   }
    
   
   //MARK: - 사진 직접 찍어 보내는 기능
   
   /* private func addCameraBarButtonToMessageInputBar() {
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraBarButtonItem], forStack: .left, animated: false)
    } */
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messages.sort()
        
        messagesCollectionView.reloadData()
    }
    
    private func listenToMessages() {
        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        chatFirestoreStream.subscribe(id: id) { [weak self] result in
            switch result {
            case .success(let messages):
                self?.loadImageAndUpdateCells(messages)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadImageAndUpdateCells(_ messages: [Message]) {
        messages.forEach { message in
            var message = message
            if let url = message.downloadURL {
                FirebaseStorageManager.downloadImage(url: url) { [weak self] image in
                    guard let image = image else { return }
                    message.image = image
                    self?.insertNewMessage(message)
                }
            } else {
                insertNewMessage(message)
            }
        }
    }
   
   private func loadOppositeInfo(email: String) {
       guard let token = self.keychain.get("accessToken") else {return}
         
       OppositeInfoAPI.shared.getOppositeInfo(token: token, email: email) { result in
           switch result {
           case .success(let data):
               DispatchQueue.main.async {
                   let alertVC = OppositeInfoCardViewController()
                   if let data = data as? OppositeInfoDTO {
                       let data = data.data
                      alertVC.oppositeInfoCardViewConfigure(with: data.picture, nickname: data.nickName, occupation: data.occupation, language: data.language, likeCount: data.likeMembersCount, isLike: data.isLikeMembers, memberID: data.memberID)
                      alertVC.modalPresentationStyle = .formSheet
                       // API 호출이 성공적으로 끝나고 나서 present를 합니다.
                       self.present(alertVC, animated: true, completion: nil)
                   } else {
                       print("Failed to decode the response.")
                   }
               }
           case .requestErr(let message):
               // 요청 에러인 경우
               print("Error : \(message)")
           case .pathErr, .serverErr, .networkFail:
               // 다른 종류의 에러인 경우
               print("Another Error")
           default:
               break
           }
       }
   }
   
   @objc func titleViewTapped() {
       print("Title view tapped")
       loadOppositeInfo(email: targetEmail ?? "")
   }
   
    
    @objc private func didTapCameraButton() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true)
    }
   
   
   
   @objc override func dismissKeyboard() {
       view.endEditing(true)
       messageInputBar.resignFirstResponder()
   }
   
   
   
}

extension ChatViewController: MessagesDataSource {
    
    var currentSender: MessageKit.SenderType {
       return Sender(senderId: currentUserNickName, displayName: UserDefaultManager.displayName)
    }
    
    func cellForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        _ = messages[indexPath.section]
        
        return messagesCollectionView.dequeueReusableCell(MessageContentCell.self, for: indexPath)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    private func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return messagesCollectionView.dequeueReusableCell(MessageContentCell.self, for: indexPath)
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    
   func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
      
      let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
      return .bubbleTail(cornerDirection, .pointedEdge)
   }
    
    // 아래 여백
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    // 말풍선 위 이름 나오는 곳의 height
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if isLastMessageInTimeGroup(at: indexPath) {
            return 20
        }else {
            return 0 // 같은 시간대의 메시지는 0을 리턴
        }
    }
    
    func messageBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
        if isFromCurrentSender(message: message) {
            return LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
}

// 상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정
extension ChatViewController: MessagesDisplayDelegate {
   
   func configureTapGesture(_ gestureRecognizer: UITapGestureRecognizer, for message: MessageType, at indexPath: IndexPath) {
           gestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
       }
    
    func isFirstMessageInTimeGroup(at indexPath: IndexPath) -> Bool {
        guard indexPath.section > 0 else {
            // 현재 섹션이 첫 번째 섹션인 경우 항상 true 반환
            return true
        }
        
        let currentMessage = messages[indexPath.section]
        let previousMessage = messages[indexPath.section - 1]
        
        // 현재 메시지의 sentDate와 이전 메시지의 sentDate 비교하여 같은 시간대인지 확인
        let calendar = Calendar.current
        let isSameTimeGroup = calendar.isDate(currentMessage.sentDate, equalTo: previousMessage.sentDate, toGranularity: .minute)
        
        // 이전 메시지와 다른 시간대이면 true 반환 (시간대의 첫 번째 메시지)
        return !isSameTimeGroup
    }
    
   // 아바타뷰 설정 (프로필 사진)
   func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
      DispatchQueue.main.async {
         avatarView.frame.origin.y = 0 // 아바타뷰를 동일 시간대 메시지 맨 위에 배치
         
         let isFirstMessageInGroup = self.isFirstMessageInTimeGroup(at: indexPath)
         if isFirstMessageInGroup {
            avatarView.isHidden = true
            avatarView.image = self.chatAvatarImage.image
         } else {
            avatarView.isHidden = true
         }
      }
      
    }
    
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primary : .incomingMessageBackground
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
    }
    
    func isLastMessageInTimeGroup(at indexPath: IndexPath) -> Bool {
        guard indexPath.section < messages.count - 1 else {
            return true
        }
        
        let currentMessage = messages[indexPath.section]
        let nextMessage = messages[indexPath.section + 1]
        
        return !Calendar.current.isDate(currentMessage.sentDate, equalTo: nextMessage.sentDate, toGranularity: .minute)
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let isLastMessageInGroup = isLastMessageInTimeGroup(at: indexPath)
        
        if isLastMessageInGroup {
            let sentDate = message.sentDate
            let dateString = dateFormatter.string(from: sentDate)
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11),
                .foregroundColor: UIColor.gray
            ]
            
            return NSAttributedString(string: dateString, attributes: attributes)
        } else {
            return nil
        }
    }
    
    func messageContainerSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return MessageSizeCalculator().messageContainerSize(for: message, at: indexPath)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
   func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
      let message = Message(user: currentUserNickName, content: text)
      
      //여기가 chat 넘기는 곳.
      chatFirestoreStream.save(message) { [weak self] error in
         if let error = error {
            print(error)
            return
         }
         self?.postChatNotification(content: message.content)
         self?.messagesCollectionView.scrollToLastItem()
      }
      inputBar.inputTextView.text.removeAll()
   }
   
   
   func postChatNotification(content: String) {
       guard let token = self.keychain.get("accessToken") else {
           print("No accessToken found in keychain.")
           return }
      guard let targetEmail = targetEmail else {return print("postChatNotification 안에 targetEmail 설정 에러")}
      print("🔥🔥🔥🔥🔥🔥🔥현재 targetEmail : \(targetEmail)🔥🔥🔥🔥🔥🔥🔥🔥🔥")
      
      NotificationAPI.shared.postChatNotification(token: token,
                                                  requestBody: ChattingNotificationRequestBody(targetMemberEmail: targetEmail, title: currentUserNickName, body: content, data: ChattingNotificationDataClass(channelId: channelId ?? "error"))) { result in
           switch result {
           case .success(_):
              print("postChatNotification 보내기 성공")
               
           case .requestErr(let message):
               // 요청 에러인 경우
               print("Error : \(message)")
              if (message as AnyObject).contains("401") {
                   // 만료된 토큰으로 인해 요청 에러가 발생한 경우
               }
           case .pathErr, .serverErr, .networkFail:
               // 다른 종류의 에러인 경우
               print("another Error")
           default:
               break
           }
       }
   }
   
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let asset = info[.phAsset] as? PHAsset {
            let imageSize = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(for: asset,
                                                     targetSize: imageSize,
                                                     contentMode: .aspectFit,
                                                     options: nil) { image, _ in
                guard let image = image else { return }
                self.sendPhoto(image)
            }
        } else if let image = info[.originalImage] as? UIImage {
            sendPhoto(image)
        }
    }
    
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        FirebaseStorageManager.uploadImage(image: image, channel: channel) { [weak self] url in
            self?.isSendingPhoto = false
           var message = Message(user: self?.currentUserNickName  ?? "", image: image)
            message.downloadURL = url
            self?.chatFirestoreStream.save(message)
            self?.messagesCollectionView.scrollToLastItem()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

