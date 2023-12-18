//
//  SortBottomSheetViewController.swift
//  CoPro
//
//  Created by 문인호 on 12/12/23.
//

import UIKit

import SnapKit
import Then

final class SortBottomSheetViewController: UIViewController {

    // MARK: - UI Components
    
    private let sortRadioButton = RadioButtonsStack(groupId: 1)

    // MARK: - Properties
                    
    // MARK: - Initializer

    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addTarget()
    }
}

extension SortBottomSheetViewController {
    
    // MARK: - UI Components Property
    
    private func setUI() {
        
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 20
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [.custom {context in
                return 200
            }]
            
            sortRadioButton.do {
                let options = ["최신순", "인기순"]
                $0.set(options, defaultSelection: "최신순")
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
        }
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        view.addSubviews(sortRadioButton)
        
        sortRadioButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func addTarget() {
//        cancelButton.addTarget(self, action: #selector(dismissToCreateEvaluateViewController), for: .touchUpInside)
//        saveButton.addTarget(self, action: #selector(saveEvaluate), for: .touchUpInside)
    }
 
    // MARK: - @objc Methods
    
    @objc
    private func dismissToCreateEvaluateViewController() {
        dismiss(animated: true, completion: nil)
    }
 
    // MARK: - API 통신
    func emailAuthCode(email: String) {
//        UserAPI.shared.emailAuthCode(request: emailCodeRequest.init(email: email, code: textField.text ?? "")){ result in
//                switch result {
//                case .success:
//                    print("인증이 완료되었습니다.")
//                    NotificationCenter.default.post(name: NSNotification.Name("emailSignal"),
//                                                            object: true)
//                    self.dismiss(animated: false) { [weak self] in
//                            let customAlertVC = AlertViewController(alertType: .emailAuth)
//                            customAlertVC.modalPresentationStyle = .overFullScreen
//                            UIApplication.shared.windows.first?.rootViewController?.present(customAlertVC, animated: false, completion: nil)
//                        
//                    }
//                case .requestErr(let message):
//                    // Handle request error here.
//                    print("Request error: \(message)")
//                case .pathErr:
//                    // Handle path error here.
//                    print("Path error")
//                case .serverErr:
//                    // Handle server error here.
//                    print("Server error")
//                case .networkFail:
//                    // Handle network failure here.
//                    print("Network failure")
//                default:
//                    break
//                }
//            }
        }
}
