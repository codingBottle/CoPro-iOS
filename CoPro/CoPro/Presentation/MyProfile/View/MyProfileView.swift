//
//  MyProfileView.swift
//  CoPro
//
//  Created by 박신영 on 1/7/24.
//

import UIKit
import SnapKit
import Then


class MyProfileView: BaseView {
    
    let scrollView = UIScrollView()
    let profileImage = UIImageView(image : Image.coproLogo)
        
    let tableView: UITableView = UITableView()
    
    let bottomTabBarView = UIView()
    
    
    override func setUI() {
        addSubviews(tableView, bottomTabBarView)
//        scrollView.addSubviews(profileImage, tableView)
//        profileImage.addSubview(informationContainer)
        
        
//        scrollView.do {
//            $0.layer.borderColor = UIColor.green.cgColor
//            $0.layer.borderWidth = 1
//        }
        
        tableView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            $0.separatorInset = UIEdgeInsets.zero
            $0.separatorStyle = .singleLine
            $0.register(ProfileImageTableViewCell.self, forCellReuseIdentifier: "ProfileImageTableViewCell")
            $0.register(MyProfileTableViewCell.self, forCellReuseIdentifier: "MyProfileTableViewCell")
            $0.register(ConversionSettingsTableViewCell.self, forCellReuseIdentifier: "ConversionSettingsCell")
            $0.showsVerticalScrollIndicator = false
//            $0.isScrollEnabled = false
        }
        

        bottomTabBarView.do {
            $0.backgroundColor = .brown
        }
    }

    override func setLayout() {
        //        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 62, right: 0)
        //
        //        scrollView.snp.makeConstraints {
        //            $0.edges.top.equalToSuperview()
        //            $0.edges.equalToSuperview()
        //        }
        
        
        //        profileImage.snp.makeConstraints {
        //            $0.top.equalTo(scrollView.snp.top)
        //            $0.centerX.width.equalToSuperview()
        //            $0.height.equalTo(512)
        //
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 68, right: 0)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.top.equalTo(profileImage.snp.bottom)
            $0.centerX.width.equalToSuperview()
//            $0.bottom.equalTo(bottomTabBarView.snp.bottom)
//            $0.height.equalTo(950)
        }
        
        bottomTabBarView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
    }

}

