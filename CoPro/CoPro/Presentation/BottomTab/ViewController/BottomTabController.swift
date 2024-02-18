//
//  BottomTabController.swift
//  CoPro
//
//  Created by 박현렬 on 2/8/24.
//

import UIKit
import FirebaseAuth

class BottomTabController: UITabBarController {

   private func addTabBarSeparator() {
      let separator = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
      separator.backgroundColor = UIColor.G3() // Set the color of the separator line
      tabBar.addSubview(separator)
   }
   var currentUserData: String?
   var chatVC: ChannelViewController?


      init(currentUserData: String) {
         self.currentUserData = currentUserData
         self.chatVC = ChannelViewController(currentUserNickName: self.currentUserData ?? "")
         super.init(nibName: nil, bundle: nil)
      }
   required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
      }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      // 네비게이션 바를 숨깁니다.
      self.navigationController?.isNavigationBarHidden = true
   }
   override func viewDidLoad() {
      super.viewDidLoad()
      addTabBarSeparator()
      navigationController?.isNavigationBarHidden = true
      UITabBar.appearance().unselectedItemTintColor = UIColor.G3()
      UITabBar.appearance().tintColor = UIColor.Black()
      // Do any additional setup after loading the view.
      let notificationVC = CardViewController() //MARK: TODO) 알림화면VC등록
      let cardVC = CardViewController()
      let homeVC = MyProfileViewController()//MARK: TODO) 홈화면VC등록
      let profileVC = MyProfileViewController() //MARK: TODO) ProfileVC등록
      guard let chatVC = chatVC else { return }
      
      
      //각 tab bar의 viewcontroller 타이틀 설정
      notificationVC.title = "알림"
      cardVC.title = "카드"
      homeVC.title = "홈"
      chatVC.title = "채팅"
      profileVC.title = "프로필"
      
      let attributes: [NSAttributedString.Key: Any] = [
         .font: UIFont(name: "Pretendard-Bold", size: 11)!, // 폰트 설정
      ]
      notificationVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
      cardVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
      homeVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
      chatVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
      profileVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
      // 상단 탭바 타이틀 노출 제거
      notificationVC.navigationItem.title = nil
      cardVC.navigationItem.title = nil
      homeVC.navigationItem.title = nil
      chatVC.navigationItem.title = nil
      profileVC.navigationItem.title = nil
      // 기본상태 아이콘 설정
      notificationVC.tabBarItem.image = UIImage.init(systemName: "bell")
      cardVC.tabBarItem.image = UIImage.init(systemName: "rectangle.stack.badge.person.crop")
      homeVC.tabBarItem.image = UIImage.init(systemName: "house")
      chatVC.tabBarItem.image = UIImage.init(systemName: "ellipsis.message")
      profileVC.tabBarItem.image = UIImage.init(systemName: "person.crop.circle")
      //선택 상태 아이콘 설정
      notificationVC.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
      cardVC.tabBarItem.selectedImage = UIImage(systemName: "rectangle.stack.badge.person.crop.fill")
      homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
      chatVC.tabBarItem.selectedImage = UIImage(systemName: "ellipsis.message.fill")
      profileVC.tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
      
      
      // self.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -6, right: 0);
      
      // navigationController의 root view 설정
      let navigationNotification = UINavigationController(rootViewController: notificationVC)
      let navigationCard = UINavigationController(rootViewController: cardVC)
      let navigationHome = UINavigationController(rootViewController: homeVC)
      let navigationChat = UINavigationController(rootViewController: chatVC)
      let navigationProfile = UINavigationController(rootViewController: profileVC)
      
      setViewControllers([navigationNotification, navigationCard, navigationHome,navigationChat,navigationProfile], animated: false)
      selectedIndex = 2
   }
}
