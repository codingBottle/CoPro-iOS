//
//  AddProjectPostViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/19/24.
//

import UIKit
import KeychainSwift
import Photos

class AddProjectPostViewController: UIViewController {
    
    private enum Const {
        static let numberOfColumns = 3.0
        static let cellSpace = 1.0
        static let length = (UIScreen.main.bounds.size.width - cellSpace * (numberOfColumns - 1)) / numberOfColumns
        static let cellSize = CGSize(width: length, height: length)
        static let scale = UIScreen.main.scale
    }
    private let authService: PhotoAuthManager = MyPhotoAuthManager()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let keychain = KeychainSwift()
    private let sortStackView = UIStackView()
    private let sortLabel = UILabel()
    private let sortButton = UIButton()
    private let titleTextField = UITextField()
    private lazy var recruitContentTextField = UITextView()
    private let attachButton = UIButton()
    private let lineView1 = UIView()
    private let lineView2 = UIView()
    private var imageUrls = [Int]()
    let textViewPlaceHolder = "내용을 입력하세요"
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
    weak var delegate: AddPostViewControllerDelegate?
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
        tagRadioButton.set(options, defaultSelection: nil)
        tagRadioButton.delegate = self
        setNavigate()
        setUI()
        setLayout()
        view.bringSubviewToFront(attachButton)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveImages(_:)), name: NSNotification.Name("SelectedImages"), object: nil)
        addKeyboardObserver()
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
        sortStackView.do {
            $0.axis = .horizontal
        }
        sortLabel.do {
            $0.font = UIFont.pretendard(size: 17, weight: .regular)
            $0.text = "프로젝트"
        }
//        sortButton.do {
//            $0.setImage(UIImage(systemName: "chevron.up"), for: .normal)
//            $0.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
//        }
        lineView1.do {
            $0.backgroundColor = .G1()
        }
        titleTextField.do {
            $0.placeholder = "제목"
            $0.font = .pretendard(size: 17, weight: .bold)
        }
        lineView2.do {
            $0.backgroundColor = .G1()
        }
        recruitContentTextField.do {
            $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0)
            $0.font = .pretendard(size: 17, weight: .regular)
            $0.text = textViewPlaceHolder
            $0.textColor = .Black()
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
        stackView.addArrangedSubviews(sortStackView, lineView1, titleTextField, lineView2, contentStackView)
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
        sortStackView.snp.makeConstraints {
//            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(57)
        }
        sortStackView.addSubviews(sortLabel)
        sortLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }

//        sortButton.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.trailing.equalToSuperview()
//            $0.height.width.equalTo(24)
//        }
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
    @objc private func attachButtonTapped() {
        authService.requestAuthorization { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                let vc = PhotoViewController().then {
                    $0.modalPresentationStyle = .fullScreen
                }
                vc.delegate = self
                present(vc, animated: true)
            case .failure:
                return
            }
        }
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
            addProjectPost(title: titleTextField.text ?? "", category: sortLabel.text!, content: recruitContentTextField.text, image: imageUrls, tag: tagLabel ?? "", part: checkedTexts)
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func receiveImages(_ notification: Notification) {
        print("receiveImagebuttontapped")
        
        // userInfo에서 PHAsset 배열을 가져옴
        if let assets = notification.userInfo?["images"] as? [PHAsset] {
            // 기존의 모든 이미지 뷰 제거
            imageViews.forEach { $0.removeFromSuperview() }
            imageViews.removeAll()
            
            // 받은 모든 PHAsset을 UIImageView로 생성하여 UIScrollView에 추가
            var xOffset: CGFloat = 0
            for asset in assets {
                // 비동기적으로 이미지 로드
                photoService.fetchImage(
                    phAsset: asset,
                    size: CGSize(width: 144 * Const.scale, height: 144 * Const.scale),
                    contentMode: .aspectFit,
                    completion: { [weak self] image in
                        DispatchQueue.main.async {
                            // 이미지 뷰 생성 및 추가
                            let imageView = UIImageView(image: image)
                            imageView.frame = CGRect(x: xOffset, y: 0, width: 144, height: 144)
                            self?.imageScrollView.addSubview(imageView)
                            self?.imageViews.append(imageView)
                            imageView.do {
                                $0.layer.cornerRadius = 10
                                $0.clipsToBounds = true
                            }
                            
                            xOffset += 156 // 다음 이미지 뷰의 x 좌표 오프셋
                            
                            // 스크롤 뷰의 contentSize를 설정하여 모든 이미지 뷰가 보이도록 함
                            self?.imageScrollView.contentSize = CGSize(width: xOffset, height: 144)
                        }
                    }
                )
            }
        }
    }
}

extension AddProjectPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .Black()
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

extension AddProjectPostViewController {
    func addProjectPost( title: String, category: String, content: String, image: [Int], tag: String, part: String) {
        if let token = self.keychain.get("accessToken") {
            print("\(token)")
            BoardAPI.shared.addProjectPost(token: token, title: title, category: category, contents: content, imageId: image, tag: tag, part: part) { result in
                switch result {
                case .success:
                    print("success")
                    self.delegate?.didPostArticle()
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

extension AddProjectPostViewController: ImageUploaderDelegate, SendStringData, UIGestureRecognizerDelegate {
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
