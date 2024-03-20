//
//  LoginRouter.swift
//  CoPro
//
//  Created by 박신영 on 2/16/24.
//

import Foundation
import Alamofire

enum LoginRouter {
   case getCheckInitialLogin(token: String)
   case postWithDrawal(token: String)
}

extension LoginRouter: BaseTargetType {
   var baseURL: String { return Config.baseURL }
   
   var method: HTTPMethod {
      switch self {
      case .getCheckInitialLogin:
         return .get
      case .postWithDrawal:
         return .post
      }
   }
   
   var path: String {
      switch self {
      case .getCheckInitialLogin:
         return "/api/success"
      case .postWithDrawal:
         return "/api/withdrawal"
      }
   }
   
   var parameters: RequestParams {
      switch self {
      case .getCheckInitialLogin:
         return .none
      case .postWithDrawal:
         return .none
      }
   }
   
   var headers : HTTPHeaders?{
      switch self{
      case .getCheckInitialLogin(let token):
         return ["Authorization": "Bearer \(token)"]
      case .postWithDrawal(let token):
         return ["Authorization": "Bearer \(token)"]
      }
   }
}
