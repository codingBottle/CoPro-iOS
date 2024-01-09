//
//  SearchBarViewController.swift
//  CoPro
//
//  Created by 문인호 on 1/2/24.
//

import UIKit

import SnapKit
import Then

final class SearchBarViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let searchBar = UISearchBar()
    private lazy var popularSearchTableView = UITableView()
    private let popularSearchStackView = UIStackView()
    private let popularLabel = UILabel()
    private let recentSearchLabel = UILabel()
    private let recentSearchDeleteButton = UIButton()
    private let recentSearchStackView = UIStackView()
    private lazy var recentSearchTableView = UITableView()
    var items: [String] = ["안녕", "나는", "문인호","안녕", "나는", "문인호","안녕", "나는", "문인호","안녕", "나는", "문인호","안녕"]


    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setNavigate()
    }
}

extension SearchBarViewController: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Components Property
    private func setUI() {
        
        self.view.backgroundColor = .white
        
        searchBar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = self
            $0.showsCancelButton = false
            $0.placeholder = "검색"
        }
        popularSearchTableView.do {
            $0.showsVerticalScrollIndicator = true
            $0.backgroundColor = .clear
            $0.contentInset = .zero
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.separatorStyle = .none
            $0.bounces = true
            $0.delegate = self
            $0.dataSource = self
            $0.register(popularSearchTableViewCell.self,
                        forCellReuseIdentifier: popularSearchTableViewCell.id)
        }
        popularSearchStackView.do {
            $0.axis = .vertical
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.distribution = .equalCentering
            $0.alignment = .leading
        }
        recentSearchTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.separatorStyle = .none
            $0.delegate = self
            $0.dataSource = self
            $0.register(recentSearchTableViewCell.self,
                        forCellReuseIdentifier: recentSearchTableViewCell.id)
        }
        popularLabel.do {
            $0.text = "인기 검색"
            $0.font = UIFont(name: "Pretendard-Bold", size: 17)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        recentSearchLabel.do {
            $0.text = "최근 검색"
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        recentSearchDeleteButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle("전체 삭제", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
        }
        recentSearchStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalCentering
            $0.alignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setLayout() {
        popularSearchStackView.addArrangedSubviews(popularLabel, popularSearchTableView)
        recentSearchStackView.addArrangedSubviews(recentSearchLabel, recentSearchDeleteButton)
        view.addSubviews(popularSearchStackView, recentSearchStackView, recentSearchTableView)
        
        popularLabel.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
            }
            popularSearchTableView.snp.makeConstraints {
                $0.top.equalTo(popularLabel.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }
            popularSearchStackView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
            recentSearchStackView.snp.makeConstraints {
                $0.top.equalTo(popularSearchStackView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
            recentSearchLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview()
            }
            recentSearchDeleteButton.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            recentSearchTableView.snp.makeConstraints {
                $0.top.equalTo(recentSearchStackView.snp.bottom).offset(16)
                $0.leading.trailing.bottom.equalToSuperview().inset(16)
            }
        
    }
    
    private func setNavigate() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.titleView = searchBar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == popularSearchTableView {
            return 1
        }
            else {
                return items.count
            }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == popularSearchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: popularSearchTableViewCell.id, for: indexPath) as! popularSearchTableViewCell
        cell.prepare(items: items)
        return cell
        }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: recentSearchTableViewCell.id, for: indexPath) as! recentSearchTableViewCell
                cell.prepare(text: items.first)
            return cell
            }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == popularSearchTableView {
            return popularSearchTableViewCell.cellHeight
        }
        else {
            return 41
        }
    }

    // MARK: - @objc Method
    
    @objc func backButtonTapped() {
            
            if self.navigationController == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
}
