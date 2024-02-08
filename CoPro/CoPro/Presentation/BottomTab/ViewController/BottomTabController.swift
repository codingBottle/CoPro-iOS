//
//  BottomTabController.swift
//  CoPro
//
//  Created by 박현렬 on 2/8/24.
//

import UIKit

class BottomTabController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 네비게이션 바를 숨깁니다.
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        let homeVC = CardViewController()
        let cardVC = CardViewController()
        let notificationVC = CardViewController() //MARK: TODO) 알림화면VC등록
        let chatVC = CardViewController() //MARK: TODO) 알림화면VC등록
        let profileVC = CardViewController() //MARK: TODO) ProfileVC등록
        
        //각 tab bar의 viewcontroller 타이틀 설정
        
        homeVC.title = "홈"
        cardVC.title = "카드"
        notificationVC.title = "알림"
        chatVC.title = "채팅"
        profileVC.title = "프로필"
        
        homeVC.tabBarItem.image = UIImage.init(systemName: "house")
        cardVC.tabBarItem.image = UIImage.init(systemName: "house")
        notificationVC.tabBarItem.image = UIImage.init(systemName: "house")
        chatVC.tabBarItem.image = UIImage.init(systemName: "house")
        profileVC.tabBarItem.image = UIImage.init(systemName: "house")
        
        //self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        
        // 위에 타이틀 text를 항상 크게 보이게 설정
        homeVC.navigationItem.largeTitleDisplayMode = .never
        cardVC.navigationItem.largeTitleDisplayMode = .never
        notificationVC.navigationItem.largeTitleDisplayMode = .never
        chatVC.navigationItem.largeTitleDisplayMode = .never
        profileVC.navigationItem.largeTitleDisplayMode = .never
        
        // navigationController의 root view 설정
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationCard = UINavigationController(rootViewController: cardVC)
        let navigationNotification = UINavigationController(rootViewController: notificationVC)
        let navigationChat = UINavigationController(rootViewController: chatVC)
        let navigationProfile = UINavigationController(rootViewController: profileVC)
        
        
//        navigationHome.navigationBar.prefersLargeTitles = true
//        navigationCard.navigationBar.prefersLargeTitles = true
//        navigationNotification.navigationBar.prefersLargeTitles = true
//        navigationChat.navigationBar.prefersLargeTitles = true
//        navigationProfile.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navigationHome, navigationCard, navigationNotification,navigationChat,navigationProfile], animated: false)
    }
}
