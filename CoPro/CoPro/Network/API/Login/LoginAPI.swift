//
//  LoginAPI.swift
//  CoPro
//
//  Created by 박현렬 on 2/13/24.
//

import Foundation
import Alamofire
import UIKit
import KeychainSwift

import Foundation
import Alamofire
import UIKit
import KeychainSwift

final class LoginAPI : BaseAPI {
    static let shared = LoginAPI()
    var loginVC = LoginViewController()
   var onBordingVC = OnboardingViewController()
    let keychain = KeychainSwift()
    private override init() {}
}
extension LoginAPI {
    var baseURL: String { return Config.baseURL }
    // 로그인 API
    
   public func getAccessToken(authCode: String?, provider: String) {
         let headers: HTTPHeaders = [
            "Accept": "application/json"
         ]
         // Body 설정
         let parameters: Parameters = [
            "authCode" : authCode!,
         ]
         AF.request("\(baseURL)/api/\(provider)/token", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300)
            .responseDecodable(of: LoginDTO.self) { response in
               switch response.result {
               case .success(let loginDTO):
                  print("\(provider) 로그인 성공")
                  print("AccessToken: \(loginDTO.data.accessToken)")
                  print("refreshToken: \(loginDTO.data.refreshToken)")
                  let keychain = KeychainSwift()
                  keychain.set(loginDTO.data.accessToken, forKey: "accessToken")
                  keychain.set(loginDTO.data.refreshToken, forKey: "refreshToken")
                  
                  if let token = self.keychain.get("accessToken") {
                     print("Token is available.")
                     LoginAPI.shared.getCheckInitialLogin(token: token) { result in
                        print("Response received: \(result)")
                        switch result {
                        case .success(let data):
                           DispatchQueue.main.async {
                              if let data = data as? CheckInitialLoginDTO {
                                 
                                 if data.data == true {
                                    print("나는야 첫 로그인")
                                    DispatchQueue.main.async {
                                       let alertVC = EditMyProfileViewController()
                                       alertVC.activeViewType = .FirstLogin
                                       alertVC.isModalInPresentation = true
                                       print("지금 activeViewType : FirstLogin")
                                       self.loginVC.present(alertVC, animated: true, completion: nil)
                                    }
                                 }
                                 else {
                                    print("나는야 non 첫 로그인")
                                    self.getLoginUserData() {
                                       self.postFcmToken()
                                       print("🍎🍎🍎🍎🍎🍎🍎checkFirstlogin false / postFcmToken 성공🍎🍎🍎🍎🍎🍎🍎🍎🍎")
                                       DispatchQueue.main.async {
                                          guard keychain.get("currentUserNickName") != nil else {return print("getLoginUserData 안에 currentUserNickName 설정 에러")}
                                          let bottomTabController = BottomTabController()
                                          // 현재 활성화된 UINavigationController의 루트 뷰 컨트롤러로 설정합니다.
                                          if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                             let delegate = windowScene.delegate as? SceneDelegate,
                                             let window = delegate.window {
                                             window.rootViewController = bottomTabController
                                             window.makeKeyAndVisible()
                                          }
                                       }
                                    }
                                 }
                              }
                              
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
                case .failure(_):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 400:  // 기존 회원
                            print("로그인 실패: 기존 회원")
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "로그인 실패", message: "해당 이메일로 이미 가입한 계정이 있습니다.\n다른 소셜 플랫폼에서 가입하였다면, 해당 플랫폼을 통해 로그인을 시도해주십시오.", preferredStyle: .alert)
                                let action = UIAlertAction(title: "확인", style: .default)
                                alertController.addAction(action)
                                
                                // 현재 활성화된 뷰 컨트롤러를 찾아서 알림창을 띄웁니다.
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let delegate = windowScene.delegate as? SceneDelegate,
                                   let window = delegate.window,
                                   let viewController = window.rootViewController {
                                    viewController.present(alertController, animated: true, completion: nil)
                                }
                            }
                        case 401:  // 인증 실패
                            print("로그인 실패: 인증 실패")
                        case 404:
                            print("로그인 실패: Email Not Found")
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "로그인 실패", message: "Github 이메일이 존재하지 않습니다.\n다른 플랫폼을 이용한 로그인 혹은 Github 이메일을 등록 후 시도해주세요", preferredStyle: .alert)
                                let action = UIAlertAction(title: "확인", style: .default)
                                alertController.addAction(action)
                                
                                // 현재 활성화된 뷰 컨트롤러를 찾아서 알림창을 띄웁니다.
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let delegate = windowScene.delegate as? SceneDelegate,
                                   let window = delegate.window,
                                   let viewController = window.rootViewController {
                                    viewController.present(alertController, animated: true, completion: nil)
                                }
                            }
                            
                        case 500...599:  // 서버 에러
                            print("로그인 실패: 서버 에러")
                        default:
                            print("로그인 실패: 알 수 없는 에러")
                        }
                    }
                    
                }
            }
    }
   
   
    public func refreshAccessToken(completion: @escaping (Result<LoginDTO, Error>) -> Void){
        let keychain = KeychainSwift()
        guard let refreshToken = keychain.get("refreshToken") else {
            print("No refreshToken found in keychain.")
            return
        }
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        // Body 설정
        let parameters: Parameters = [
            "refreshToken" : refreshToken,
        ]
        AF.request("\(baseURL)/api/token/access", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300)
            .responseDecodable(of: LoginDTO.self) { response in
                switch response.result {
                case .success(let loginDTO):
                    print("재발급 로그인 성공")
                    print("AccessToken: \(loginDTO.data.accessToken)")
                    print("refreshToken: \(loginDTO.data.refreshToken)")
                    let keychain = KeychainSwift()
                    keychain.set(loginDTO.data.accessToken, forKey: "accessToken")
                    keychain.set(loginDTO.data.refreshToken, forKey: "refreshToken")
                   self.postFcmToken()
                   print("🍎🍎🍎🍎🍎🍎🍎checkFirstlogin false / postFcmToken 성공🍎🍎🍎🍎🍎🍎🍎🍎🍎")
                    completion(.success(loginDTO))
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 400...499:  // 클라이언트 에러
                            print("로그인 실패: 클라이언트 에러")
                        case 500...599:  // 서버 에러
                            print("로그인 실패: 서버 에러")
                        default:
                            print("로그인 실패: 알 수 없는 에러")
                        }
                    }
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - 최초 로그인 확인
    
    public func getCheckInitialLogin(token: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(LoginRouter.getCheckInitialLogin(token: token)).responseData { response in
           
           if let statusCode = response.response?.statusCode {
               if statusCode == 401 {
                   // 토큰 재요청 함수 호출
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(let loginDTO):
                           print("토큰 재발급 성공: \(loginDTO)")
                           DispatchQueue.main.async {
                               self.getCheckInitialLogin(token: loginDTO.data.accessToken, completion: completion)
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
               } else {
                   // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                   self.disposeNetwork(response, dataModel: CheckInitialLoginDTO.self, completion: completion)
               }
           } else {
               // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
               self.disposeNetwork(response, dataModel: CheckInitialLoginDTO.self, completion: completion)
           }
        }
    }
    
    // MARK: - 유저 정보 받아오기
    
    func getLoginUserData(completion: @escaping () -> Void) {
        let keychain = KeychainSwift()
        if let token = keychain.get("accessToken") {
            MyProfileAPI.shared.getMyProfile(token: token) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        if let data = data as? MyProfileDTO {
                           keychain.set(data.data.nickName, forKey: "currentUserNickName")
                           keychain.set(data.data.picture, forKey: "currentUserProfileImage")
                           keychain.set(data.data.occupation, forKey: "currentUserOccupation")
                           keychain.set(data.data.email, forKey: "currentUserEmail")
                           print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥현재 currentUserEmail",keychain.get("currentUserEmail"))
                           keychain.set(data.data.gitHubURL ?? "지금 비어있엉~", forKey: "currentUserGithubURL")
                            completion()
                        } else {
                            print("Failed to decode the response.")
                        }
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
    }
   
   func postFcmToken() {
      print("🔥")
      
       guard let token = self.keychain.get("accessToken") else {
           print("No accessToken found in keychain.")
           return
       }
      guard let fcmToken = keychain.get("FcmToken") else {return print("postFcmToken 안에 FcmToken 설정 에러")}
      
      NotificationAPI.shared.postFcmToken(token: token, requestBody: FcmTokenRequestBody(fcmToken: fcmToken)) { result in
           switch result {
           case .success(_):
              print("FcmToken 보내기 성공")
               
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
