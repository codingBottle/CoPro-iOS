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
    
    private let keychain = KeychainSwift()
    var editGitHubURLBody = EditGitHubURLRequestBody()
    var originalHeight: CGFloat = 0
    
    let container = UIView()
    
    let githubLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.23
        $0.attributedText = NSMutableAttributedString(string: "Git URL", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    let textFieldContainer = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.824, alpha: 1).cgColor
        $0.layer.cornerRadius = 10
    }
    
    lazy var doneButton = UIButton().then {
        $0.layer.backgroundColor = UIColor(.gray).cgColor
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(didTapdoneButton), for: .touchUpInside)
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.titleLabel?.textColor = .white
    }
    
    let githubURLtextFieldLabel = UITextField().then {
        $0.placeholder = "GitHub URL을 입력해주세요"
        $0.clearButtonMode = .always
        $0.keyboardType = .URL
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        githubURLtextFieldLabel.delegate = self
        githubURLtextFieldLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        originalHeight = returnTextFieldHeight()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func setUI() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 15
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [.custom {context in
                return self.returnUIHeight()
            }]
        }
    }
    override func setLayout() {
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
            $0.leading.equalToSuperview().offset(8)
            $0.width.equalTo(60)
        }
        
        textFieldContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(githubLabel.snp.bottom).offset(12)
            $0.height.equalTo(returnTextFieldHeight())
        }
        
        githubURLtextFieldLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(githubLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-6)
        }
        
        doneButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(textFieldContainer.snp.bottom).offset(18)
            $0.height.equalTo(textFieldContainer.snp.height)
        }
    }
    
    private func returnUIHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let heightRatio = 204.0 / 852.0
        let cellHeight = screenHeight * heightRatio
        return cellHeight
    }
    
    private func returnTextFieldHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let heightRatio = 50.0 / 852.0
        let cellHeight = screenHeight * heightRatio
        return cellHeight
    }
    
    override func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            print("사용자가 입력한 텍스트: \(text)")
            editGitHubURLBody.gitHubURL = text
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func didTapdoneButton() {
        print("지금 didTapdoneButton 눌림")
        postEditGitHubURL()
        self.dismiss(animated: true)
    }
    
    private func postEditGitHubURL() {
        if let token = self.keychain.get("accessToken") {
            MyProfileAPI.shared.postEditGitHubURL(token: token, requestBody: editGitHubURLBody) { result in
                switch result {
                case .success(_):
                    print("성공")
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
    
    
    //MARK: - @objc func
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if textField.text?.count == 0 {
                self.doneButton.backgroundColor = .gray
            } else {
                self.doneButton.backgroundColor = UIColor(red: 0.145, green: 0.467, blue: 0.996, alpha: 1)
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
            if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                
                doneButton.isEnabled = false
                
                textFieldContainer.snp.remakeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.leading.trailing.equalToSuperview()
                    $0.top.equalTo(githubLabel.snp.bottom).offset(8)
                    $0.height.equalTo(returnTextFieldHeight())
                }
                
                doneButton.snp.remakeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.leading.trailing.equalToSuperview()
                    $0.top.equalTo(textFieldContainer.snp.bottom).offset(18)
                    $0.height.equalTo(textFieldContainer.snp.height)
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        doneButton.isEnabled = true
        
        textFieldContainer.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(githubLabel.snp.bottom).offset(8)
                $0.height.equalTo(originalHeight)
            }
        
        doneButton.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(textFieldContainer.snp.bottom).offset(18)
            $0.height.equalTo(textFieldContainer.snp.height)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
