//
//  MyProfileViewController.swift
//  CoPro
//
//  Created by 박신영 on 1/7/24.
//

import UIKit
import SnapKit
import Then
import KeychainSwift

class MyProfileViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    let token = KeychainSwift().get("idToken") ?? ""
    var myProfileView = MyProfileView()
    var myProfileData: MyProfileData?
    
    
    override func loadView() {
        // LoginView를 생성하고 뷰에 추가합니다.
        view = myProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myProfileView.tableView.delegate = self
        myProfileView.tableView.dataSource = self
        getMyProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setUI() {
        
    }
    override func setLayout() {
        
    }
    
    func getMyProfile() {
        MyProfileAPI.shared.getMyProfile(token: token) { result in
            switch result {
            case .success(let data):
                
                if let data = data as? MyProfileDTO {
                    // API 호출이 성공하면, 데이터를 저장합니다.
                    self.myProfileData = data.data
                    // tableView를 다시 로드하여 모든 셀을 업데이트합니다.
                    DispatchQueue.main.async {
                        self.myProfileView.tableView.reloadData()
                    }
                } else {
                    print("Failed to decode the response.")
                }
                
            case .requestErr(let message):
                // Handle request error here.
                print("Request error: \(message)")
            case .pathErr:
                // Handle path error here.
                print("Path error")
            case .serverErr:
                // Handle server error here.
                print("Server error")
            case .networkFail:
                // Handle network failure here.
                print("Network failure")
            default:
                break
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 512
        }
        else if indexPath.row == 9 {
            return 64
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageTableViewCell", for: indexPath) as! ProfileImageTableViewCell
            
            cell.nameLabel.text = myProfileData?.name
            cell.developmentJobLabel.text = myProfileData?.occupation
            
//            cell.nameLabel.text = "박신영"
//            cell.nameLabel.font = .systemFont(ofSize: 34, weight: .bold)
//            cell.developmentJobLabel.text = "iOS"
//            cell.developmentJobLabel.font = .systemFont(ofSize: 26, weight: .medium)
//            cell.usedLanguageLabel.text = "Swift / Dart"
//            cell.usedLanguageLabel.font = .systemFont(ofSize: 26, weight: .medium)
            
            return cell
        }
        
        else if indexPath.row == 9 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConversionSettingsCell", for: indexPath) as! ConversionSettingsTableViewCell
            return cell
        }
        
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileTableViewCell", for: indexPath) as! MyProfileTableViewCell
            
            // 모든 셀에 대한 공통 설정
            cell.titleLabel.text = "텍스트"
            cell.button.isHidden = true
            cell.heartContainer.isHidden = true
            cell.greaterthanContainer.isHidden = false
            
            // 각 셀에 대한 특별한 설정
            switch indexPath.row {
            case 1:
                cell.titleLabel.text = "좋아요 수"
                if let likeMembersCount = myProfileData?.likeMembersCount {
                    cell.heartCountLabel.text = String(likeMembersCount)
                }
                cell.heartContainer.isHidden = false
                cell.greaterthanContainer.isHidden = true
                
            case 2:
                cell.titleLabel.text = "GitHub 링크"
                
            case 3:
                cell.titleLabel.text = "활동내역"
                cell.titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
                cell.heartContainer.isHidden = true
                cell.greaterthanContainer.isHidden = true
                
            case 4:
                cell.titleLabel.text = "작성한 게시물"
                
            case 5:
                cell.titleLabel.text = "작성한 댓글"
                
            case 6:
                cell.titleLabel.text = "관심 게시물"
                
            case 7:
                cell.titleLabel.text = "관심 프로필"
                
            case 8:
                cell.titleLabel.text = "사용자 설정"
                cell.titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
                cell.heartContainer.isHidden = true
                cell.greaterthanContainer.isHidden = true
                
            default:
                break
            }
            
            return cell
        }
    }
    
}
