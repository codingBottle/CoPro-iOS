//
//  recruitViewController.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import UIKit

import SnapKit
import Then
import KeychainSwift

protocol RecruitVCDelegate: AnyObject {
    func didSelectItem(withId id: Int)
}
protocol radioDelegate: AnyObject {
    func sendDefaultSelect(withOpt opt: String)
}

final class recruitViewController: UIViewController, SendStringData {
    func radioButtonDidSelect() {
        print("라디오버튼눌림")
    }
    
    func sendData(mydata: String, groupId: Int) {
        sortButton.setTitle(mydata, for: .normal)
        
    }
    
    
    // MARK: - UI Components
    
    weak var delegate1: radioDelegate?
    weak var delegate: RecruitVCDelegate?
    private let sortButton = UIButton()
    private lazy var tableView = UITableView()
    private let keychain = KeychainSwift()
    private var filteredPosts: [BoardDataModel]!
    var posts = [BoardDataModel]()
    var isInfiniteScroll = true
    var offset = 1
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllBoard(category: "공지사항", page: 1)
        setUI()
        setLayout()
        setDelegate()
        setRegister()
        setAddTarget()
    }
}

extension recruitViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Components Property
    private func setUI() {
        self.view.backgroundColor = .white
        sortButton.do {
            $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            $0.setTitle("최신순", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.setTitleColor(.black, for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft  // 오른쪽에서 왼쪽으로 컨텐츠를 정렬
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        }
        tableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .singleLine
        }
    }
    
    private func setRegister() {
        tableView.register(noticeBoardTableViewCell.self,
                           forCellReuseIdentifier:"noticeBoardTableViewCell")
    }
    
    private func setLayout() {
        view.addSubviews(sortButton,tableView)
        
        sortButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(25)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(5)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setAddTarget() {
        sortButton.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPosts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: noticeBoardTableViewCell.identifier, for: indexPath) as? noticeBoardTableViewCell else {
            return UITableViewCell()
        }
        
        let post: BoardDataModel
        if indexPath.row < filteredPosts.count {
            post = filteredPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }
        
        cell.configureCell(post)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailBoardViewController()
        if indexPath.row < filteredPosts.count {
            print(filteredPosts[indexPath.row].title)
            print("\(filteredPosts[indexPath.row].boardId)")
            detailVC.postId = filteredPosts[indexPath.row].boardId
            delegate?.didSelectItem(withId: detailVC.postId!)
        } else {
            print("Invalid index")
            detailVC.postId = posts[indexPath.row].boardId
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    // MARK: - @objc Method
    
    @objc func sortButtonPressed() {
        let bottomSheetVC = SortBottomSheetViewController()
        delegate1?.sendDefaultSelect(withOpt: sortButton.titleLabel?.text ?? "최신순")
            bottomSheetVC.prepareForDisplay()
            present(bottomSheetVC, animated: true, completion: nil)
    }
}
extension recruitViewController {
    func getAllBoard(category: String, page: Int) {
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.getAllBoard(token: token , category: category, page: page, standard: "create_at") { result in
                switch result {
                case .success(let data):
                    if let data = data as? BoardDTO {
                        let serverData = data.data.boards
                        var mappedData: [BoardDataModel] = []
                        
                        for serverItem in serverData {
                            let mappedItem = BoardDataModel (boardId: serverItem.id,title: serverItem.title ?? "", nickName: serverItem.nickName ?? "no_name", createAt: serverItem.createAt ?? "", heartCount: serverItem.heart, viewsCount: serverItem.count, imageUrl: serverItem.imageURL ?? "", commentCount: serverItem.commentCount)
                            mappedData.append(mappedItem)
                        }
                        
                        // 매핑된 데이터를 배열에 저장
                        self.posts.append(contentsOf: mappedData)
                        self.filteredPosts = self.posts
                        
                        // 테이블 뷰 업데이트
                        self.tableView.reloadData()
                        self.isInfiniteScroll = data.data.pageInfo.hasNext
                    } else {
                        print("Failed to decode the response.")
                    }
                case .requestErr(let message):
                    // Handle request error here.
                    print("Request error: \(message)")
                case .pathErr:
                    // Handle path error here.
                    print("Path error")
                case .serverErr:
                    // Handle server error here.
                    print("Server error")
                case .networkFail:
                    // Handle network failure here.
                    print("Network failure")
                default:
                    break
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
                if isInfiniteScroll {
                    isInfiniteScroll = false
                    offset += 1
                    getAllBoard(category: "공지사항", page: offset)
                }
            }
        }
}
