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
    private let keychain = KeychainSwift()
    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let jobLabel = UILabel()
    private let tagLabel = UILabel()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let viewCountLabel = UILabel()
    private let infoStackView = UIStackView()
    private let nameStackView = UIStackView()
    private let dateStackView = UIStackView()
    private let lineView1 = UIView()
    private let lineView2 = UIView()
    private let contentLabel = UILabel()
    private let heartButton = UIButton()
    private let heartCountLabel = UILabel()
    private let chatButton = UIButton()
    private let commentTableView = UITableView()
    private var filteredComments: [CommentData]!
    var Comments = [CommentData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailBoard( boardId: postId!)
//        setUI()
        setLayout()
        addTarget()
        setNavigate()
    }
    private func addTarget() {
        heartButton.addTarget(self, action: #selector(heartButtonTapped(_: )), for: .touchUpInside)
    }
    private func setUI() {
        self.view.backgroundColor = .white
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
        tagLabel.do {
                    $0.textColor = UIColor(red: 0.429, green: 0.432, blue: 0.446, alpha: 1)
//                    $0.font = UIFont(name: "Pretendard-Regular", size : 13)
            $0.font = .systemFont(ofSize: 13)
        }
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
        infoStackView.do {
            $0.axis = .horizontal
        }
        nameStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
        }
        dateStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
        }
        lineView1.do {
            $0.backgroundColor = UIColor(hex: "#D1D1D2")
        }
        contentLabel.do {
            $0.frame = CGRect(x: 0, y: 0, width: 282, height: 50)
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//            $0.font = UIFont(name: "Pretendard-Regular", size: 17)
            $0.font = .systemFont(ofSize: 17)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
        heartButton.do {
                    $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        heartCountLabel.do {
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//            $0.font = UIFont(name: "Pretendard-Regular", size: 17)
            $0.font = .systemFont(ofSize: 17)
        }
        chatButton.do {
            $0.frame = CGRect(x: 0, y: 0, width: 151, height: 41)
            $0.layer.backgroundColor = UIColor(red: 0.145, green: 0.467, blue: 0.996, alpha: 1).cgColor
            $0.layer.cornerRadius = 10
        }
        lineView2.do {
            $0.backgroundColor = UIColor(hex: "#D1D1D2")
        }
        commentTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .singleLine
        }
    }
    private func setLayout() {
        view.addSubviews(titleLabel,infoStackView, lineView1,contentLabel,heartButton,heartCountLabel, lineView2,chatButton,commentTableView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        infoStackView.addSubviews(nameStackView, dateStackView)
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(28)
        }
        nameStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        nameStackView.addArrangedSubviews(nicknameLabel, jobLabel,tagLabel)
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        dateStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        dateStackView.addArrangedSubviews(dateLabel, timeLabel, viewCountLabel)
        viewCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        lineView1.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(0.5)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-139)
        }
        chatButton.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(151)
            $0.height.equalTo(41)
        }
        heartCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(chatButton.snp.centerY)
            $0.trailing.equalTo(chatButton.snp.leading).offset(-15)
        }
        heartButton.snp.makeConstraints {
            $0.centerY.equalTo(chatButton.snp.centerY)
            $0.trailing.equalTo(heartCountLabel.snp.leading).offset(-6)
            $0.width.height.equalTo(24)
        }
        lineView2.snp.makeConstraints {
            $0.top.equalTo(chatButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(0.5)
        }
    }
    private func setNavigate() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(popToMainViewController))
        leftButton.tintColor = UIColor(hex: "121213")
        self.navigationItem.leftBarButtonItem = leftButton
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
                        var mappedData: [CommentData] = []
                        DispatchQueue.main.async {
                            self.setUI()
                            self.updateView(with: mappedItem)
                            self.commentTableView.reloadData()
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
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.saveHeart(token: token, boardID: boardId) { result in
                switch result {
                case .success:
                        DispatchQueue.main.async {
                            self.heartButton.tintColor = UIColor(hex: "#2577FE")
                                        }
                    self.isHeart = true
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
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.deleteHeart(token: token, boardID: boardId) { result in
                switch result {
                case .success:
                        DispatchQueue.main.async {
                            self.heartButton.tintColor = UIColor(hex: "#D1D1D2")
                                        }
                    self.isHeart = false
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
        tagLabel.text = data.tag
        dateLabel.text = data.getDateString()
        timeLabel.text = data.getTimeString()
        viewCountLabel.text = "조회 \(data.count)"
        contentLabel.text = data.contents
        heartCountLabel.text = String(data.heart)
        heartButton.tintColor = data.isHeart ? UIColor(hex: "#2577FE") : UIColor(hex: "#D1D1D2")
    }
    
    @objc
        func popToMainViewController() {
            self.navigationController?.popViewController(animated: true)
        }
    
    @objc func heartButtonTapped(_ sender: UIButton) {
            guard let postId = postId else { return }
        if isHeart {
            deleteHeart(boardId: postId)
        }
        else {    saveHeart(boardId: postId)
        }
        }
}

extension DetailBoardViewController: UITableViewDelegate, UITableViewDataSource {
    private func setDelegate() {
        commentTableView.delegate = self
        commentTableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredComments?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: commentTableViewCell.identifier, for: indexPath) as? commentTableViewCell else {
            return UITableViewCell()
        }
        
        let post: CommentData
        if indexPath.row < filteredComments.count {
            post = filteredComments[indexPath.row]
        } else {
            post = Comments[indexPath.row]
        }
        
        cell.configureCell(post)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
}
