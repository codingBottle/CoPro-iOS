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
//        setAddTarget()
    }
}

extension recruitViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Components Property
    private func setUI() {
        self.view.backgroundColor = .white
        sortButton.do {
            $0.titleLabel?.text = "최신순"
        }
        tableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .singleLine
        }
    }
    
    private func setLayout() {
        view.addSubviews(sortButton,tableView)
        
        sortButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    private func setAddTarget() {
//        sortButton.addTarget(self, action: #selector(sortButtonPressed()), for: .touchUpInside)
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: noticeBoardTableViewCell.identifier, for: indexPath) as? noticeBoardTableViewCell else { return UITableViewCell() }

                cell.configureCell(dummy[indexPath.row])
                
                return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    // MARK: - @objc Method
//    @objc func sortButtonPressed() {
//        let bottomSheetVC = SortingViewController()
//        present(bottomSheetVC, animated: true, completion: nil)
//    }
    @objc func showSortActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: "Select Sort Type", preferredStyle: .actionSheet)
        
        let sortType1Action = UIAlertAction(title: "Sort Type 1", style: .default) { _ in
            // Sort Type 1 선택시 처리 로직
        }
        let sortType2Action = UIAlertAction(title: "Sort Type 2", style: .default) { _ in
            // Sort Type 2 선택시 처리 로직
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(sortType1Action)
        actionSheet.addAction(sortType2Action)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

