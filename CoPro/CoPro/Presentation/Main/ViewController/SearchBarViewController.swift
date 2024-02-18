//
//  SearchBarViewController.swift
//  CoPro
//
//  Created by 문인호 on 1/2/24.
//

import UIKit

import SnapKit
import Then

final class SearchBarViewController: UIViewController, UISearchControllerDelegate {
    
    // MARK: - UI Components
//    private let searchController = UISearchController(searchResultsController: nil)
    private let customView = UIView()
    private let backButton = UIButton()
    private let searchBar = UISearchBar()
    private let popularSearchScrollView = UIScrollView()
    private let popularSearchStackView = UIStackView()
    private let popularSearchButtonStackView = UIStackView()
    private let popularLabel = UILabel()
    private let recentSearchLabel = UILabel()
    private let recentSearchDeleteButton = UIButton()
    private let recentSearchStackView = UIStackView()
    private lazy var recentSearchTableView = UITableView()
    var items: [String] = ["title", "나는", "문인호임룰루","안녕", "나는", "문인호","안녕", "나는", "문인호","안녕", "나는", "문인호","안녕"]
    var items1: [String] = []

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedItems = UserDefaults.standard.array(forKey: "recentSearches") as? [String] {
                items1 = savedItems
            }
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
            $0.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
            $0.showsCancelButton = false
            $0.placeholder = "검색"
            if let textField = $0.value(forKey: "searchField") as? UITextField {
                textField.returnKeyType = .search
            }
            $0.becomeFirstResponder()
            $0.sizeToFit()
        }
        popularSearchScrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        popularSearchStackView.do {
            $0.axis = .vertical
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.distribution = .equalSpacing
            $0.spacing = 10
        }
        popularSearchButtonStackView.do {
            $0.axis = .horizontal
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .equalSpacing
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
            $0.font = .pretendard(size: 17, weight: .bold)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        recentSearchLabel.do {
            $0.text = "최근 검색"
            $0.font = .pretendard(size: 17, weight: .bold)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        recentSearchDeleteButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle("전체 삭제", for: .normal)
            $0.titleLabel?.font = .pretendard(size: 15, weight: .regular)
            $0.setTitleColor(.G3(), for: .normal)
        }
        recentSearchStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalCentering
            $0.alignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        popularSearchScrollView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setLayout() {
        popularSearchStackView.addArrangedSubviews(popularLabel, popularSearchScrollView)
        recentSearchStackView.addArrangedSubviews(recentSearchLabel, recentSearchDeleteButton)
        view.addSubviews(popularSearchStackView, recentSearchStackView, recentSearchTableView)
        
            popularLabel.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
            }
            popularSearchScrollView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(41)
            }
        popularSearchScrollView.addSubview(popularSearchButtonStackView)
        popularSearchButtonStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        for item in self.items {
            let button = UIButton()
            button.setTitle(item, for: .normal)
            button.titleLabel?.font = .pretendard(size: 17, weight: .regular)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = UIColor.G1().cgColor
            button.layer.borderWidth = 0.5
            button.layer.cornerRadius = 10
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            button.addTarget(self, action: #selector(keywordButtonTapped(_:)), for: .touchUpInside)
            popularSearchButtonStackView.addArrangedSubview(button)
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
    
    // 검색어를 UserDefaults에 저장하는 함수
    func saveSearchKeyword(keyword: String) {
        let defaults = UserDefaults.standard
        var searches: [String] = defaults.array(forKey: "recentSearches") as? [String] ?? []
        searches.append(keyword)
        defaults.set(searches, forKey: "recentSearches")
    }

    // UserDefaults에서 검색어를 불러오는 함수
    func loadSearchKeywords() -> [String] {
        let defaults = UserDefaults.standard
        let searches: [String] = defaults.array(forKey: "recentSearches") as? [String] ?? []
        return searches
    }
    
    // 모든 검색어를 UserDefaults에서 삭제하는 함수
    func deleteAllSearchKeywords() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "recentSearches")
    }

    // 특정 검색어를 UserDefaults에서 삭제하는 함수
    func deleteSearchKeyword(keyword: String) {
        let defaults = UserDefaults.standard
        var searches: [String] = defaults.array(forKey: "recentSearches") as? [String] ?? []
        if let index = searches.firstIndex(of: keyword) {
            searches.remove(at: index)
            defaults.set(searches, forKey: "recentSearches")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return items1.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recentSearchTableViewCell.id, for: indexPath) as! recentSearchTableViewCell
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        // items 배열의 데이터를 셀에 표시합니다.
        cell.prepare(text: items1[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 41
    }

    // MARK: - @objc Method
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview as? UITableViewCell,
              let indexPath = recentSearchTableView.indexPath(for: cell) else { return }

        if var savedItems = UserDefaults.standard.array(forKey: "recentSearches") as? [String] {
            // 해당 항목을 삭제합니다.
            savedItems.remove(at: indexPath.row)
            
            // 변경된 데이터를 다시 UserDefaults에 저장합니다.
            UserDefaults.standard.set(savedItems, forKey: "recentSearches")
        }
        
        // 테이블 뷰에서 해당 셀을 삭제합니다.
        recentSearchTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    @objc func keywordButtonTapped(_ sender: UIButton) {
        // 버튼의 타이틀을 가져와서 검색 바의 텍스트로 설정
        guard let query = sender.titleLabel?.text else { return }
        searchBar.text = query        // 검색 수행
        let searchResultVC = SearchResultViewController()
        searchResultVC.searchText = query
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
    @objc func backButtonTapped() {
            
            if self.navigationController == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
}

extension SearchBarViewController {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // 검색 버튼을 눌렀을 때의 동작을 정의합니다.
        saveSearchKeyword(keyword: searchBar.text!)
        let query = searchBar.text!
        let searchResultVC = SearchResultViewController()
        searchResultVC.searchText = query
        self.navigationController?.pushViewController(searchResultVC, animated: true)
        
            // 키보드를 내립니다.
            searchBar.resignFirstResponder()
        }
}

extension SearchBarViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.isEmpty {
            onSearchTextCleared()
        }
        return true
    }
    
    func onSearchTextCleared() {
        // UserDefaults에서 데이터를 다시 불러와서 테이블뷰를 갱신합니다.
        if let savedItems = UserDefaults.standard.array(forKey: "recentSearches") as? [String] {
            items = savedItems
            recentSearchTableView.reloadData()
        }
    }
}

extension SearchBarViewController: RecentSearchTableViewCellDelegate {
    func recentSearchTableViewCellDidRequestDelete(_ cell: recentSearchTableViewCell) {
        guard let indexPath = recentSearchTableView.indexPath(for: cell) else { return }
        // UserDefaults에서 데이터를 가져옵니다.
        var recentSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] ?? []
        
        // recentSearches에서 해당 데이터를 삭제합니다.
        recentSearches.remove(at: indexPath.row)
        
        // 수정된 recentSearches를 다시 UserDefaults에 저장합니다.
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
        
        // 테이블 뷰에서 해당 셀을 삭제합니다.
        recentSearchTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? recentSearchTableViewCell {
            let query = cell.getSearchLabelText()
            let searchResultVC = SearchResultViewController()
            searchResultVC.searchText = query
            self.navigationController?.pushViewController(searchResultVC, animated: true)
            }
    }

}
