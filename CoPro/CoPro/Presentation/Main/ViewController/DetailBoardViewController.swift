//
//  DetailBoardViewController.swift
//  CoPro
//
//  Created by 문인호 on 1/21/24.
//

import UIKit

import SnapKit
import Then
import KeychainSwift
import Kingfisher


final class DetailBoardViewController: BaseViewController {
    var postId: Int?
    var isHeart = Bool()
    var isScrap = Bool()
    var email: String?
    var picture: String?
    private let channelStream = ChannelFirestoreStream()
    private let keychain = KeychainSwift()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let jobLabel = UILabel()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let viewCountLabel = UILabel()
    private let infoView = UIView()
    private let lineView1 = UIView()
    private let lineView2 = UIView()
    private let contentLabel = UILabel()
    private let heartButton = UIButton()
    private let heartCountLabel = UILabel()
    private let scrapButton = UIButton()
    private let commentButton = UIButton()
    private let commentCountLabel = UILabel()
    private let bottomView = UIView()
    var imageViews: [UIImageView] = []
    private let imageScrollView = UIScrollView()
    private let recruitLabel = UILabel()
    private let recruitContentLabel = UILabel()
    private let recruitStackView = UIStackView()
    private let partLabel = UILabel()
    private let partContentLabel = UILabel()
    private let partStackView = UIStackView()
    private let tagLabel = UILabel()
    private let tagContentLabel = UILabel()
    private let tagStackView = UIStackView()
    private let chatButton = UIButton()
    private let contentStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailBoard( boardId: postId!)
        addTarget()
        setNavigate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    private func addTarget() {
        heartButton.addTarget(self, action: #selector(heartButtonTapped(_: )), for: .touchUpInside)
        scrapButton.addTarget(self, action: #selector(scrapButtonTapped(_: )), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonTapped(_: )), for: .touchUpInside)
        chatButton.addTarget(self, action: #selector(chatButtonTapped(_: )), for: .touchUpInside)
    }
    internal override func setUI() {
        
        self.view.backgroundColor = .white
        imageScrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: .zero, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
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
        }
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 32
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.distribution = .equalSpacing
        }
        
        titleLabel.do {
            $0.textColor = UIColor.Black()
            $0.font = .pretendard(size: 22, weight: .regular)
        }
        nicknameLabel.do {
            $0.textColor = UIColor.G4()
            $0.font = .pretendard(size: 13, weight: .regular)
        }
        jobLabel.do {
            $0.textColor = UIColor.Black()
            $0.font = .pretendard(size: 13, weight: .regular)
        }
        
        dateLabel.do {
            $0.textColor = UIColor.G2()
            $0.font = .pretendard(size: 13, weight: .regular)
        }
        timeLabel.do {
            $0.textColor = UIColor.G2()
            $0.font = .pretendard(size: 13, weight: .regular)
        }
        viewCountLabel.do {
            $0.textColor = UIColor.G2()
            $0.font = .pretendard(size: 13, weight: .regular)
        }
        
        lineView1.do {
            $0.backgroundColor = UIColor.G1()
        }
        contentLabel.do {
            $0.textColor = UIColor.Black()
            $0.font = .pretendard(size: 17, weight: .regular)
            $0.numberOfLines = 0
//            $0.lineBreakMode = .byCharWrapping
        }
        heartButton.do {_ in
            if isHeart {
                heartButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            } else {
                heartButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            }
        }
        heartCountLabel.do {
            $0.textColor = UIColor.Black()
            $0.font = .pretendard(size: 17, weight: .regular)
        }
        commentButton.do {
            $0.setImage(UIImage(systemName: "text.bubble"), for: .normal)
            $0.tintColor = UIColor.G4()
        }
        commentCountLabel.do {
            $0.textColor = UIColor.Black()
            $0.font = .pretendard(size: 17, weight: .regular)
        }
        lineView2.do {
            $0.backgroundColor = UIColor.G4()
        }
        scrapButton.do {_ in
            if isScrap {
                scrapButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                scrapButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
        recruitLabel.do {
            $0.setPretendardFont(text: "모집 내용", size: 17, weight: .bold, letterSpacing: 1.25)
        }
        recruitContentLabel.do {
            $0.font = .pretendard(size: 17, weight: .regular)
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
        tagContentLabel.do {
            $0.font = .pretendard(size: 17, weight: .regular)
        }
        chatButton.do {
            $0.backgroundColor = .P2()
            $0.setTitle("채팅하기", for: .normal)
            $0.setTitleColor(.White(), for: .normal)
            $0.titleLabel?.font = .pretendard(size: 17, weight: .bold)
            $0.layer.cornerRadius = 10
        }
    }
    private func setLayoutFree() {
        view.addSubviews(scrollView,lineView2 ,bottomView)
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(lineView2.snp.top)
        }
        lineView2.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(64)
        }
        bottomView.addSubviews(scrapButton, heartButton,heartCountLabel, commentButton, commentCountLabel)
        scrapButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        heartButton.snp.makeConstraints {
            $0.leading.equalTo(scrapButton.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        heartCountLabel.snp.makeConstraints {
            $0.leading.equalTo(heartButton.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
        commentCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        commentButton.snp.makeConstraints {
            $0.trailing.equalTo(commentCountLabel.snp.leading).offset(-5)
            $0.centerY.equalToSuperview()
        }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        stackView.addArrangedSubviews(titleLabel,infoView,contentLabel,imageScrollView)
        infoView.addSubviews(nicknameLabel, jobLabel, dateLabel, timeLabel, viewCountLabel, lineView1)
        infoView.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        imageScrollView.snp.makeConstraints {
            $0.height.equalTo(144)
        }
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        jobLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
        viewCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(viewCountLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        lineView1.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setLayoutProject() {
        view.addSubviews(scrollView,lineView2 ,bottomView)
        chatButton.isEnabled = true
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(lineView2.snp.top)
        }
        lineView2.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(64)
        }
        bottomView.addSubviews(scrapButton, chatButton)
        scrapButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        chatButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(151)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        stackView.addArrangedSubviews(titleLabel,infoView, contentStackView)
        contentStackView.addArrangedSubviews(recruitStackView, partStackView,tagStackView, imageScrollView)
        recruitStackView.addArrangedSubviews(recruitLabel, recruitContentLabel)
        partStackView.addArrangedSubviews(partLabel, partContentLabel)
        tagStackView.addArrangedSubviews(tagLabel, tagContentLabel)
        
        infoView.addSubviews(nicknameLabel, jobLabel, dateLabel, timeLabel, viewCountLabel, lineView1)
        infoView.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        imageScrollView.snp.makeConstraints {
            $0.height.equalTo(144)
        }
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        jobLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
        viewCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(viewCountLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        lineView1.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func setNoticeLayout() {
        view.addSubviews(scrollView,lineView2)
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(lineView2.snp.top)
        }
        lineView2.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        stackView.addArrangedSubviews(titleLabel,infoView,contentLabel,imageScrollView)
        infoView.addSubviews(nicknameLabel, jobLabel, dateLabel, timeLabel, viewCountLabel, lineView1)
        infoView.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        imageScrollView.snp.makeConstraints {
            $0.height.equalTo(144)
        }
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        jobLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
        viewCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(viewCountLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        lineView1.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func setNavigate() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popToMainViewController))
        leftButton.tintColor = UIColor.G6()
        self.navigationItem.leftBarButtonItem = leftButton
        if #available(iOS 14.0, *) {
            let menuItem1 = UIAction(title: "신고", attributes: .destructive) { action in
                guard let boardId = self.postId else { return }
                let bottomSheetVC = ReportBottomSheetViewController()
                bottomSheetVC.postId = boardId
                self.present(bottomSheetVC, animated: true, completion: nil)
            }
            
            let menu = UIMenu(title: "", children: [menuItem1])
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: menu)
            navigationItem.rightBarButtonItem?.tintColor = UIColor.G6()
            
        }
    }
    func getDetailBoard( boardId: Int) {
        if let token = self.keychain.get("accessToken") {
            print("\(token)")
            BoardAPI.shared.getDetailBoard(token: token, boardId: boardId) { result in
                switch result {
                case .success(let data):
                    if let data = data as? DetailBoardDTO{
                        let serverData = data.data
                        let mappedItem = DetailBoardDataModel(boardId: data.data.boardId, title: data.data.title, createAt: data.data.createAt, category: data.data.category ?? "nil", contents: data.data.contents ?? "nil" , tag: data.data.tag ?? nil, count: data.data.count, heart: data.data.heart, imageUrl: data.data.imageUrl, nickName: data.data.nickName ?? "nil", occupation: data.data.occupation ?? "nil", isHeart: data.data.isHeart, isScrap: data.data.isScrap, commentCount: data.data.commentCount, part: data.data.part ?? "nil", email: data.data.email , picture: data.data.picture)
                        self.isHeart = data.data.isHeart
                        self.isScrap = data.data.isScrap
                        DispatchQueue.main.async { [self] in
                            self.setUI()
                            switch mappedItem.category {
                            case "프로젝트":
                                self.setLayoutProject()
                            case "자유":
                                self.setLayoutFree()
                            case "공지사항":
                                self.setNoticeLayout()
                            default:
                                break
                            }
                            self.updateView(with: mappedItem)
                        }
                    }
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
    func saveHeart( boardId: Int) {
        if let token = self.keychain.get("accessToken") {
            print("\(token)")
            BoardAPI.shared.saveHeart(token: token, boardID: boardId) { result in
                switch result {
                case .success(let data):
                    if let data = data as? DetailHeartDataModel{
                        DispatchQueue.main.async {
                            self.heartCountLabel.text = "\(data.data.heart)"
                            self.heartButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                            self.heartButton.tintColor = UIColor.G5()
                        }
                        self.isHeart = true
                    }
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
    func deleteHeart( boardId: Int) {
        if let token = self.keychain.get("accessToken") {
            print("\(token)")
            BoardAPI.shared.deleteHeart(token: token, boardID: boardId) { result in
                switch result {
                case .success(let data):
                    if let data = data as? DetailHeartDataModel{
                        DispatchQueue.main.async {
                            self.heartCountLabel.text = "\(data.data.heart)"
                            self.heartButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
                            self.heartButton.tintColor = UIColor.G4()
                        }
                        self.isHeart = false
                    }
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
    
    func saveScrap( boardId: Int) {
        if let token = self.keychain.get("accessToken") {
            print("\(token)")
            BoardAPI.shared.saveScrap(token: token, boardID: boardId) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.scrapButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                        self.scrapButton.tintColor = UIColor.G5()
                    }
                    self.isScrap = true
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
    func deleteScrap( boardId: Int) {
        if let token = self.keychain.get("accessToken") {
            print("\(token)")
            BoardAPI.shared.deleteScrap(token: token, boardID: boardId) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.scrapButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                        self.scrapButton.tintColor = UIColor.G4()
                    }
                    self.isScrap = false
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
    func updateView(with data: DetailBoardDataModel) {
        titleLabel.text = data.title
        nicknameLabel.text = data.nickName
        jobLabel.text = data.occupation
        recruitContentLabel.text = data.contents
        partContentLabel.text = data.part
        tagContentLabel.text = data.tag
        dateLabel.text = data.getDateString()
        timeLabel.text = data.getTimeString()
        viewCountLabel.text = "조회 \(data.count)"
        contentLabel.text = data.contents
        scrapButton.tintColor = data.isScrap ? UIColor.G5() : UIColor.G4()
        heartCountLabel.text = String(data.heart)
        heartButton.tintColor = data.isHeart ? UIColor.G5() : UIColor.G4()
        commentCountLabel.text = String(data.commentCount)
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        email = data.email
        picture = data.picture
        
        // 받은 모든 URL을 UIImageView로 생성하여 UIScrollView에 추가
        var xOffset: CGFloat = 0
        for url in data.imageUrl! {
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
                
                xOffset += 156 // 다음 이미지 뷰의 x 좌표 오프셋
                
                // 스크롤 뷰의 contentSize를 설정하여 모든 이미지 뷰가 보이도록 함
                self.imageScrollView.contentSize = CGSize(width: xOffset, height: 144)
            }
        }
    }
    
    @objc
    func popToMainViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc
    func pushToCommentViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func heartButtonTapped(_ sender: UIButton) {
        guard let postId = postId else { return }
        if isHeart {
            deleteHeart(boardId: postId)
        }
        else {
            saveHeart(boardId: postId)
        }
    }
    @objc func scrapButtonTapped(_ sender: UIButton) {
        guard let postId = postId else { return }
        if isScrap {
            deleteScrap(boardId: postId)
        }
        else {
            saveScrap(boardId: postId)
        }
    }
    @objc func commentButtonTapped(_ sender: UIButton) {
        let boardCommentVC = BoardCommentViewController()
        // 필요한 경우 여기에서 boardCommentVC의 프로퍼티를 설정x
        boardCommentVC.postId = postId
        self.navigationController?.pushViewController(boardCommentVC, animated: true)
    }
    
    @objc func chatButtonTapped(_ sender: UIButton) {
        print("Chat 버튼이 눌렸습니다.")
        let keychain = KeychainSwift()
        guard let receiverurl = picture, let receiverEmail = email else {return}
        
        guard let currentUserNickName = keychain.get("currentUserNickName") else {return}
        guard let currentUserProfileImage = keychain.get("currentUserProfileImage") else {return}
        guard let currentUserOccupation = keychain.get("currentUserOccupation") else {return}
       guard let currentUserEmail = keychain.get("currentUserEmail") else {return}
        let channelId = [currentUserNickName, nicknameLabel.text ?? ""].sorted().joined(separator: "-")
        
        channelStream.createChannel(channelId: channelId, sender: currentUserNickName, senderJobTitle: currentUserOccupation, senderProfileImage: currentUserProfileImage, senderEmail: currentUserEmail, receiver: nicknameLabel.text ?? "", receiverJobTitle: jobLabel.text ?? "", receiverProfileImage: receiverurl, receiverEmail: receiverEmail) {error in
            if let error = error {
                // 실패: 오류 메시지를 출력하거나 사용자에게 오류 상황을 알립니다.
                print("Failed to create channel: \(error.localizedDescription)")
                self.chatRoomCreationResult(result: false)
            } else {
                // 성공: 채팅 버튼을 탭하거나 필요한 다른 동작을 수행합니다.
                self.chatRoomCreationResult(result: true)
            }
        }
        
    }
    
    private func chatRoomCreationResult(result: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let tabBarController = window.rootViewController as? BottomTabController {
            if let tabBarController = self.tabBarController as? BottomTabController {
                tabBarController.selectedIndex = 3
            }
        }
        DispatchQueue.main.async {
            if result {
                self.showAlert(title: "🥳채팅방이 개설되었습니다🥳",
                               message: "채팅 리스트에서 확인하여주세요!",
                               confirmButtonName: "확인")
            }
            else {
                self.showAlert(title: "이미 채팅방에 존재하는 사람입니다",
                               message: "채팅 리스트에서 확인하여주세요",
                               confirmButtonName: "확인")
            }
        }
    }
}
