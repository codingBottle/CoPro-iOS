//
//  ChannelViewController.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import UIKit
import SnapKit
import FirebaseAuth
import Firebase
import KeychainSwift

class ChannelViewController: BaseViewController {
   
    lazy var channelTableView: UITableView = {
        let view = UITableView()
        view.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.className)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    var channels = [Channel]()
    private let currentUserNickName: String
    private let channelStream = ChannelFirestoreStream()
    private var currentChannelAlertController: UIAlertController?
    
   private let titleLabel = UILabel().then {
      $0.setPretendardFont(text: "채팅", size: 25, weight: .bold, letterSpacing: 1.25)
   }
   
   private var topContainerView = UIView().then {
      $0.isUserInteractionEnabled = true
   }
    
   private let toggleLabel = UILabel().then {
       $0.setPretendardFont(text: "프로젝트 채팅만 보기", size: 13, weight: .semibold, letterSpacing: 1)
    }
    
   lazy private var projectToggleSwitch = UISwitch().then {
      $0.isOn = self.isProjectEnabled
      $0.addTarget(self, action: #selector(didToggleSwitch(_:)), for: .valueChanged)
   }
   
   private let containerToEmptyLabel = UIView()
   
   private let emptyLabel = UILabel().then {
      $0.setPretendardFont(text: "개설된 채팅창이 없어요!\n프로젝트 모집글을 보고\n연락을 시작해보세요.", size: 17, weight: .regular, letterSpacing: 1.25)
      $0.textColor = UIColor.Black()
      $0.textAlignment = .center
      $0.numberOfLines = 0
   }

    
    private var isProjectEnabled: Bool = false {
        willSet {
            print("\n토글로 바뀌기전 willSet isProjectEnabled : \(isProjectEnabled) \n")
        }
    }
   
    init(currentUserNickName: String) {
        self.currentUserNickName = currentUserNickName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        channelStream.removeListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = .white
        addToolBarItems()
       navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
       navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
       navigationController?.navigationBar.prefersLargeTitles = false
       navigationController?.isToolbarHidden = false // 툴바 보이게 설정
        setupListener()
    }
   
   private func configureViews() {
          view.addSubview(topContainerView)
      topContainerView.isUserInteractionEnabled = true
          topContainerView.addSubview(toggleLabel)
          topContainerView.addSubview(projectToggleSwitch)

          topContainerView.snp.makeConstraints {
              $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
              $0.trailing.leading.equalToSuperview().inset(10)
             $0.height.equalTo(50)  // 높이 제약 추가
          }

          toggleLabel.snp.makeConstraints {
              $0.trailing.equalTo(projectToggleSwitch.snp.leading).offset(-10)
              $0.centerY.equalToSuperview()
          }

          projectToggleSwitch.snp.makeConstraints {
              $0.trailing.equalToSuperview()
              $0.centerY.equalToSuperview()
          }

      switch channels.count {
      case 0:
         channelTableView.removeFromSuperview()
         view.addSubview(containerToEmptyLabel)
         containerToEmptyLabel.addSubview(emptyLabel)
         
         containerToEmptyLabel.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(20)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
         }
         
         emptyLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
         }
      case 1...:
         containerToEmptyLabel.removeFromSuperview()

                 view.addSubview(channelTableView)

                 channelTableView.snp.makeConstraints {
                     $0.top.equalTo(topContainerView.snp.bottom).offset(20)
                     $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
                 }
      default:
         break
      }
   }
        
    private func addToolBarItems() {
        toolbarItems = [
          UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//          UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddItem)) 카메라버튼
        ]
    }
    
   private func setupListener() {
       channelStream.subscribe { [weak self] result in
           switch result {
           case .success(let data):
               self?.updateCell(to: data)

              DispatchQueue.main.async { [self] in
                   self?.configureViews()
               }
           case .failure(let error):
               print(error)
           }
       }
   }
    
    @objc func handleLefttPress(_ gestureRecognizer: UISwipeGestureRecognizer) {
       if gestureRecognizer.direction == .left {
            let touchPoint = gestureRecognizer.location(in: channelTableView)
            if let indexPath = channelTableView.indexPathForRow(at: touchPoint) {
                // 채널 삭제를 확인하는 alert를 표시합니다.
                let alert = UIAlertController(title: "채널 삭제", message: "해당 채팅방을 나가시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "채팅방 나가기", style: .destructive, handler: { _ in
                    // 채널을 삭제합니다.
                    let channel = self.channels[indexPath.row]
                    self.channelStream.deleteChannel(channel)
                }))
                present(alert, animated: true)
            }
        }
    }
    
    @objc private func didToggleSwitch(_ sender: UISwitch) {
        isProjectEnabled = sender.isOn
        print("토글버튼 눌림! : \(isProjectEnabled)")
        channelTableView.reloadData()
    }
   
          
    
    // MARK: - Update Cell
    
    private func updateCell(to data: [(Channel, DocumentChangeType)]) {
        data.forEach { (channel, documentChangeType) in
            switch documentChangeType {
            case .added:
                addChannelToTable(channel)
            case .modified:
                updateChannelInTable(channel)
            case .removed:
                removeChannelFromTable(channel)
            }
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
       let keychain = KeychainSwift()
       guard let currentUserNickName = keychain.get("currentUserNickName") else {return print("getLoginUserData 안에 currentUserNickName 설정 에러")}
       guard channels.contains(channel) == false else { return }
       
       
       if channel.sender == currentUserNickName || channel.receiver == currentUserNickName {
          channels.append(channel)
          channels.sort()
       }
               
               guard let index = channels.firstIndex(of: channel) else { return }
               channelTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)

    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels[index] = channel
        channelTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels.remove(at: index)
        channelTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
   
   func returnChannelTableCellHeight() -> CGFloat {
      let screenHeight = UIScreen.main.bounds.height
      let heightRatio = 82.0 / 852.0
      let cellHeight = screenHeight * heightRatio
      return cellHeight
   }
    
}

extension ChannelViewController: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return channels.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.className, for: indexPath) as! ChannelTableViewCell
//      cell.
      let keychain = KeychainSwift()
      if let currentUserNickName = keychain.get("currentUserNickName") {
         if channels[indexPath.row].sender == currentUserNickName {
            cell.chatRoomLabel.text = channels[indexPath.row].receiver
            cell.loadChannelProfileImage(url: channels[indexPath.row].receiverProfileImage)
         }
         else if channels[indexPath.row].receiver == currentUserNickName {
            cell.chatRoomLabel.text = channels[indexPath.row].sender
            cell.loadChannelProfileImage(url: channels[indexPath.row].senderProfileImage)
         }
      }
      
      
      cell.projectChipContainer.isHidden = true
      
      let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleLefttPress(_:)))
      swipeGestureRecognizer.direction = .left
      cell.addGestureRecognizer(swipeGestureRecognizer)
      
      return cell
      
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return returnChannelTableCellHeight()
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let cell = tableView.cellForRow(at: indexPath) as? ChannelTableViewCell {
         guard let profileImage = cell.loadedImage else {return print("엑시던트")}
         // 채널 정보를 가져옵니다. 수정해야함!
         let channel = channels[indexPath.row]
         print("🔥\(self.currentUserNickName)")
         
         //sender, receiver 둘 중 currentUserNickName이 어떤거든 간에 일단 채팅방 상대를 titlename에 넣어야함.
         
         // 현재 로그인한 유저가 송신자로 시작한 경우
         if self.currentUserNickName == channel.sender {
            print("현재 currentUserNickName == channel.sender")
            print("현재 : channel.senderEmail : \(channel.senderEmail)")
            print("현재 : channel.receiverEmail : \(channel.receiverEmail)")
            let viewController = ChatViewController(currentUserNickName: self.currentUserNickName, channel: channel, titleName: channel.receiver)
            viewController.channelId = [channel.senderEmail, channel.receiverEmail].sorted().joined(separator: "-")
            viewController.chatAvatarImage.image = profileImage
            viewController.targetEmail = channel.receiverEmail
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
         }
         
         else if self.currentUserNickName == channel.receiver {
            print("현재 currentUserNickName == channel.receiver")
            print("현재 : channel.senderEmail : \(channel.senderEmail)")
            print("현재 : channel.receiverEmail : \(channel.receiverEmail)")
            let viewController = ChatViewController(currentUserNickName: channel.receiver, channel: channel, titleName: channel.sender)
            viewController.channelId = [channel.senderEmail, channel.receiverEmail].sorted().joined(separator: "-")
            viewController.chatAvatarImage.image = profileImage
            viewController.targetEmail = channel.senderEmail
            print("🌊\n",viewController.chatAvatarImage.image as Any)
            
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
         }
      }
   }
}
