//
//  AddPostViewController.swift
//  CoPro
//
//  Created by 문인호 on 1/26/24.
//

import UIKit

class AddPostViewController: UIViewController {

    private let authService: PhotoAuthManager = MyPhotoAuthManager()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let sortStackView = UIStackView()
    private let sortLabel = UILabel()
    private let sortButton = UIButton()
    private let titleTextField = UITextField()
    private lazy var contentTextField = UITextView()
    private let attachButton = UIButton()
    private let lineView1 = UIView()
    private let lineView2 = UIView()
    let textViewPlaceHolder = "내용을 입력하세요"
    lazy var remainCountLabel = UILabel()
    private let warnLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigate()
        setUI()
        setLayout()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
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
        sortStackView.do {
            $0.axis = .horizontal
        }
        sortLabel.do {
            $0.font = UIFont.systemFont(ofSize: 17)
            $0.text = "게시판 선택"
        }
        sortButton.do {
            $0.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }
        lineView1.do {
            $0.backgroundColor = UIColor(hex: "#D1D1D2")
        }
        titleTextField.do {
            $0.placeholder = "제목"
            $0.font = .systemFont(ofSize: 17)
        }
        lineView2.do {
            $0.backgroundColor = UIColor(hex: "#D1D1D2")
        }
        contentTextField.do {
            $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0)
            $0.font = .systemFont(ofSize: 17)
            $0.text = textViewPlaceHolder
            $0.textColor = .lightGray
            $0.delegate = self
            $0.isScrollEnabled = false
            $0.sizeToFit()
        }
        attachButton.do {
            $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
            attachButton.addTarget(self, action: #selector(attachButtonTapped), for: .touchUpInside)
            $0.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
            $0.backgroundColor = .lightGray
            $0.tintColor = .white
            $0.layer.cornerRadius = 45 / 2
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
        stackView.addArrangedSubviews(sortStackView, lineView1, titleTextField, lineView2, contentTextField, remainCountLabel,warnLabel, attachButton)
        sortStackView.snp.makeConstraints {
//            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(57)
        }
        sortStackView.addSubviews(sortLabel, sortButton)
        sortLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        sortButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.width.equalTo(24)
        }
        lineView1.snp.makeConstraints {
//            $0.top.equalTo(sortStackView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(0.5)
        }
        titleTextField.snp.makeConstraints {
//            $0.top.equalTo(lineView1.snp.bottom)
//            $0.leading.equalToSuperview().offset(16)
//            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(57)
        }
        lineView2.snp.makeConstraints {
//            $0.top.equalTo(titleTextField.snp.bottom)
//            $0.leading.equalToSuperview().offset(16)
//            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(0.5)
        }
//        contentTextField.snp.makeConstraints {
//            $0.top.equalTo(lineView2.snp.bottom)
//            $0.trailing.leading.equalToSuperview()
//            $0.height.equalTo(420)
//        }
//        remainCountLabel.snp.makeConstraints {
//            $0.top.equalTo(contentTextField.snp.bottom).offset(16)
//            $0.trailing.equalToSuperview().inset(16)
//        }
//        warnLabel.snp.makeConstraints {
//            $0.top.equalTo(remainCountLabel.snp.bottom).offset(4)
//            $0.trailing.equalToSuperview().inset(16)
//        }
        attachButton.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(25)
//            $0.bottom.equalToSuperview().offset(-30)
            $0.width.height.equalTo(45)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
                view.addGestureRecognizer(tapGesture)
    }
    
    private func setNavigate() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        let button = UIButton(type: .system)
        button.setTitle("등록", for: .normal)
        button.backgroundColor = UIColor(red: 0.145, green: 0.467, blue: 0.996, alpha: 1)
        button.layer.cornerRadius = 18
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 33) // 버튼 크기 설정

        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButtonItem
        }
    
    @objc private func closeButtonTapped() {
            dismiss(animated: true, completion: nil)
        }
    @objc private func attachButtonTapped() {
        authService.requestAuthorization { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                let vc = PhotoViewController().then {
                    $0.modalPresentationStyle = .fullScreen
                }
                present(vc, animated: true)
            case .failure:
                return
            }
        }
    }
}

extension AddPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
            updateCountLabel(characterCount: 0)
        }
    }

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
//            remainCountLabel.asColor(targetString: "\(characterCount)", color: characterCount == 0 ? .lightGray : .blue)
        }
}

extension UILabel {
    func asColor(targetString: String, color: UIColor?) {
        let fullText = text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: color as Any, range: range)
        attributedText = attributedString
    }
}
