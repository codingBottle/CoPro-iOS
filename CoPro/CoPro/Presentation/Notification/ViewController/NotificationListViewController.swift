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
                print("알림 데이터 \(data.data.content)")
                if self?.contents.count == 0 {
                    // contents가 비어있을 때 메시지 라벨을 추가합니다.
                    let messageLabel = UILabel().then {
                        $0.setPretendardFont(text: "새로운 소식이 도착할 때까지 기다려주세요!", size: 17, weight: .bold, letterSpacing: 1.15)
                        $0.textColor = .black
                        $0.textAlignment = .center
                    }
                    
                    let imageView = UIImageView(image: UIImage(named: "card_coproLogo")) // 이미지 생성
                    imageView.contentMode = .center // 이미지가 중앙에 위치하도록 설정
                    
                    let stackView = UIStackView(arrangedSubviews: [imageView, messageLabel]) // 이미지와 라벨을 포함하는 스택 뷰 생성
                    stackView.axis = .vertical // 세로 방향으로 정렬
                    stackView.alignment = .center // 가운데 정렬
                    stackView.spacing = 15 // 이미지와 라벨 사이의 간격 설정
                    
                    self?.tableView.backgroundView = UIView() // 배경 뷰 생성
                    
                    if let backgroundView = self?.tableView.backgroundView {
                        backgroundView.addSubview(stackView) // 스택 뷰를 배경 뷰에 추가
                        
                        stackView.snp.makeConstraints {
                            $0.centerX.equalTo(backgroundView) // 스택 뷰의 가로 중앙 정렬
                            $0.centerY.equalTo(backgroundView) // 스택 뷰의 세로 중앙 정렬
                        }
                    }
                } else {
                    // contents가 비어있지 않을 때 메시지 라벨을 제거합니다.
                    self?.tableView.backgroundView = nil
                }
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
        // 현재 화면의 높이를 가져옴
        let screenHeight = UIScreen.main.bounds.height
        
        // 행의 높이를 화면 높이의 10분의 1 크기로 설정
        let rowHeight = screenHeight / 10.0
        
        return rowHeight
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
            navigationController?.pushViewController(detailVC, animated: true)
        }else{
            print("BoardId 없음")
        }
        
    }
    
}
