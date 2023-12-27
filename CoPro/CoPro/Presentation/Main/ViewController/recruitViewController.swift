//
//  recruitViewController.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import UIKit

import SnapKit
import Then

final class recruitViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let sortButton = UIButton()
    private lazy var tableView = UITableView()
    private let dummy = noticeBoardDataModel.dummy()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableView.dataSource = self  // 추가: tableView의 dataSource를 설정
    }
    
    private func setAddTarget() {
        sortButton.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: noticeBoardTableViewCell.identifier, for: indexPath) as? noticeBoardTableViewCell else { return UITableViewCell() }

                cell.configureCell(dummy[indexPath.row])
                
                return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // MARK: - @objc Method
    
    @objc func sortButtonPressed() {
        let bottomSheetVC = SortBottomSheetViewController()
        present(bottomSheetVC, animated: true, completion: nil)
    }

}

