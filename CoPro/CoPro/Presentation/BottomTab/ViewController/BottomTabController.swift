//
//  BottomTabController.swift
//  CoPro
//
//  Created by 박현렬 on 2/8/24.
//

import UIKit
import FirebaseAuth
import KeychainSwift

class BottomTabController: UITabBarController {
    private func addTabBarSeparator() {
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        separator.backgroundColor = UIColor.G3() // Set the color of the separator line
        tabBar.addSubview(separator)
    }
    
    let keychain = KeychainSwift()
    var currentUserData: String?
    var chatVC: ChannelViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTabBarSeparator()
        navigationController?.isNavigationBarHidden = true
        UITabBar.appearance().unselectedItemTintColor = UIColor.G3()
        UITabBar.appearance().tintColor = UIColor.Black()
        // Do any additional setup after loading the view.
        guard let currentUserNickName = keychain.get("currentUserNickName") else {return print("BottomTabController 안 currentUserNickName 에러")}
        let notificationVC = CardViewController() //MARK: TODO) 알림화면VC등록
        let cardVC = CardViewController()
        let homeVC = MainViewController()//MARK: TODO) 홈화면VC등록
        let profileVC = MyProfileViewController() //MARK: TODO) ProfileVC등록
        let chatVC = ChannelViewController(currentUserNickName: currentUserNickName)
        
        
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
        notificationVC.tabBarItem.image = UIImage.init(named: "noti_icon")?.withRenderingMode(.alwaysOriginal)
        cardVC.tabBarItem.image = UIImage.init(named: "card_icon")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.image = UIImage.init(named: "home_icon")?.withRenderingMode(.alwaysOriginal)
        chatVC.tabBarItem.image = UIImage(named: "chat_icon")?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.image = UIImage.init(named: "profile_icon")?.withRenderingMode(.alwaysOriginal)
        //선택 상태 아이콘 설정
        notificationVC.tabBarItem.selectedImage = UIImage.init(named: "noti_icon_tap")?.withRenderingMode(.alwaysOriginal)
        cardVC.tabBarItem.selectedImage = UIImage.init(named: "card_icon_tap")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.selectedImage =  UIImage.init(named: "home_icon_tap")?.withRenderingMode(.alwaysOriginal)
        chatVC.tabBarItem.selectedImage = UIImage.init(named: "chat_icon_tap")?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.selectedImage = UIImage.init(named: "profile_icon_tap")?.withRenderingMode(.alwaysOriginal)
        
        
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
