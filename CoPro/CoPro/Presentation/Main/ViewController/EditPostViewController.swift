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
    func didEditPost(title: String, category: String, content: String, image: [Int], tag: String, part: String, originImages: [Int]?)
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
    private var deletingImages = [Int]()
    private var originImages = [Int]()
    private var deleteImages = [Int]()
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
        originImages = imageId ?? []
        if let assets = imageUrl {
            var xOffset: CGFloat = 0
            if let lastImageView = imageViews.last {
                xOffset = lastImageView.frame.origin.x + lastImageView.frame.width + 12
            }
            if let imageUrl = imageUrl {
                for url in imageUrl {
                    // 비동기적으로 이미지 로드
                    let imageView = UIImageView()
                    imageView.kf.indicatorType = .activity
                    imageView.kf.setImage(with: URL(string:url), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                    DispatchQueue.main.async {
                        // 이미지 뷰 생성 및 추가
                        imageView.frame = CGRect(x: xOffset, y: 0, width: 144, height: 144)
                        self.imageScrollView.addSubview(imageView)
                        self.imageViews.append(imageView)
                        imageView.do {
                            $0.layer.cornerRadius = 10
                            $0.clipsToBounds = true
                        }
                        // 삭제 버튼 생성 및 추가
                        let deleteButton = UIButton(frame: CGRect(x: xOffset + 144 - 20, y: 0, width: 20, height: 20))
                        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
                        deleteButton.tintColor = .L2()
                        deleteButton.addTarget(self, action: #selector(self.deleteImageView(_:)), for: .touchUpInside)
                        self.imageScrollView.addSubview(deleteButton)
                        
                        xOffset += 156 // 다음 이미지 뷰의 x 좌표 오프셋
                        
                        // 스크롤 뷰의 contentSize를 설정하여 모든 이미지 뷰가 보이도록 함
                        self.imageScrollView.contentSize = CGSize(width: xOffset, height: 144)
                    }
                }
            }
        }
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
        deletePhoto(imageIds: deletingImages)
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
        if titleTextField.text == "" || contentTextField.text == "" {
                let alertController = UIAlertController(title: nil, message: "내용을 입력하세요", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        else if imageUrls.count + originImages.count > 5 {
            let alertController = UIAlertController(title: nil, message: "사진은 5개 이하로만 첨부 가능합니다.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else {
            let result = self.deletingImages.filter { !self.imageUrls.contains($0) }
            self.deletePhoto(imageIds: result)
            print("result: \(result)")
            self.delegate?.didEditPost(title: titleTextField.text ?? "", category: "자유", content: contentTextField.text, image: imageUrls, tag: "수익창출", part: "AI", originImages: deleteImages)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func deletePhoto ( imageIds: [Int]) {
        if let token = self.keychain.get("accessToken") {
            BoardAPI.shared.deleteImage(token: token, boardId: nil, imageIds: imageIds){ result in
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
    @objc func receiveImages(_ notification: Notification) {
        print("receiveImagebuttontapped")

        // userInfo에서 PHAsset 배열을 가져옴
        if let assets = notification.userInfo?["images"] as? [PHAsset] {
            var xOffset: CGFloat = 0
            if let lastImageView = imageViews.last {
                xOffset = lastImageView.frame.origin.x + lastImageView.frame.width + 12
            }
            
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
                            
                            // 삭제 버튼 생성 및 추가
                            let deleteButton = UIButton(frame: CGRect(x: xOffset + 144 - 20, y: 0, width: 20, height: 20))
                            deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
                            deleteButton.tintColor = .L2()
                            deleteButton.addTarget(self, action: #selector(self?.deleteImageView(_:)), for: .touchUpInside)
                            self?.imageScrollView.addSubview(deleteButton)
                            
                            xOffset += 156 // 다음 이미지 뷰의 x 좌표 오프셋
                            
                            // 스크롤 뷰의 contentSize를 설정하여 모든 이미지 뷰가 보이도록 함
                            self?.imageScrollView.contentSize = CGSize(width: xOffset, height: 144)
                        }
                    }
                )
            }
        }
    }
    @objc func deleteImageView(_ sender: UIButton) {
        // 이미지 뷰와 삭제 버튼을 제거
        if let index = imageViews.firstIndex(where: { $0.frame.origin.x == sender.frame.origin.x - 144 + 20 }) {
            imageViews[index].removeFromSuperview()
            imageViews.remove(at: index)
            sender.removeFromSuperview()
            if index < originImages.count {
                deleteImages.append(originImages[index])
                originImages.remove(at: index)
                print("delete Images = \(deleteImages)")
                print("origin Images = \(originImages)")
            }
            else {
                imageUrls.remove(at: index - originImages.count)
                print("imageUrls = \(imageUrls)")
            }
        }
        
        // 나머지 이미지 뷰와 삭제 버튼 재배치
        var xOffset: CGFloat = 0
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.origin.x = xOffset
            imageScrollView.subviews.filter { $0 is UIButton }[index].frame.origin.x = xOffset + 144 - 20
            xOffset += 156
        }
        imageScrollView.contentSize = CGSize(width: xOffset, height: 144)
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
        self.imageUrls += urls
        self.deletingImages += urls
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
