//
//  EditGithubModalViewController.swift
//  CoPro
//
//  Created by 박신영 on 1/23/24.
//

import UIKit
import Then
import SnapKit
import KeychainSwift

class EditGithubModalViewController: BaseViewController, UITextFieldDelegate {
   
   enum EditGitHubModalType {
      case FirstLogin, NotFirstLogin
   }
   var activeModalType: EditGitHubModalType = .NotFirstLogin
   private let keychain = KeychainSwift()
   var editGitHubURLBody = EditGitHubURLRequestBody()
//   var originalHeight: CGFloat = 0
   var isFirstLoginUserName: String?
   var readyForEdigithub: Bool?
   var myProfileVC: MyProfileViewController?
   
   let container = UIView()
   
   let githubLabel = UILabel().then {
      $0.setPretendardFont(text: "Git URL", size: 17, weight: .bold, letterSpacing: 1.25)
      $0.textColor = UIColor.Black()
   }
   
   let textFieldContainer = UIView().then {
      $0.layer.backgroundColor = UIColor.G1().cgColor
      $0.layer.cornerRadius = 10
   }
   
   lazy var doneButton = UIButton().then {
      $0.setTitle("확인", for: .normal)
      $0.titleLabel?.setPretendardFont(text: "확인", size: 17, weight: .bold, letterSpacing: 1.25)
      $0.titleLabel?.textColor = UIColor.White()
      $0.layer.backgroundColor = UIColor(.gray).cgColor
      $0.layer.cornerRadius = 10
      $0.addTarget(self, action: #selector(didTapdoneButton), for: .touchUpInside)
   }
   
   let firstLoginInGithubModal = UILabel().then {
      $0.setPretendardFont(text: "마지막 단계예요!", size: 17, weight: .bold, letterSpacing: 1.25)
      $0.textColor = UIColor.P2()
   }
   
   let githubURLtextFieldLabel = UITextField().then {
      $0.placeholder = "GitHub URL을 입력해주세요"
      $0.clearButtonMode = .always
      $0.keyboardType = .URL
      $0.autocapitalizationType = .none
      $0.spellCheckingType = .no
   }
   
   var shouldShowSuccessAlert = false

   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      if shouldShowSuccessAlert {
         successAlert()
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = UIColor.White()
      githubURLtextFieldLabel.delegate = self
      githubURLtextFieldLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
   }
   
   deinit {
      NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
   }
   
   override func setUI() {
      switch activeModalType {
      case .FirstLogin:
         if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 15
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [.custom {context in
               return 225
            }]
         }
      case .NotFirstLogin:
         if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 15
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [.custom {context in
               return 210
            }]
         }
      }
   }
   override func setLayout() {
      switch activeModalType {
      case .FirstLogin:
         githubLabel.text = "깃허브 링크를 입력해주세요"
         githubURLtextFieldLabel.placeholder = "http://examplegithub.com"
         view.addSubview(container)
         container.addSubviews(firstLoginInGithubModal, githubLabel, textFieldContainer, doneButton)
         textFieldContainer.addSubview(githubURLtextFieldLabel)
         
         container.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-12)
         }
         
         firstLoginInGithubModal.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(0)
            $0.height.equalTo(21)
//            $0.width.equalTo(60)
         }
         
         githubLabel.snp.makeConstraints {
            $0.top.equalTo(firstLoginInGithubModal.snp.bottom).offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.height.equalTo(21)
         }
         
         textFieldContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(githubLabel.snp.bottom).offset(12)
            $0.height.equalTo(41)
         }
         
         githubURLtextFieldLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-6)
         }
         
         doneButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(textFieldContainer.snp.bottom).offset(15)
            $0.height.equalTo(textFieldContainer.snp.height)
         }
         
      case .NotFirstLogin:
         view.addSubview(container)
         container.addSubviews(githubLabel, textFieldContainer, doneButton)
         textFieldContainer.addSubview(githubURLtextFieldLabel)
         
         container.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-12)
         }
         
         githubLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(0)
            $0.height.equalTo(21)
         }
         
         textFieldContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(githubLabel.snp.bottom).offset(12)
            $0.height.equalTo(41)
         }
         
         githubURLtextFieldLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-6)
         }
         
         doneButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(textFieldContainer.snp.bottom).offset(15)
            $0.height.equalTo(textFieldContainer.snp.height)
         }
      }
      
   }
   
   override func setUpKeyboard() {
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
   }
   
   internal func textFieldDidEndEditing(_ textField: UITextField) {
      if let text = textField.text {
         print("사용자가 입력한 텍스트: \(text)")
         editGitHubURLBody.gitHubURL = text
         githubURLtextFieldLabel.text = text
      }
   }
   
   internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   @objc private func didTapdoneButton() {
      print("지금 didTapdoneButton 눌림")
      if readyForEdigithub == false {
         githubURLtextFieldLabel.resignFirstResponder()
      } else {
         let regex = "^https://github\\.com/[a-zA-Z0-9/\\.]*$"
         let testStr = githubURLtextFieldLabel.text ?? ""
         if testStr.count > 19 {
             let testPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
             if testPredicate.evaluate(with: testStr) {
                 print("// GitHub URL이 유효함")
                 postEditGitHubURL()
             } else {
                 // GitHub URL이 유효하지 않음
                 self.showAlert(title: "Github 프로필 주소의 양식이 올바르지 않습니다",
                                message: "다시 시도해주세요",
                                confirmButtonName: "확인")
             }
         } else {
             // GitHub URL이 너무 짧음
             self.showAlert(title: "Github 프로필 주소가 너무 짧습니다",
                            message: "다시 시도해주세요",
                            confirmButtonName: "확인")
         }
     }

   }
   
   
   private func postEditGitHubURL() {
      if let token = self.keychain.get("accessToken") {
         switch activeModalType {
         case .FirstLogin:
//            print
            MyProfileAPI.shared.postEditGitHubURL(token: token, requestBody: editGitHubURLBody ,checkFirstlogin: true) { result in
                switch result {
                case .success :
                   print("성공!!!")
                case .requestErr(let message):
                   print("🔥🔥🔥🔥🔥🔥requestErr🔥🔥🔥🔥🔥🔥🔥🔥 ")
                    print("Error : \(message)")
                case .pathErr, .serverErr, .networkFail:
                    print("another Error")
                default:
                    break
                }
            }

         case .NotFirstLogin:
            print("NotFirstLogin")
            MyProfileAPI.shared.postEditGitHubURL(token: token, requestBody: EditGitHubURLRequestBody(gitHubURL: githubURLtextFieldLabel.text ?? ""), checkFirstlogin: false) { result in
               switch result {
               case .success(_):
                  print("NotFirstLogin2222")
                  print("🔥🔥🔥🔥🔥NotFirstLogin success🔥🔥🔥🔥🔥🔥🔥🔥🔥 ")
                  
               case .requestErr(let message):
                  print("Error : \(message)")
               case .pathErr, .serverErr, .networkFail:
                  print("another Error")
               default:
                  break
               }
            }
         }
      }
   }
   
   func successAlert() {
           DispatchQueue.main.async {
              self.shouldShowSuccessAlert = false
               self.showAlert(title: "Github URL 수정을 성공하였습니다",
                              confirmButtonName: "확인")
               self.dismiss(animated: true)
           }
       }

   //FcmToken 보내기
   
//   func postFcmToken() {
//       guard let token = self.keychain.get("accessToken") else {
//           print("No accessToken found in keychain.")
//           return
//       }
//      guard let fcmToken = keychain.get("FcmToken") else {return print("postFcmToken 안에 FcmToken 설정 에러")}
//      
//      NotificationAPI.shared.postFcmToken(token: token, requestBody: FcmTokenRequestBody(fcmToken: fcmToken)) { result in
//           switch result {
//           case .success(_):
//              print("FcmToken 보내기 성공")
//               
//           case .requestErr(let message):
//               // 요청 에러인 경우
//               print("Error : \(message)")
//              if (message as AnyObject).contains("401") {
//                   // 만료된 토큰으로 인해 요청 에러가 발생한 경우
//               }
//               
//           case .pathErr, .serverErr, .networkFail:
//               // 다른 종류의 에러인 경우
//               print("another Error")
//           default:
//               break
//           }
//       }
//   }
   
   
   //MARK: - @objc func
   
   @objc func textFieldDidChange(_ textField: UITextField) {
      DispatchQueue.main.async { [weak self] in
         guard let self = self else { return }
         if textField.text?.count == 0 {
            self.doneButton.backgroundColor = .gray
         } else {
            doneButton.isEnabled = true
            self.doneButton.backgroundColor = UIColor.P2()
         }
      }
   }
   
   
   @objc func keyboardWillShow(notification: NSNotification) {
      if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
         
         if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
               readyForEdigithub = false
            UIView.animate(withDuration: 0.3) {
               self.view.layoutIfNeeded()
            }
         }
      }
   }
   
   @objc func keyboardWillHide(notification: NSNotification) {
      readyForEdigithub = true
      
      UIView.animate(withDuration: 0.3) {
         self.view.layoutIfNeeded()
      }
   }
   
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
       return true
   }
}
