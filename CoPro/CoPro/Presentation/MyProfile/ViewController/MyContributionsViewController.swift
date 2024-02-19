//
//  WritebyMeViewController.swift
//  CoPro
//
//  Created by 박신영 on 2/1/24.
//

import UIKit
import SnapKit
import Then
import KeychainSwift

class MyContributionsViewController: BaseViewController {
    
    enum CellType {
        case post
        case comment
        case scrap
    }
    
    var activeCellType: CellType = .post
    // 처음에 post 타입으로 설정해두자. 왜냐 초기값 설정 안해, nil 값일 경우도 고려하는 것이 더 코드가 복잡해 지기 때문.
    
    private let keychain = KeychainSwift()
    private var myPostsData: [WritebyMeDataModel]?
    private var myCommentData: [MyWrittenCommentDataModel]?
    private var scrapPostData: [ScrapPostDataModel]?
    
    private lazy var tableView = UITableView().then({
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .singleLine
       $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.register(RelatedPostsToMeTableViewCell.self,
                    forCellReuseIdentifier:"RelatedPostsToMeTableViewCell")
        $0.register(MyCommentsTableViewCell.self,
                    forCellReuseIdentifier:"MyCommentsTableViewCell")
    })
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = .white
       // MARK: NavigationBar Custom Settings
               let attributes: [NSAttributedString.Key: Any] = [
                   .font: UIFont(name: "Pretendard-Regular", size: 17)!, // Pretendard 폰트 적용
                   .kern: 1.25, // 자간 조절
                   .foregroundColor: UIColor.black // 폰트 색상
               ]
               self.navigationController?.navigationBar.titleTextAttributes = attributes
               self.navigationItem.title = "관심 프로필"
               
               self.navigationController?.setNavigationBarHidden(false, animated: true)
               
               self.navigationController?.navigationBar.tintColor = UIColor.Black()
               let backButton = UIButton(type: .custom)
               guard let originalImage = UIImage(systemName: "chevron.left") else {
                   return
               }
               let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24) // 이미지 크기 설정
               let boldImage = originalImage.withConfiguration(symbolConfiguration)
               
               backButton.setImage(boldImage, for: .normal)
               backButton.contentMode = .scaleAspectFit
               backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // 버튼의 크기설정
               backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
               
               let backBarButtonItem = UIBarButtonItem(customView: backButton)
               self.navigationItem.leftBarButtonItem = backBarButtonItem
               
               let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
               spacer.width = 8 // 왼쪽 여백의 크기
               self.navigationItem.leftBarButtonItems?.insert(spacer, at: 0) // 왼쪽 여백 추가
        
        switch activeCellType {
        case .post:
            self.navigationItem.title = "작성한 게시물"
            getWriteByMe()
        case .comment:
            self.navigationItem.title = "작성한 댓글"
            getMyWrittenComment()
            
        case .scrap:
            self.navigationItem.title = "저장한 게시물"
            getScrapPost()
        }
        
        setDelegate()
    }
        
    // Navigation Controller
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func setLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func returnTableCellHeight() -> CGFloat {
        switch activeCellType {
        case .post, .scrap:
            let screenHeight = UIScreen.main.bounds.height
            let heightRatio = 88.0 / 852.0
            let cellHeight = screenHeight * heightRatio
            return cellHeight
        case .comment:
            let screenHeight = UIScreen.main.bounds.height
            let heightRatio = 62.0 / 852.0
            let cellHeight = screenHeight * heightRatio
            return cellHeight
        }
    }
    
    private func getWriteByMe() {
        if let token = self.keychain.get("accessToken") {
            MyProfileAPI.shared.getWritebyMe(token: token) { result in
                switch result {
                case .success(let data):
                    if let data = data as? WritebyMeDTO {
                        self.myPostsData = data.data.boards.map {
                            return WritebyMeDataModel(id: $0.id, title: $0.title, nickName: $0.nickName, createAt: $0.createAt, count: $0.count, heart: $0.heart, imageURL: $0.imageURL, commentCount: $0.commentCount)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Failed to decode the response.")
                    }
                    
                case .requestErr(let message):
                   print("Error : \(message)")
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(_):
                           DispatchQueue.main.async {
                              self.getWriteByMe()
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
                case .pathErr, .serverErr, .networkFail:
                    print("another Error")
                default:
                    break
                }
                
            }
        }
    }
    
    private func getMyWrittenComment() {
        if let token = self.keychain.get("accessToken") {
            MyProfileAPI.shared.getMyWrittenComment(token: token) { result in
                switch result {
                case .success(let data):
                    if let data = data as? MyWrittenCommentDTO {
                        self.myCommentData = data.data.content.map {
                            return MyWrittenCommentDataModel(
                                parentID: $0.parentID,
                                commentID: $0.commentID,
                                content: $0.content,
                                createAt: $0.createAt,
                                writer: MyWrittenCommentDataModelWriter(from: $0.writer) // 수정된 부분
                            )
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Failed to decode the response.")
                    }
                    
                case .requestErr(let message):
                   print("Error : \(message)")
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(_):
                           DispatchQueue.main.async {
                              self.getMyWrittenComment()
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
                case .pathErr, .serverErr, .networkFail:
                    print("another Error")
                default:
                    break
                }
                
            }
        }
    }
    
    private func getScrapPost() {
        if let token = self.keychain.get("accessToken") {
            MyProfileAPI.shared.getScrapPost(token: token) { result in
                switch result {
                case .success(let data):
                    if let data = data as? ScrapPostDTO {
                        self.scrapPostData = data.data.content.map {
                            return ScrapPostDataModel(boardID: $0.boardID, title: $0.title, count: $0.count, createAt: $0.createAt, heart: $0.heart, imageURL: $0.imageURL, nickName: $0.nickName, commentCount: $0.commentCount)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Failed to decode the response.")
                    }
                    
                case .requestErr(let message):
                   print("Error : \(message)")
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(_):
                           DispatchQueue.main.async {
                              self.getScrapPost()
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
                case .pathErr, .serverErr, .networkFail:
                    print("another Error")
                default:
                    break
                }
                
            }
        }
    }
}

extension MyContributionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch activeCellType {
        case .post:
            return myPostsData?.count ?? 0
            
        case .comment:
            return myCommentData?.count ?? 0
            
        case .scrap:
            return scrapPostData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch activeCellType {
        case .post:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedPostsToMeTableViewCell", for: indexPath) as? RelatedPostsToMeTableViewCell
            else {
                return UITableViewCell()
            }
            print("post입장")
            let reverseIndex = (myPostsData?.count ?? 0) - 1 - indexPath.row
            let post = myPostsData?[reverseIndex]
            cell.configureCellWritebyMe(post!)
            cell.selectionStyle = .none
            return cell
            
        case .scrap:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedPostsToMeTableViewCell", for: indexPath) as? RelatedPostsToMeTableViewCell
            else {
                return UITableViewCell()
            }
            print("scrap입장")
            let reverseIndex = (scrapPostData?.count ?? 0) - 1 - indexPath.row
            let scrapPost = scrapPostData?[reverseIndex]
            cell.configureCellScrapPost(scrapPost!)
            cell.selectionStyle = .none
            return cell
            
        case .comment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommentsTableViewCell", for: indexPath) as? MyCommentsTableViewCell
            else {
                return UITableViewCell()
            }
            let reverseIndex = (myCommentData?.count ?? 0) - 1 - indexPath.row
            let comment = myCommentData?[reverseIndex]
            cell.configureCellWriteCommentbyMe(comment!)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return returnTableCellHeight()
    }
   
   @objc func backButtonTapped() {
               
               if self.navigationController == nil {
                   self.dismiss(animated: true, completion: nil)
               } else {
                   self.navigationController?.popViewController(animated: true)
               }
           }
}
