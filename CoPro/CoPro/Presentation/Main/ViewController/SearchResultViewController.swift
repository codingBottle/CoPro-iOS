//
//  SearchResultViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/15/24.
//

import UIKit

import SnapKit
import Then
import KeychainSwift

class SearchResultViewController: UIViewController {
    
    // MARK: - UI Components
    
    var searchText: String?
    weak var delegate: RecruitVCDelegate?
    private lazy var tableView = UITableView()
    private let keychain = KeychainSwift()
    private var filteredPosts: [BoardDataModel]!
    var posts = [BoardDataModel]()
    var isInfiniteScroll = true
    var offset = 1
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBoard(search: searchText ?? "", page: offset, standard: "create_at")
        setUI()
        setDelegate()
        setRegister()
        setAddTarget()
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Components Property
    private func setUI() {
        self.view.backgroundColor = UIColor.systemBackground
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
        view.addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setNoDataLayout() {
        let messageLabel = UILabel().then {
            $0.setPretendardFont(text: "검색 결과가 없습니다.", size: 17, weight: .regular, letterSpacing: 1.25)
            $0.textColor = .black
            $0.textAlignment = .center
        }
        let messageLabel2 = UILabel().then {
            $0.setPretendardFont(text: "검색어를 수정해보세요.", size: 17, weight: .regular, letterSpacing: 1.25)
            $0.textColor = .black
            $0.textAlignment = .center
        }
        
        let imageView = UIImageView(image: UIImage(named: "card_coproLogo")) // 이미지 생성
        imageView.contentMode = .center // 이미지가 중앙에 위치하도록 설정
        
        let stackView = UIStackView(arrangedSubviews: [imageView, messageLabel,messageLabel2]) // 이미지와 라벨을 포함하는 스택 뷰 생성
        stackView.axis = .vertical // 세로 방향으로 정렬
        stackView.alignment = .center // 가운데 정렬
        stackView.spacing = 10 // 이미지와 라벨 사이의 간격 설정
        view.addSubview(stackView) // 스택 뷰를 배경 뷰에 추가
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview() // 스택 뷰의 가로 중앙 정렬
            $0.centerY.equalToSuperview() // 스택 뷰의 세로 중앙 정렬
        }
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setAddTarget() {
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
            let detailVC = DetailBoardViewController()
            detailVC.postId = filteredPosts[indexPath.row].boardId
            print("hello")
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
}
extension SearchResultViewController {
    func searchBoard(search: String, page: Int, standard: String) {
        if let token = self.keychain.get("accessToken") {
            print("\(token)")
            BoardAPI.shared.searchBoard(token: token, query: search, page: page, standard: standard) { result in
                switch result {
                case .success(let data):
                    if let data = data as? BoardDTO {
                        let serverData = data.data.boards
                        var mappedData: [BoardDataModel] = []
                        if data.data.pageInfo.totalElements == 0 {
                            self.setNoDataLayout()
                        }
                        else {
                            self.setLayout()
                        }
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
                    searchBoard(search: searchText ?? "", page: offset, standard: "create_at")
                }
            }
        }
}
