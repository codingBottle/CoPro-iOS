//
//  ReportBottomSheetViewController.swift
//  CoPro
//
//  Created by 문인호 on 1/28/24.
//


import UIKit

import SnapKit
import Then
import KeychainSwift

final class ReportBottomSheetViewController: UIViewController {

    // MARK: - UI Components
    
    var postId: Int?
    private let reportLabel = UILabel()
    private let contentLabel = UILabel()
    private let contentTextView = UITextView()
    private let reportButton = UIButton()
    let textViewPlaceHolder = "신고내용을 입력해주세요"
    private let remainCountLabel = UILabel()
    private let keychain = KeychainSwift()

    // MARK: - Properties
                    
    // MARK: - Initializer

    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addTarget()
        setDelegate()
    }
}

extension ReportBottomSheetViewController {
    
    // MARK: - UI Components Property
    
    private func setDelegate() {
    }
    private func setUI() {
        
        view.backgroundColor = UIColor.White()
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 20
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [.custom {context in
                return 382
            }]
            
            
        }
        reportLabel.do {
            $0.text = "신고"
            $0.font = .pretendard(size: 17, weight: .bold)
        }
        contentLabel.do {
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            $0.font = .pretendard(size: 12, weight: .regular)
            $0.text = "이 게시물을 신고하는 이유를 작성해주세요. 무분별한 신고나 허위신고로\n판별날 시, 앱 사용에 제한이 있을 수 있습니다."
            $0.numberOfLines = 0
        }
        contentTextView.do {
            $0.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
            $0.text = textViewPlaceHolder
            $0.delegate = self
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            $0.font = .pretendard(size: 17, weight: .regular)
        }
        reportButton.do {
            $0.setTitle("접수", for: .normal)
            $0.layer.cornerRadius = 10
            updateButtonState(isEnabled: false)
        }
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        view.addSubviews(reportLabel,contentLabel,contentTextView,reportButton)
        
        reportLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(reportLabel.snp.bottom).offset(22)
            $0.trailing.leading.equalToSuperview().inset(16)
            
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.trailing.leading.equalToSuperview().inset(16)
            $0.height.equalTo(141)
        }
        reportButton.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(41)
        }
    }
    
    // MARK: - Methods
    
    private func addTarget() {
        reportButton.addTarget(self, action: #selector(reportButtonDidTapped), for: .touchUpInside)
    }
 
    func reportBoard( boardId: Int, contents: String) {
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.reportBoard(token: token, boardId: boardId, contents: contents) { result in
                switch result {
                case .success:
                    self.dismiss(animated: true, completion: nil)
                case .requestErr(let message):
                    print("Request error: \(message)")
                    
                case .pathErr:
                    print("Path error")
                    
                case .serverErr:
                    print("Server error")
                    
                case .networkFail:
                    print("Network failure")
                    
                default:
                    break
                }
            }
        }
    }
    // MARK: - @objc Methods
    
    @objc
    private func reportButtonDidTapped() {
        reportBoard(boardId: postId ?? 0, contents: contentTextView.text)
    }
}

extension ReportBottomSheetViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
            updateButtonState(isEnabled: false)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
            let characterCount = textView.text.count
            guard characterCount <= 700 else { return }
            updateCountLabel(characterCount: characterCount)
            updateButtonState(isEnabled: characterCount > 0) // 문자 수에 따라 버튼의 상태를 업데이트
        }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
            updateCountLabel(characterCount: 0)
            updateButtonState(isEnabled: false) // 텍스트 뷰가 비었을 때 버튼을 비활성화

        }
    }
    
    private func updateButtonState(isEnabled: Bool) {
            reportButton.isEnabled = isEnabled
        reportButton.backgroundColor = isEnabled ? UIColor.P2() : UIColor.G2()
        }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= 700 else { return false }
        updateCountLabel(characterCount: characterCount)

        return true
    }
    
    @objc
        private func didTapTextView(_ sender: Any) {
            view.endEditing(true)
        }

        private func updateCountLabel(characterCount: Int) {
            remainCountLabel.text = "\(characterCount)/500"
            remainCountLabel.asColor(targetString: "\(characterCount)", color: characterCount == 0 ? UIColor.G2() : UIColor.P2())
        }
}

