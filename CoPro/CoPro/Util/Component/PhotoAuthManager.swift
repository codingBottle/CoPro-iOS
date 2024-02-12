//
//  PhotoAuthManager.swift
//  CoPro
//
//  Created by 문인호 on 2/5/24.
//

import Photos
import UIKit

protocol PhotoAuthManager {
    var authorizationStatus: PHAuthorizationStatus { get }
    var isAuthorizationLimited: Bool { get }
    
    func requestAuthorization(completion: @escaping (Result<Void, NSError>) -> Void)
}

extension PhotoAuthManager {
    var isAuthorizationLimited: Bool {
        authorizationStatus == .limited
    }
    
    fileprivate func goToSetting() {
        guard
            let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url)
        else { return }
            
        UIApplication.shared.open(url, completionHandler: nil)
    }
}

final class MyPhotoAuthManager: PhotoAuthManager {
    var authorizationStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestAuthorization(completion: @escaping (Result<Void, NSError>) -> Void) {
        guard authorizationStatus != .authorized else {
            completion(.success(()))
            return
        }
        
        guard authorizationStatus != .denied else {
            DispatchQueue.main.async {
                self.goToSetting()
            }
            completion(.failure(.init()))
            return
        }
        
        guard authorizationStatus == .notDetermined else {
            completion(.failure(.init()))
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }
    }
}
