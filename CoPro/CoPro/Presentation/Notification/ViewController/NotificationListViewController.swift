//
//  NotificationListViewController.swift
//  CoPro
//
//  Created by 박현렬 on 2/22/24.
//

import UIKit
import SnapKit
import Then

class NotificationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentPage = 0
    var scrollLast = false
    private let tableView = UITableView().then {
        $0.separatorStyle = .singleLine
        $0.backgroundColor = UIColor.White()
        $0.register(NotificationListCell.self, forCellReuseIdentifier: "NotificationListCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.White()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 테이블 뷰 델리게이트 및 데이터 소스 설정
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.White()
        currentPage = 0
        contents.removeAll()
        getNotificationListData(page: currentPage)
        
    }
    var contents: [NotificationListDataContent] = []
    func getNotificationListData(page: Int) {
        NotificationListAPI.shared.getNotificationListData(page: currentPage) { [weak self] result in
            switch result {
            case .success(let data):
                self?.contents.append(contentsOf: data.data.content)
                print(data.data.content)
                print(self?.contents.count)
                self?.scrollLast = data.data.last
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationListCell", for: indexPath) as? NotificationListCell else {
            return UITableViewCell()
        }
        // 배열이 비어있는지 체크
        if indexPath.row < contents.count {
            cell.titleLabel.text = self.contents[indexPath.row].message
            
            if let dateString = self.contents[indexPath.row].createAt {
                // 널이 아닌 경우에만 실행
                
                let prefixIndex = dateString.index(dateString.startIndex, offsetBy: 5)
                let suffixIndex = dateString.index(dateString.startIndex, offsetBy: 16)
                
                let formattedString = String(dateString[prefixIndex..<suffixIndex]).replacingOccurrences(of: "T", with: " ")
                
                // 변환된 문자열 사용
                print("Time Label \(formattedString)")
                cell.timeLabel.text = formattedString
            } else {
                // 널인 경우에 대한 처리
                print("createAt is nil")
                cell.timeLabel.text = self.contents[indexPath.row].createAt
            }
        } else {
            cell.titleLabel.text = "No Data"
        }
        if self.contents[indexPath.row].message.contains("좋아") {
                    cell.iconImageView.image = UIImage(systemName: "heart") // 좋아하는 경우의 아이콘
        } else if self.contents[indexPath.row].message.contains("댓글") {
                    cell.iconImageView.image = UIImage(systemName: "text.bubble") // 댓글인 경우의 아이콘
                } else {
                    // 기본 아이콘 또는 다른 처리
                    cell.iconImageView.image = UIImage(systemName: "bell")
                }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 각 셀의 높이를 지정해줌
        return 60.0 // 적절한 높이로 수정
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 셀 하단에 구분선 추가
        let separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cell.separatorInset = separatorInset
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        // 스크롤이 끝에 도달하면 추가 데이터 로드
        if self.scrollLast != true && offsetY > contentHeight - scrollViewHeight {
            currentPage += 1
            getNotificationListData(page: currentPage)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택된 셀의 인덱스 패스: \(indexPath.row)")
        if contents[indexPath.row].boardID != nil {
            print("BoardId 있음")
            let detailVC = DetailBoardViewController()
            detailVC.postId = contents[indexPath.row].boardID
            let navigationController = UINavigationController(rootViewController: detailVC)
            navigationController.modalPresentationStyle = .overFullScreen
            self.present(navigationController, animated: true, completion: nil)
        }else{
            print("BoardId 없음")
        }
        
    }
    
}
