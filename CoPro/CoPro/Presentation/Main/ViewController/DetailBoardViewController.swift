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

final class DetailBoardViewController: UIViewController {
    var postId: Int?
    var isHeart = Bool()
    var isScrap = Bool()
    private let keychain = KeychainSwift()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let jobLabel = UILabel()
//    private let tagLabel = UILabel()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let viewCountLabel = UILabel()
    private let infoView = UIView()
    private let lineView1 = UIView()
    private let lineView2 = UIView()
    private let contentLabel = UILabel()
//    private let heartButton = UIButton()
//    private let heartCountLabel = UILabel()
    private let scrapButton = UIButton()
    private let chatButton = UIButton()
    private let bottomView = UIView()
//    private let commentTableView = UITableView()
//    private var filteredComments: [CommentData]!
//    var Comments = [CommentData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailBoard( boardId: postId!)
//        setUI()
        setLayout()
        addTarget()
        setNavigate()
    }
    private func addTarget() {
//        heartButton.addTarget(self, action: #selector(heartButtonTapped(_: )), for: .touchUpInside)
        scrapButton.addTarget(self, action: #selector(scrapButtonTapped(_: )), for: .touchUpInside)
    }
    private func setUI() {
        self.view.backgroundColor = .white


        stackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: .zero, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        titleLabel.do {
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//            $0.font = UIFont(name: "Pretendard-Medium", size : 22)
            $0.font = .systemFont(ofSize: 22)
        }
        nicknameLabel.do {
            $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
//            $0.font = UIFont(name: "Pretendard-Regular", size: 13)
            $0.font = .systemFont(ofSize: 13)
        }
        jobLabel.do {
                    $0.textColor = UIColor(red: 0.429, green: 0.432, blue: 0.446, alpha: 1)
//                    $0.font = UIFont(name: "Pretendard-Regular", size : 13)
            $0.font = .systemFont(ofSize: 13)
        }
//        tagLabel.do {
//                    $0.textColor = UIColor(red: 0.429, green: 0.432, blue: 0.446, alpha: 1)
////                    $0.font = UIFont(name: "Pretendard-Regular", size : 13)
//            $0.font = .systemFont(ofSize: 13)
//        }
        dateLabel.do {
                    $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
//                    $0.font = UIFont(name: "Pretendard-Regular", size : 13)
            $0.font = .systemFont(ofSize: 13)
        }
        timeLabel.do {
                    $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
//                    $0.font = UIFont(name: "Pretendard-Regular", size : 13)
            $0.font = .systemFont(ofSize: 13)
        }
        viewCountLabel.do {
            $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
            //            $0.font = UIFont(name: "Pretendard-Regular", size : 13)
            $0.font = .systemFont(ofSize: 13)
        }
        
        lineView1.do {
            $0.backgroundColor = UIColor(hex: "#D1D1D2")
        }
        contentLabel.do {
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//            $0.font = UIFont(name: "Pretendard-Regular", size: 17)
            $0.font = .systemFont(ofSize: 17)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
//        heartButton.do {
//                    $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
//        heartCountLabel.do {
//            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
////            $0.font = UIFont(name: "Pretendard-Regular", size: 17)
//            $0.font = .systemFont(ofSize: 17)
//        }
        chatButton.do {
            $0.layer.backgroundColor = UIColor(red: 0.145, green: 0.467, blue: 0.996, alpha: 1).cgColor
            $0.layer.cornerRadius = 10
            $0.setTitle("채팅하기", for: .normal)
        }
        lineView2.do {
            $0.backgroundColor = UIColor(hex: "#D1D1D2")
        }
        scrapButton.do {
            $0.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }
    private func setLayout() {
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
        bottomView.addSubviews(scrapButton, chatButton)
        scrapButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        chatButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(151)
            $0.height.equalTo(41)
            $0.centerY.equalToSuperview()
        }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
                }
        stackView.addArrangedSubviews(titleLabel,infoView,contentLabel)
        infoView.addSubviews(nicknameLabel, jobLabel, dateLabel, timeLabel, viewCountLabel, lineView1)
        infoView.snp.makeConstraints {
            $0.height.equalTo(28)
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
//        heartCountLabel.snp.makeConstraints {
//            $0.centerY.equalTo(chatButton.snp.centerY)
//            $0.trailing.equalTo(chatButton.snp.leading).offset(-15)
//        }
//        heartButton.snp.makeConstraints {
//            $0.centerY.equalTo(chatButton.snp.centerY)
//            $0.trailing.equalTo(heartCountLabel.snp.leading).offset(-6)
//            $0.width.height.equalTo(24)
//        }
    }
    private func setNavigate() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(popToMainViewController))
        leftButton.tintColor = UIColor(hex: "121213")
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
            navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "121213")

        }
    }
    func getDetailBoard( boardId: Int) {
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.getDetailBoard(token: token, boardId: boardId) { result in
                switch result {
                case .success(let data):
                    if let data = data as? DetailBoardDTO{
                        let serverData = data.data
                        let mappedItem = DetailBoardDataModel(boardId: data.data.boardId, title: data.data.title, createAt: data.data.createAt, category: data.data.category, contents: data.data.contents, tag: data.data.tag, count: data.data.count, heart: data.data.heart, imageUrl: data.data.imageUrl, nickName: data.data.nickName ?? "nil", occupation: data.data.occupation ?? "nil", isHeart: data.data.isHeart, isScrap: data.data.isScrap)
                        self.isHeart = data.data.isHeart
                        self.isScrap = data.data.isScrap
                        var mappedData: [CommentData] = []
                        DispatchQueue.main.async {
                            self.setUI()
                            self.updateView(with: mappedItem)
//                            self.commentTableView.reloadData()
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
//    func saveHeart( boardId: Int) {
//        if let token = self.keychain.get("idToken") {
//            print("\(token)")
//            BoardAPI.shared.saveHeart(token: token, boardID: boardId) { result in
//                switch result {
//                case .success(let data):
//                    if let data = data as? DetailHeartDataModel{
//                        DispatchQueue.main.async {
//                            self.heartCountLabel.text = "\(data.data.heart)"
//                            self.heartButton.tintColor = UIColor(hex: "#2577FE")
//                        }
//                        self.isHeart = true
//                    }
//                case .requestErr(let message):
//                    print("Request error: \(message)")
//                    
//                case .pathErr:
//                    print("Path error")
//                    
//                case .serverErr:
//                    print("Server error")
//                    
//                case .networkFail:
//                    print("Network failure")
//                    
//                default:
//                    break
//                }
//            }
//        }
//    }
//    func deleteHeart( boardId: Int) {
//        if let token = self.keychain.get("idToken") {
//            print("\(token)")
//            BoardAPI.shared.deleteHeart(token: token, boardID: boardId) { result in
//                switch result {
//                case .success(let data):
//                    if let data = data as? DetailHeartDataModel{
//                        DispatchQueue.main.async {
//                            self.heartCountLabel.text = "\(data.data.heart)"
//                            self.heartButton.tintColor = UIColor(hex: "#D1D1D2")
//                        }
//                        self.isHeart = false
//                    }
//                case .requestErr(let message):
//                    print("Request error: \(message)")
//                    
//                case .pathErr:
//                    print("Path error")
//                    
//                case .serverErr:
//                    print("Server error")
//                    
//                case .networkFail:
//                    print("Network failure")
//                    
//                default:
//                    break
//                }
//            }
//        }
//    }
    func saveScrap( boardId: Int) {
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.saveScrap(token: token, boardID: boardId) { result in
                switch result {
                case .success:
                        DispatchQueue.main.async {
                            self.scrapButton.tintColor = UIColor(hex: "#2577FE")
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
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.deleteScrap(token: token, boardID: boardId) { result in
                switch result {
                case .success:
                        DispatchQueue.main.async {
                            self.scrapButton.tintColor = UIColor(hex: "#D1D1D2")
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
//        tagLabel.text = data.tag
        dateLabel.text = data.getDateString()
        timeLabel.text = data.getTimeString()
        viewCountLabel.text = "조회 \(data.count)"
        contentLabel.text = data.contents
        scrapButton.tintColor = data.isScrap ? UIColor(hex: "#2577FE") : UIColor(hex: "#D1D1D2")
//        heartCountLabel.text = String(data.heart)
//        heartButton.tintColor = data.isHeart ? UIColor(hex: "#2577FE") : UIColor(hex: "#D1D1D2")
    }
    
    @objc
        func popToMainViewController() {
            self.navigationController?.popViewController(animated: true)
        }
    @objc
        func pushToCommentViewController() {
            self.navigationController?.popViewController(animated: true)
        }
    
//    @objc func heartButtonTapped(_ sender: UIButton) {
//        guard let postId = postId else { return }
//        if isHeart {
//            deleteHeart(boardId: postId)
//        }
//        else {
//            saveHeart(boardId: postId)
//        }
//    }
    @objc func scrapButtonTapped(_ sender: UIButton) {
        guard let postId = postId else { return }
        if isScrap {
            deleteScrap(boardId: postId)
        }
        else {
            saveScrap(boardId: postId)
        }
    }
}

//extension DetailBoardViewController: UITableViewDelegate, UITableViewDataSource {
//    private func setDelegate() {
//        commentTableView.delegate = self
//        commentTableView.dataSource = self
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredComments?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: commentTableViewCell.identifier, for: indexPath) as? commentTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let post: CommentData
//        if indexPath.row < filteredComments.count {
//            post = filteredComments[indexPath.row]
//        } else {
//            post = Comments[indexPath.row]
//        }
//        
//        cell.configureCell(post)
//        
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 87
//    }
//}
