//
//  editCommentViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/26/24.
//

import UIKit
import KeychainSwift
import Photos

protocol editCommentViewControllerDelegate: AnyObject {
    func editComment(_ commentId: Int,_ comment: String)
}

class editCommentViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let keychain = KeychainSwift()
    var originalComment: String?
    var commentId: Int?
    private lazy var contentTextField = UITextView()
    private let warnView = UIView()
    lazy var remainCountLabel = UILabel()
    private let warnLabel = UILabel()
    weak var delegate: editCommentViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextField.text = originalComment
        setNavigate()
        setUI()
        setLayout()
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyBoardObserver()
        super.viewWillDisappear(animated)
    }

    private func setUI() {
        self.view.backgroundColor = UIColor.systemBackground
        stackView.do {
            $0.axis = .vertical
            $0.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: .zero, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        remainCountLabel.do {
            $0.text = "0/500"
            $0.font = .pretendard(size: 11, weight: .regular)
            $0.textColor = .G4()
            $0.textAlignment = .center
        }
        warnLabel.do {
            $0.text = "500자 이내로 간단히 입력해주세요."
            $0.font = .pretendard(size: 11, weight: .regular)
            $0.textColor = .G4()
        }

        contentTextField.do {
            $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0)
            $0.font = .pretendard(size: 17, weight: .regular)
            $0.textColor = .Black()
            $0.delegate = self
            $0.isScrollEnabled = false
            $0.sizeToFit()
        }
    }
    
    private func setLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        stackView.addArrangedSubviews(contentTextField, warnView)
        warnView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        warnView.addSubviews(remainCountLabel, warnLabel)
        remainCountLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextField.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
        warnLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
                view.addGestureRecognizer(tapGesture)
    }
    
    private func setNavigate() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        let button = UIButton(type: .system)
        button.setTitle("등록", for: .normal)
        button.backgroundColor = UIColor.P2()
        button.layer.cornerRadius = 18
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 33) // 버튼 크기 설정
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButtonItem
        }

    @objc private func closeButtonTapped() {
            dismiss(animated: true, completion: nil)
        }

    @objc private func addButtonTapped() {
        self.delegate?.editComment(commentId ?? 1, contentTextField.text)
        self.dismiss(animated: true, completion: nil)
    }
}

extension editCommentViewController: UITextViewDelegate {


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= 500 else { return false }
        updateCountLabel(characterCount: characterCount)

        return true
    }
    
    @objc
        private func didTapTextView(_ sender: Any) {
            view.endEditing(true)
        }

        private func updateCountLabel(characterCount: Int) {
            remainCountLabel.text = "\(characterCount)/500"
        }
}

extension editCommentViewController {
    
    // keyboard action control
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        /// 키보드의 높이
        let keyboardHeight = keyboardFrame.size.height

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        UIView.animate(withDuration: 0.3,
                       animations: { self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        
        scrollView.contentInset = .zero
        
        UIView.animate(withDuration: 0.3,
                       animations: { self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    func removeKeyBoardObserver() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
}
