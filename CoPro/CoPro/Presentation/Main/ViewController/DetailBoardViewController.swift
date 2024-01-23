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
    private let keychain = KeychainSwift()
    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let jobLabel = UILabel()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let viewLabel = UILabel()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
//        addTarget()
        setNavigate()
        getDetailBoard( boardId: postId!)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        titleLabel.do {
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Medium", size : 22)
        }
        nicknameLabel.do {
            $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        }
        jobLabel.do {
                    $0.textColor = UIColor(red: 0.429, green: 0.432, blue: 0.446, alpha: 1)
                    $0.font = UIFont(name: "Pretendard-Regular", size : 13)
        }
        dateLabel.do {
                    $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
                    $0.font = UIFont(name: "Pretendard-Regular", size : 13)
        }
        timeLabel.do {
                    $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
                    $0.font = UIFont(name: "Pretendard-Regular", size : 13)
        }
        viewLabel.do {
                    $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
                    $0.font = UIFont(name: "Pretendard-Regular", size : 13)
        }
        viewCountLabel.do {
            $0.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.682, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Regular", size : 13)
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
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        }
        contentLabel.do {
            $0.frame = CGRect(x: 0, y: 0, width: 282, height: 50)
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Regular", size: 17)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
        heartButton.do {
                    $0.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        heartCountLabel.do {
            $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            $0.font = UIFont(name: "Pretendard-Regular", size: 17)
        }
        chatButton.do {
            $0.frame = CGRect(x: 0, y: 0, width: 151, height: 41)
            $0.layer.backgroundColor = UIColor(red: 0.145, green: 0.467, blue: 0.996, alpha: 1).cgColor
            $0.layer.cornerRadius = 10
        }
        lineView2.do {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        }
        commentTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .singleLine
        }
    }
    private func setLayout() {
        view.addSubviews(titleLabel,infoStackView,contentLabel,heartButton,heartCountLabel,chatButton,commentTableView)
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
                        let mappedItem = DetailBoardDataModel(boardId: data.data.boardId, title: data.data.title, category: data.data.category, contents: data.data.contents, tag: data.data.tag, count: data.data.count, heart: data.data.heart, imageUrl: data.data.imageUrl, nickName: data.data.nickName, occupation: data.data.occupation, heartMemberIds: data.data.heartMemberIds, scrapMemberIds: data.data.scrapMemberIds, comments: data.data.commentResDtoList)
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
    func updateView(with data: DetailBoardDataModel) {
        titleLabel.text = data.title
        nicknameLabel.text = data.nickName
        jobLabel.text = data.occupation
        let dateString = "01/02"
        dateLabel.text = dateString
        timeLabel.text = "11:02"
        viewCountLabel.text = String(data.count)
        contentLabel.text = data.contents
        heartCountLabel.text = String(data.heart)
    }
    
    @objc
        func popToMainViewController() {
            self.navigationController?.popViewController(animated: true)
        }
}
