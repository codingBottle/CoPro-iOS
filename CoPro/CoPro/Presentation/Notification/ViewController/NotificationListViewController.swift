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
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .clear
        $0.register(NotificationListCell.self, forCellReuseIdentifier: "NotificationListCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 테이블 뷰 델리게이트 및 데이터 소스 설정
        tableView.delegate = self
        tableView.dataSource = self
        getNotificationListData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotificationListData()
    }
    var contents: [NotificationListDataContent] = []
    func getNotificationListData() {
        NotificationListAPI.shared.getNotificationListData { [weak self] result in
            switch result {
            case .success(let data):
                self?.contents.append(contentsOf: data.data.content)
                print(data.data.content)
                print(self?.contents.count)
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
        return 50.0 // 적절한 높이로 수정
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 셀 하단에 구분선 추가
        let separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cell.separatorInset = separatorInset
    }
    
}
