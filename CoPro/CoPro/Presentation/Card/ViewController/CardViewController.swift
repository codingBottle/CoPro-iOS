//
//  CardViewController.swift
//  CoPro
//
//  Created by 박현렬 on 11/29/23.
//

import UIKit
import SnapKit
import Then
import DropDown
import Alamofire
import KeychainSwift


class CardViewController: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    //셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contents.count
    }
    //셀 데이터
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if myViewType == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCellView", for: indexPath) as? CardCollectionCellView else {
                return UICollectionViewCell()
            }
            
            // contents 배열이 비어있거나 인덱스가 범위를 벗어나지 않는지 확인
            guard indexPath.item < contents.count else {
                // 유효하지 않은 경우, 빈 데이터로 셀을 구성하거나 다른 처리를 수행
                // 예: cell.configure(with: "", name: "", occupation: "", language: "")
                return cell
            }
            
            // 유효한 경우, 정상적으로 셀을 구성
            cell.configure(with: contents[indexPath.item].picture,
                           name: contents[indexPath.item].name,
                           occupation: contents[indexPath.item].occupation ?? " ",
                           language: contents[indexPath.item].language ?? " ", gitButtonURL:  contents[indexPath.item].gitHubURL ?? " ")
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiniCardGridView", for: indexPath) as? MiniCardGridView else {
            return UICollectionViewCell()
        }
        
        // contents 배열이 비어있거나 인덱스가 범위를 벗어나지 않는지 확인
        guard indexPath.item < contents.count else {
            // 유효하지 않은 경우, 빈 데이터로 셀을 구성하거나 다른 처리를 수행
            // 예: cell.configure(with: "", name: "", occupation: "", language: "")
            return cell
        }
        
        // 유효한 경우, 정상적으로 셀을 구성
        cell.configure(with: contents[indexPath.item].picture,
                       name: contents[indexPath.item].name,
                       occupation: contents[indexPath.item].occupation ?? " ",
                       language: contents[indexPath.item].language ?? " ", gitButtonURL: contents[indexPath.item].gitHubURL ?? " ")
        return cell
    }
    //셀 사이즈 정의
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if myViewType == 0{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else{
            let numberOfItemsInRow: CGFloat = 2
                let spacingBetweenItems: CGFloat = 10
                
                let totalSpacing = (numberOfItemsInRow - 1) * spacingBetweenItems
                let cellWidth = (collectionView.frame.width - totalSpacing) / numberOfItemsInRow
            
            let cellHeight = 272
                
                return CGSize(width: cellWidth, height: 272)
        }
        
    }
    // 셀사이 여백 값 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //셀 스크롤 에니메이션
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //           let center = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.width / 2, y: scrollView.bounds.height / 2)
    //
    //           if let indexPath = collectionView.indexPathForItem(at: center) {
    //               for cell in collectionView.visibleCells {
    //                   guard let indexPathForCell = collectionView.indexPath(for: cell) else { continue }
    //
    //                   let scaleFactor: CGFloat = indexPath == indexPathForCell ? 1.0 : 0.7
    //                   let width = collectionView.frame.width * scaleFactor
    //                   let height = collectionView.frame.height
    //
    //                   UIView.animate(withDuration: 0.5) {
    //                       cell.frame.size = CGSize(width: width, height: height)
    //                   }
    //               }
    //           }
    //       }
    //셀 인덱스
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if myViewType == 0{
            let width = scrollView.frame.width
            let index = Int(scrollView.contentOffset.x / width)
            print("가로 현재 페이지: \(index)")
            
            if last == true {
                print("가로 마지막 페이지")
                return
            }else if index == contents.count - 1 {
                DispatchQueue.main.async {
                    self.loadNextPage()
                    
                }
            }
        }
        else {
            let height =  scrollView.frame.height / 4
            let index = Int(scrollView.contentOffset.y / height)
            print("세로 현재 페이지: \(index)")
            
            if last == true {
                print("세로 마지막 페이지")
                return
            }else if index == contents.count - 4 {
                DispatchQueue.main.async {
                    self.loadNextPage()
                    
                }
            }
        }
    }
    // 다음 페이지의 데이터를 불러오는 메서드
    func loadNextPage() {
        if last {
            print("마지막 페이지")
            return
        }
        
        // 페이지 번호를 증가시키고 데이터를 불러옴
        page += 1
        let part = self.cardView.partLabel.text ?? " "
        let lang = self.cardView.langLabel.text ?? " "
        let old = self.cardView.oldLabel.text ?? " "
        
        self.loadCardDataFromAPI(part: part, lang: lang, old: old,page: page)
        
        print("page value: \(page)")
    }
    
    var myViewType = 0
    var last = false
    var page = 0
    var contents: [Content] = [] // API 데이터를 저장할 배열
    let partDropDown = DropDown()
    let langDropDown = DropDown()
    let oldDropDown = DropDown()
    let cardView = CardView()
    let miniCardView = MiniCard()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func loadView() {
        // View를 생성하고 추가합니다.
        view = cardView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // DropDown 설정
        setupDropDown(dropDown: partDropDown, anchorView: cardView.partContainerView, button: cardView.partButton, items: ["Mobile", "Server", "Web"])
        setupDropDown(dropDown: langDropDown, anchorView: cardView.langContainerView, button: cardView.langButton, items: ["Swift", "Java", "Flutter"])
        setupDropDown(dropDown: oldDropDown, anchorView: cardView.oldContainerView, button: cardView.oldButton, items: ["1 year", "2 years", "3 years"])
        
        setupCollectionView()
        loadCardDataFromAPI(part: " ", lang: " ", old: " ",page: page)
        
        
    }
    //컬렉션뷰 셋업 메소드
    private func setupCollectionView() {
        collectionView.removeFromSuperview()
        if myViewType == 0{
            view.addSubview(collectionView)
            collectionView.snp.makeConstraints {
                $0.edges.equalTo(cardView.scrollView).offset(0)
            }
            
            collectionView.register(CardCollectionCellView.self, forCellWithReuseIdentifier: "CardCollectionCellView")
            collectionView.dataSource = self
            collectionView.delegate = self
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(cardView.scrollView).offset(0)
        }
        
        
        collectionView.register(MiniCardGridView.self, forCellWithReuseIdentifier: "MiniCardGridView")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    //API호출
    func loadCardDataFromAPI(part: String, lang: String, old: String, page: Int) {
        CardAPI.shared.getUserData(part: part, lang: lang, old: old, page: page) { [weak self] result in
                switch result {
                case .success(let cardDTO):
                    

                    DispatchQueue.main.async {
                        self?.contents.append(contentsOf: cardDTO.data.memberResDto.content)
                        self?.last = cardDTO.data.memberResDto.last
                        self?.myViewType = cardDTO.data.myViewType
                        let scrollDirection: UICollectionView.ScrollDirection = (self?.myViewType == 0) ? .horizontal : .vertical

                        if let layout = self?.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                            layout.scrollDirection = scrollDirection
                            self?.collectionView.isPagingEnabled = (scrollDirection == .horizontal)
                        }
                        self?.collectionView.reloadData()
                        print("After reloadData")
                        print("API Success: \(cardDTO.data.memberResDto.content.count)")
                        print("APIDATA : \(String(describing: self?.contents))")
                    }

                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    
    override func setUI() {
        
    }
    override func setLayout() {
        
    }
    
    override func setAddTarget() {
        
    }
    
    
    //DropDown button동작 설정
    func setupDropDown(dropDown: DropDown, anchorView: UIView, button: UIButton, items: [String]) {
        dropDown.anchorView = anchorView
        dropDown.dataSource = items
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if dropDown == self.partDropDown {
                self.cardView.partLabel.text = item
                print(self.cardView.partLabel.text!)
                
            } else if dropDown == self.langDropDown {
                self.cardView.langLabel.text = item
                print(self.cardView.langLabel.text!)
            } else if dropDown == self.oldDropDown {
                self.cardView.oldLabel.text = item
                print(self.cardView.oldLabel.text!)
            }
            let part = self.cardView.partLabel.text ?? " "
            let lang = self.cardView.langLabel.text ?? " "
            let old = self.cardView.oldLabel.text ?? " "
            DispatchQueue.main.async {
                self.contents.removeAll()
                        let part = self.cardView.partLabel.text ?? " "
                        let lang = self.cardView.langLabel.text ?? " "
                        let old = self.cardView.oldLabel.text ?? " "
                        self.loadCardDataFromAPI(part: part, lang: lang, old: old, page: self.page)
                    }
        }
        
        button.addTarget(self, action: #selector(showDropDown(sender:)), for: .touchUpInside)
        
    }
    
    //Dropdown show function
    @objc func showDropDown(sender: UIButton) {
        if sender == cardView.partButton {
            partDropDown.show()
        } else if sender == cardView.langButton {
            langDropDown.show()
        } else if sender == cardView.oldButton {
            oldDropDown.show()
        }
    }
}

