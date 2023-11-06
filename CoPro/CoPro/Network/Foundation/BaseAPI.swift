//
//  BaseAPI.swift
//  CoPro
//
//  Created by 문인호 on 10/30/23.
//

import Foundation

import Alamofire

class BaseAPI {
    
    let AFManager: Session = {
        var session = AF
        let configuration = URLSessionConfiguration.af.default
        let eventLogger = AlamofireLogger()
        session = Session(configuration: configuration, eventMonitors: [eventLogger])
        return session
    }()
    
    private func judgeStatus<T: Codable>(by statusCode: Int, _ data: Data, _ object: T.Type) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<T>.self, from: data)
        else {
            return .pathErr
        }
        
        guard let realData = try? decoder.decode(object.self, from: data) else {
                // 첫 번째 디코딩이 실패했을 때 두 번째 디코딩 시도
                if let failData = try? decoder.decode(ErrorDTO.self, from: data) {
                    switch statusCode {
                    case 200..<205:
                        print("이건 200-205 성공임")
                        return .success(failData as Any)
                    case 400..<500:
                        print("이건 400-500에러임")
                        return .requestErr(failData as Any)
                    case 500:
                        print("이건 서버에러임")
                        return .serverErr
                    default:
                        print("이건 기본에러")
                        return .networkFail
                    }
                } else {
                    return .decodedErr
                }
            }
        
        print(realData)
        switch statusCode {
        case 200..<205:
            return .success(realData as Any)
        case 400..<500:
            return .requestErr(decodedData.status_message ?? "요청에러")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeSimpleResponseStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SimpleResponse.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200..<205:
            return .success(decodedData)
        case 400..<500:
            return .requestErr(decodedData.message ?? "요청에러")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    public func disposeNetwork<T: Codable>(_ result: AFDataResponse<Data>, dataModel: T.Type, completion: @escaping (NetworkResult<Any>) -> Void){
        switch result.result {
        case .success:
            guard let statusCode = result.response?.statusCode else { return }
            guard let data = result.data else { return }
            
            if dataModel != VoidResult.self {
                print(data)
                let networkResult = self.judgeStatus(by: statusCode, data, dataModel.self)
                completion(networkResult)
            } else {
                let networkResult = self.judgeSimpleResponseStatus(by: statusCode, data)
                completion(networkResult)
            }
        case .failure(let error):
            print("Data parsing failure")
            print(error)
        }
    }
}
