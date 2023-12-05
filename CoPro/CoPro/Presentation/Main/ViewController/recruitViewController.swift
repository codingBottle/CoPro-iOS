//
//  recruitViewController.swift
//  CoPro
//
//  Created by 문인호 on 11/24/23.
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
            $0.setTitle("최신순", for: .normal)
            $0.setTitleColor(.black, for: .normal)
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
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(20)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom)
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
        
    }

}

