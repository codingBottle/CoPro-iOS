//
//  EditPostViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/26/24.
//

import UIKit
import KeychainSwift
import Photos

protocol editPostViewControllerDelegate: AnyObject{
    func didEditPost(title: String, category: String, content: String, image: [Int], tag: String, part: String)
}

class EditPostViewController: UIViewController {

    weak var delegate: editPostViewControllerDelegate?
    func sendData(mydata: String, groupId: Int) {
        sortLabel.text = mydata
    }
    
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
    private lazy var contentTextField = UITextView()
    private let attachButton = UIButton()
    private let lineView1 = UIView()
    private let lineView2 = UIView()
    private var imageUrls = [Int]()
    private let warnView = UIView()
    lazy var remainCountLabel = UILabel()
    private let warnLabel = UILabel()
    private let imageScrollView = UIScrollView()
    private var imageUrl = [String]()
    var imageViews: [UIImageView] = []
    private let photoService: PhotoManager = MyPhotoManager()
    override func viewDidLoad() {
        super.viewDidLoad()
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

    func editFreeVC (title: String, content: String, imageId: [Int]?, imageUrl: [String]?) {
        titleTextField.text = title
        contentTextField.text = content
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
        sortStackView.do {
            $0.axis = .horizontal
        }

        titleTextField.do {
            $0.placeholder = "제목"
            $0.font = .pretendard(size: 17, weight: .bold)
        }
        lineView2.do {
            $0.backgroundColor = UIColor.G1()
        }
        contentTextField.do {
            $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0)
            $0.font = .pretendard(size: 17, weight: .regular)
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
        stackView.addArrangedSubviews(titleTextField, lineView2, contentTextField, warnView, imageScrollView)
        imageScrollView.snp.makeConstraints {
            $0.height.equalTo(144)
        }

        titleTextField.snp.makeConstraints {
            $0.height.equalTo(57)
        }
        lineView2.snp.makeConstraints {
            $0.height.equalTo(0.5)
        }

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
        attachButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.width.height.equalTo(45)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
                view.addGestureRecognizer(tapGesture)
    }
    
    private func setNavigate() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        let button = UIButton(type: .system)
        button.setTitle("수정", for: .normal)
        button.backgroundColor = UIColor.P2()
        button.layer.cornerRadius = 18
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 33) // 버튼 크기 설정
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
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
    @objc private func editButtonTapped() {

        self.delegate?.didEditPost(title: titleTextField.text ?? "", category: "자유", content: contentTextField.text, image: imageUrls, tag: "수익창출", part: "AI")
        self.dismiss(animated: true, completion: nil)
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

extension EditPostViewController: UITextViewDelegate {

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

extension EditPostViewController: ImageUploaderDelegate {
    func didUploadImages(with urls: [Int]) {
        self.imageUrls = urls
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