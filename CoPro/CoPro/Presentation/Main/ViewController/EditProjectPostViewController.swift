//
//  EditProjectPostViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/26/24.
//

import UIKit
import KeychainSwift
import Photos

class EditProjectPostViewController: UIViewController {

    var radioTmp = String()
    var checkTmp = String()
    weak var delegate: editPostViewControllerDelegate?
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let keychain = KeychainSwift()
    private let titleTextField = UITextField()
    private lazy var recruitContentTextField = UITextView()
    private let attachButton = UIButton()
    private let lineView1 = UIView()
    private let lineView2 = UIView()
    private var imageUrls = [Int]()
    private let warnView = UIView()
    lazy var remainCountLabel = UILabel()
    private let warnLabel = UILabel()
    private let imageScrollView = UIScrollView()
    var imageViews: [UIImageView] = []
    private let photoService: PhotoManager = MyPhotoManager()
    private let recruitLabel = UILabel()
    private let recruitStackView = UIStackView()
    private let partLabel = UILabel()
    private let partContentLabel = UILabel()
    private let partStackView = UIStackView()
    private let tagLabel = UILabel()
    private let tagRadioButton = RadioButtonsStack(groupId: 1)
    private let tagStackView = UIStackView()
    private let chatButton = UIButton()
    private let contentStackView = UIStackView()
    private lazy var checkboxes: [Checkbox] = [self.checkbox1, self.checkbox2, self.checkbox3, self.checkbox4]
    private lazy var checkbox1: Checkbox = {
        let checkbox = Checkbox(text: "AI")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox(_:)))
        checkbox.addGestureRecognizer(gesture)
        return checkbox
    }()
    private lazy var checkbox2: Checkbox = {
        let checkbox = Checkbox(text: "프론트엔드")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox(_:)))
        checkbox.addGestureRecognizer(gesture)
        return checkbox
    }()
    
    private lazy var checkbox3: Checkbox = {
        let checkbox = Checkbox(text: "백엔드")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox(_:)))
        checkbox.addGestureRecognizer(gesture)
        return checkbox
    }()
    private lazy var checkbox4: Checkbox = {
        let checkbox = Checkbox(text: "모바일")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox(_:)))
        checkbox.addGestureRecognizer(gesture)
        return checkbox
    }()
    @objc private func didTapCheckbox(_ sender: UITapGestureRecognizer) {
        guard let checkbox = sender.view as? Checkbox else { return }
        checkbox.toggle()
        if checkbox.isChecked {
            if let checkBoxText = checkbox.label.text {
                print("\(checkBoxText) is Checked")
            }
        } else {
            if let checkBoxText = checkbox.label.text {
                print("\(checkBoxText) is UnChecked")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let options = ["수익창출", "포트폴리오"]
        tagRadioButton.set(options, defaultSelection: radioTmp)
        checkCheckBoxes(with: checkTmp, in: checkboxes)
        tagRadioButton.delegate = self
        setNavigate()
        setUI()
        setLayout()
        addKeyboardObserver()
    }
    func checkCheckBoxes(with checkedTexts: String, in checkboxes: [Checkbox]) {
        // ',' 단위로 문자열을 분리하여 배열 생성
        let checkedTextArray = checkedTexts.components(separatedBy: ",")
        
        // 체크박스 순회
        for checkbox in checkboxes {
            // 체크박스의 텍스트가 배열에 포함되는 경우 isChecked를 true로 설정
            if let checkBoxText = checkbox.label.text, checkedTextArray.contains(checkBoxText) {
                checkbox.isChecked = true
                checkbox.checkbox.image = UIImage(systemName: "checkmark.square.fill")
            }
        }
    }
    func editProjectVC (title: String, content: String) {
        titleTextField.text = title
        recruitContentTextField.text = content
    }
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyBoardObserver()
        super.viewWillDisappear(animated)
    }
    
    private func setUI() {
        self.view.backgroundColor = UIColor.systemBackground
        recruitStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.distribution = .equalSpacing
        }
        partStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.distribution = .equalSpacing
        }
        tagStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.distribution = .equalSpacing
            $0.isUserInteractionEnabled = true
        }
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 32
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.distribution = .equalSpacing
            $0.layoutMargins = UIEdgeInsets(top: 16, left: .zero, bottom: .zero, right: .zero)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.isUserInteractionEnabled = true
        }
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

        lineView1.do {
            $0.backgroundColor = .G1()
        }
        titleTextField.do {
            $0.font = .pretendard(size: 17, weight: .bold)
        }
        lineView2.do {
            $0.backgroundColor = .G1()
        }
        recruitContentTextField.do {
            $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0)
            $0.font = .pretendard(size: 17, weight: .regular)
            $0.textColor = .Black()
            $0.delegate = self
            $0.isScrollEnabled = false
            $0.sizeToFit()
        }

        imageScrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        recruitLabel.do {
            $0.setPretendardFont(text: "모집 내용", size: 17, weight: .bold, letterSpacing: 1.25)
        }
        partLabel.do {
            $0.setPretendardFont(text: "모집 분야", size: 17, weight: .bold, letterSpacing: 1.25)
        }
        partContentLabel.do {
            $0.font = .pretendard(size: 17, weight: .regular)
        }
        tagLabel.do {
            $0.setPretendardFont(text: "목적", size: 17, weight: .bold, letterSpacing: 1.25)
        }
        tagRadioButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = true
        }
    }
    
    private func setLayout() {
        view.addSubview(attachButton)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        stackView.addArrangedSubviews(titleTextField, lineView2, contentStackView)
        contentStackView.addArrangedSubviews(recruitStackView, partStackView,tagStackView, imageScrollView)
        recruitStackView.addArrangedSubviews(recruitLabel, recruitContentTextField, warnView)
        partStackView.addArrangedSubview(partLabel)
        for checkbox in checkboxes {
            checkbox.snp.makeConstraints {
                $0.height.equalTo(20)
            }
            partStackView.addArrangedSubview(checkbox)
        }
        tagStackView.addArrangedSubviews(tagLabel, tagRadioButton)
        
        tagRadioButton.delegate = self
        imageScrollView.snp.makeConstraints {
            $0.height.equalTo(144)
        }
        titleTextField.snp.makeConstraints {
            $0.height.equalTo(57)
        }
        lineView2.snp.makeConstraints {
//            $0.top.equalTo(titleTextField.snp.bottom)
//            $0.leading.equalToSuperview().offset(16)
//            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(0.5)
        }
        warnView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        warnView.addSubviews(remainCountLabel, warnLabel)
        remainCountLabel.snp.makeConstraints {
            $0.top.equalTo(recruitContentTextField.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
        warnLabel.snp.makeConstraints {
            $0.top.equalTo(remainCountLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview()
        }
        attachButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.width.height.equalTo(45)
        }
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
//        tapGesture.delegate = self  // 이 부분 추가
//        view.addGestureRecognizer(tapGesture)
    }
    
    private func setNavigate() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        let button = UIButton(type: .system)
        button.setTitle("수정", for: .normal)
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
        var checkedTexts = ""
        for checkbox in checkboxes {
            if checkbox.isChecked, let checkBoxText = checkbox.label.text {
                if checkedTexts == "" {
                    checkedTexts += checkBoxText
                }
                else {
                    checkedTexts += "," + checkBoxText
                }
            }
        }
        var tagLabel = tagRadioButton.getSelectedText() ?? ""
        if titleTextField.text == "" || recruitContentTextField.text == "" {
                let alertController = UIAlertController(title: nil, message: "내용을 입력하세요", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        else if checkedTexts == "" {
            let alertController = UIAlertController(title: nil, message: "모집 분야를 선택해주세요", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else if tagLabel == "" {
            let alertController = UIAlertController(title: nil, message: "프로젝트 목적을 선택해주세요", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else {
            self.delegate?.didEditPost(title: titleTextField.text ?? "", category: "프로젝트", content: recruitContentTextField.text, image: imageUrls, tag: tagLabel, part: checkedTexts)
            self.dismiss(animated: true, completion: nil)
        }
//        self.delegate?.didPostArticle()
    }
}

extension EditProjectPostViewController: UITextViewDelegate {

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

extension EditProjectPostViewController {
    func addProjectPost( title: String, category: String, content: String, image: [Int], tag: String, part: String) {
        if let token = self.keychain.get("accessToken") {
            print("\(token)")
            BoardAPI.shared.addProjectPost(token: token, title: title, category: category, contents: content, imageId: image, tag: tag, part: part) { result in
                switch result {
                case .success:
                    print("success")
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
}

extension EditProjectPostViewController: ImageUploaderDelegate, SendStringData, UIGestureRecognizerDelegate {
    func didUploadImages(with urls: [Int]) {
        self.imageUrls = urls
    }
    
    func sendData(mydata: String, groupId: Int) {
        print("\(mydata)")
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
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
