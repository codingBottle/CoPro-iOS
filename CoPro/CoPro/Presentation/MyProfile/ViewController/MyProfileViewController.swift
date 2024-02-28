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
    
    enum CellType {
        case profile, cardChange, myTrace
    }
    
    private let keychain = KeychainSwift()
    var myProfileView = MyProfileView()
    var myProfileData: MyProfileDataModel?
    var languageArr: Array<Substring>?
   var githubURL: String?
    let bottomTabBarView = UIView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       myProfileView.tableView.delegate = self
       myProfileView.tableView.dataSource = self
       getMyProfile()
       view.backgroundColor = UIColor.White()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
       getMyProfile()
       
    }
    
    override func setUI() {
        view.addSubviews(myProfileView)
    }
    override func setLayout() {
        
        myProfileView.snp.makeConstraints {
           $0.top.leading.trailing.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
   private func getMyProfile() {
       // 액세스 토큰 가져오기
       guard let token = self.keychain.get("accessToken") else {
           print("No accessToken found in keychain.")
           return
       }
       // MyProfileAPI를 사용하여 프로필 가져오기
       MyProfileAPI.shared.getMyProfile(token: token) { result in
           switch result {
           case .success(let data):
               DispatchQueue.main.async {
                   if let data = data as? MyProfileDTO {
                       // 성공적으로 프로필 데이터를 가져온 경우
                       self.myProfileData = MyProfileDataModel(from: data.data)
                      self.githubURL = self.myProfileData?.gitHubURL
                       self.languageArr = self.myProfileData?.language.split(separator: ",")
                       let indexPath0 = IndexPath(row: 0, section: 0)
                       let indexPath1 = IndexPath(row: 1, section: 0)
                       self.myProfileView.tableView.reloadRows(at: [indexPath0, indexPath1], with: .none)
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
    
   func postEditCardViewType(CardViewType: Int) {
       // 액세스 토큰 가져오기
       guard let token = self.keychain.get("accessToken") else {
           print("No accessToken found in keychain.")
           return
       }
       
       // MyProfileAPI를 사용하여 프로필 타입 변경 요청 보내기
       MyProfileAPI.shared.postEditCardType(token: token, requestBody: EditCardTypeRequestBody(viewType: CardViewType)) { result in
           switch result {
           case .success(_):
              DispatchQueue.main.async {
                 self.showAlert(title: "프로필 타입 변경에 성공하였습니다", confirmButtonName: "확인")
                 
              }
               
           case .requestErr(let message):
               // 요청 에러인 경우
               print("Error : \(message)")
           case .pathErr, .serverErr, .networkFail:
               // 다른 종류의 에러인 경우
               print("another Error")
           default:
               break
           }
       }
   }
   
    
    func cellType(for indexPath: IndexPath) -> CellType {
        switch indexPath.row {
        case 0:
            return .profile
        case 9:
            return .cardChange
        default:
            return .myTrace
        }
    }
    
    func returnMainTableCellHeight(_CellType: CellType) -> CGFloat {
        switch _CellType {
        case .profile:
            return UIScreen.main.bounds.height/2 + 20
        case .cardChange:
            return 70
        case .myTrace:
            return 50
        }
    }
    
    //불러올 테이블 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = cellType(for: indexPath)
        return returnMainTableCellHeight(_CellType: cellType)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellType(for: indexPath)
        switch cellType {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageTableViewCell", for: indexPath) as! ProfileImageTableViewCell
            cell.delegate = self
            cell.loadProfileImage(url: myProfileData?.picture ?? "")
            cell.nickname.text = myProfileData?.nickName
            cell.developmentJobLabel.text = myProfileData?.occupation
            if languageArr?.count ?? 0 > 1 {
                          cell.usedLanguageLabel.text = "\(languageArr?[0] ?? "") / \(languageArr?[1] ?? "")"
                       } else {
                          cell.usedLanguageLabel.text = "\(languageArr?[0] ?? "")"
                       }
            cell.selectionStyle = .none
            return cell
            
        case .cardChange:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardTypeSettingsTableViewCell", for: indexPath) as! CardTypeSettingsTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .myTrace:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileTableViewCell", for: indexPath) as! MyProfileTableViewCell
            cell.delegate = self
            
            // 모든 셀에 대한 공통 설정
            cell.titleLabel.setPretendardFont(text: "test", size: 17, weight: .regular, letterSpacing: 1.23)
            cell.heartContainer.isHidden = true
            cell.greaterthanContainer.isHidden = false
            cell.selectionStyle = .none
            
            // 각 셀에 대한 특별한 설정
            switch indexPath.row {
            case 1:
                cell.titleLabel.text = "좋아요 수"
                if let data = myProfileData?.likeMembersCount {
                    cell.heartCountLabel.text = String(data)
                }
                cell.heartContainer.isHidden = false
                cell.greaterthanContainer.isHidden = true
                
            case 2:
                cell.titleLabel.text = "GitHub 링크"
                cell.configureButton(at: 1)
                
            case 3:
                cell.titleLabel.setPretendardFont(text: "활동내역", size: 17, weight: .bold, letterSpacing: 1.23)
                cell.heartContainer.isHidden = true
                cell.greaterthanContainer.isHidden = true
                
            case 4:
                cell.titleLabel.text = "작성한 게시물"
                cell.configureButton(at: 2)
                
            case 5:
                cell.titleLabel.text = "작성한 댓글"
                cell.configureButton(at: 3)
                
            case 6:
                cell.titleLabel.text = "저장한 게시물"
                cell.configureButton(at: 4)
                
            case 7:
                cell.titleLabel.text = "관심 프로필"
                cell.configureButton(at: 5)
                
            case 8:
                cell.titleLabel.setPretendardFont(text: "사용자 설정", size: 17, weight: .bold, letterSpacing: 1.23)
                cell.heartContainer.isHidden = true
                cell.greaterthanContainer.isHidden = true
                
            default:
                break
            }
            
            return cell
        }
    }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      switch indexPath.row {
      case 1, 3:
          print("")
          
      case 2:
         print("현재 뷰컨에서 깃헙 눌림")
         let alertVC = EditGithubModalViewController()
        alertVC.githubURLtextFieldLabel.text = myProfileData?.gitHubURL
         alertVC.githubUrlUpdateDelegate = self
         alertVC.initialUserURL = self.githubURL
        alertVC.activeModalType = .NotFirstLogin
        alertVC.isModalInPresentation = true
         present(alertVC, animated: true, completion: nil)
          
      case 4:
         let vc = MyContributionsViewController()
         vc.activeCellType = .post
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
         self.navigationController?.pushViewController(vc, animated: true)
          
      case 5:
         let vc = MyContributionsViewController()
         vc.activeCellType = .comment
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
         self.navigationController?.pushViewController(vc, animated: true)
          
      case 6:
         let vc = MyContributionsViewController()
         vc.activeCellType = .scrap
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
         self.navigationController?.pushViewController(vc, animated: true)
          
      case 7:
         let vc = LikeProfileViewController()
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
         self.navigationController?.pushViewController(vc, animated: true)
          
      case 9:
         let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

         let action1 = UIAlertAction(title: "카드로 보기", style: .default) { (action) in
             self.postEditCardViewType(CardViewType: 0)
            CardViewController().reloadData()
         }
         alertController.addAction(action1)

         let action2 = UIAlertAction(title: "목록으로 보기", style: .default) { (action) in
             self.postEditCardViewType(CardViewType: 1)
            CardViewController().reloadData()
         }
         alertController.addAction(action2)

         let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)

         self.present(alertController, animated: true, completion: nil)
          
      default:
          break
      }
       

       // 셀 선택 해제
       tableView.deselectRow(at: indexPath, animated: true)
   }

}

extension MyProfileViewController: EditProfileButtonDelegate, MyProfileTableViewButtonDelegate, EditCardViewTypeButtonDelegate, ProfileUpdateDelegate, GithubUrlUpdateDelegate{
    func didUpdateProfile() {
       print("✅✅✅✅✅✅✅✅✅✅✅✅")
        getMyProfile()
    }
    
    
    // 프로필 수정
    func didTapEditProfileButton(in cell: ProfileImageTableViewCell) {
        let alertVC = EditMyProfileViewController()
        alertVC.beforeEditMyProfileData = myProfileData
        alertVC.initialUserName = myProfileData?.nickName
        alertVC.activeViewType = .NotFirstLogin
        alertVC.profileUpdateDelegate = self
       alertVC.isModalInPresentation = true
        present(alertVC, animated: true, completion: nil)
    }
    
    // github url 수정
    func didTapEditGitHubURLButton(in cell: MyProfileTableViewCell) {
       print("현재 뷰컨에서 깃헙 눌림")
       let alertVC = EditGithubModalViewController()
       alertVC.githubUrlUpdateDelegate = self
      alertVC.githubURLtextFieldLabel.text = myProfileData?.gitHubURL
       alertVC.initialUserURL = self.githubURL
      alertVC.activeModalType = .NotFirstLogin
      alertVC.isModalInPresentation = true
       present(alertVC, animated: true, completion: nil)
    }
    
    // 작성한 게시물
    func didTapWritebyMeButtonTapped(in cell: MyProfileTableViewCell) {
        print("작성한 게시물 클릭")
        let vc = MyContributionsViewController()
        vc.activeCellType = .post
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // 작성한 댓글
    func didTapMyWrittenCommentButtonTapped(in cell: MyProfileTableViewCell) {
        print("작성한 댓글 클릭")
        let vc = MyContributionsViewController()
        vc.activeCellType = .comment
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    // 스크랩
    func didTapInterestedPostButtonTapped(in cell: MyProfileTableViewCell) {
        print("스크랩 클릭")
        let vc = MyContributionsViewController()
        vc.activeCellType = .scrap
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 관심 프로필
    func didTapInterestedProfileButtonTapped(in cell: MyProfileTableViewCell) {
        print("관심 프로필 클릭")
        let vc = LikeProfileViewController()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   // MARK: - 프로필 화면 카드/목록 설정하는 곳
   
    func didTapEditCardTypeButtonTapped(in cell: CardTypeSettingsTableViewCell) {
        print("현재 뷰컨에서 didTapEditCardTypeButtonTapped 눌림")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: "카드로 보기", style: .default) { (action) in
            print("카드로 보기 호출")
            self.postEditCardViewType(CardViewType: 0)
        }
        alertController.addAction(action1)

        let action2 = UIAlertAction(title: "목록으로 보기", style: .default) { (action) in
            print("목록으로 보기 호출")
            self.postEditCardViewType(CardViewType: 1)
        }
        alertController.addAction(action2)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    //MARK: - 로그아웃
    func didTapEditMemberStatusButtonTapped(in cell: CardTypeSettingsTableViewCell) {
        print("현재 뷰컨에서 didTapEditMemberStatusButtonTapped 눌림")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: "로그 아웃", style: .default) { (action) in
            print("로그 아웃 호출")
            self.signOut()
        }
        alertController.addAction(action1)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    func signOut()  {
        keychain.clear()
        navigationController?.popToRootViewController(animated: true)
    }
    
}
