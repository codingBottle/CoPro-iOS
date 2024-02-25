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

final class recruitViewController: UIViewController, SendStringData, AddPostViewControllerDelegate {
    func didPostArticle() {
        offset = 1
        posts.removeAll()
        filteredPosts.removeAll()
        getAllBoard(category: "프로젝트", page: offset, standard: getStandard())
    }
    
    func radioButtonDidSelect() {
        print("라디오버튼눌림")
    }
    
    func sendData(mydata: String, groupId: Int) {
        sortButton.setTitle(mydata, for: .normal)
        offset = 1
        posts.removeAll()
        filteredPosts.removeAll()
        getAllBoard(category: "프로젝트", page: offset, standard: getStandard())
    }
    
    
    // MARK: - UI Components
    
    private let refreshControl = UIRefreshControl()
    weak var delegate1: radioDelegate?
    weak var delegate: RecruitVCDelegate?
    private let sortButton = UIButton()
    private lazy var tableView = UITableView()
    private let keychain = KeychainSwift()
    private var filteredPosts: [BoardDataModel]!
    var posts = [BoardDataModel]()
    var isInfiniteScroll = true
    var offset = 1
    private lazy var addPostButton: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 91, height: 37))
        btn.backgroundColor = UIColor.P2()
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.titleLabel?.font = .pretendard(size: 17, weight: .bold)
        btn.setTitle("글쓰기", for: .normal)
        btn.contentEdgeInsets = .init(top: 0, left: 1, bottom: 0, right: 1)
        btn.imageEdgeInsets = .init(top: 0, left: -1, bottom: 0, right: 1)
        btn.titleEdgeInsets = .init(top: 0, left: 1, bottom: 0, right: -1)
        btn.clipsToBounds = true
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)

        return btn
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllBoard(category: "프로젝트", page: offset, standard: "create_at")
        setUI()
        setLayout()
        setDelegate()
        setRegister()
        setAddTarget()
        view.bringSubviewToFront(addPostButton)
    }
}

extension recruitViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Components Property
    private func setUI() {
        self.view.backgroundColor = UIColor.systemBackground
        sortButton.do {
            $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            $0.setTitle("최신순", for: .normal)
            $0.titleLabel?.font = .pretendard(size: 15, weight: .regular)
            let buttonTitleColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
            }
            $0.setTitleColor(buttonTitleColor, for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft  // 오른쪽에서 왼쪽으로 컨텐츠를 정렬
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        }
        tableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .singleLine
            $0.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
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
        view.addSubview(addPostButton)
        addPostButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-91)
            $0.width.equalTo(91)
            $0.height.equalTo(37)
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
        detailVC.delegate = self
        if indexPath.row < filteredPosts.count {
            print(filteredPosts[indexPath.row].title)
            print("\(filteredPosts[indexPath.row].boardId)")
            detailVC.postId = filteredPosts[indexPath.row].boardId
            let navigationController = UINavigationController(rootViewController: detailVC)
            navigationController.modalPresentationStyle = .overFullScreen
            self.present(navigationController, animated: true, completion: nil)
        } else {
            print("Invalid index")
            detailVC.postId = posts[indexPath.row].boardId
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    // MARK: - @objc Method
    
    @objc func addButtonDidTapped() {
        let addPostVC = AddProjectPostViewController()
        addPostVC.delegate = self
        let navigationController = UINavigationController(rootViewController: addPostVC)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
    }

    
    @objc func sortButtonPressed() {
        let bottomSheetVC = SortBottomSheetViewController()
        bottomSheetVC.delegate = self
        bottomSheetVC.tmp = sortButton.titleLabel?.text ?? "최신순"
            present(bottomSheetVC, animated: true, completion: nil)
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        // 데이터를 새로고침하는 코드를 여기에 작성합니다.
        offset = 1
        
        // 게시글들 모두 제거
        posts.removeAll()
        filteredPosts.removeAll()
        
        // 새로운 게시글들 가져오기
        getAllBoard(category: "프로젝트", page: offset, standard: getStandard())
        // 데이터를 새로고침 한 후에는 반드시 endRefreshing() 메소드를 호출하여 새로고침 인디케이터를 숨겨야 합니다.
        sender.endRefreshing()
    }

}
extension recruitViewController {
    func getAllBoard(category: String, page: Int, standard: String) {
        if let token = self.keychain.get("accessToken") {
            print("\(token)")
            BoardAPI.shared.getAllBoard(token: token , category: category, page: page, standard: standard) { result in
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
                    getAllBoard(category: "프로젝트", page: offset, standard: getStandard())
                }
            }
        }
    
    func getStandard() -> String {
        switch sortButton.title(for: .normal) {
        case "최신순":
            return "create_at"
        case "인기순":
            return "count"
        default:
            return "create_at" // 기본값
        }
    }
}

extension recruitViewController: DetailViewControllerDelegate {
    func didDeletePost() {
        print("😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛")
        offset = 1
        posts.removeAll()
        filteredPosts.removeAll()
        getAllBoard(category: "프로젝트", page: offset, standard: getStandard())
       }
}
