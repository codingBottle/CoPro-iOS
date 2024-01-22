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
                       language: contents[indexPath.item].language ?? " ")
        return cell
    }
    //셀 사이즈 정의
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cardViewWidth = cardView.scrollView.frame.width
        let cardViewHeight = cardView.scrollView.frame.height
        
        return CGSize(width: cardViewWidth, height: cardViewHeight)
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
        let width = scrollView.frame.width
        let index = Int(scrollView.contentOffset.x / width)
        print("현재 페이지: \(index)")
        
        if last == true {
            print("마지막 페이지")
            return
        }else if index == contents.count - 1 {
            DispatchQueue.main.async {
                self.loadNextPage()
//                let firstIndexPath = IndexPath(item: 0, section: 0)
//                self.collectionView.scrollToItem(at: firstIndexPath, at: .left, animated: true)
                        
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
        
        self.getUserData(part: part, lang: lang, old: old)
       
        print("page value: \(page)")
    }
    var last = false
    var page = 0
    var contents: [Content] = [] // API 데이터를 저장할 배열
    let partDropDown = DropDown()
    let langDropDown = DropDown()
    let oldDropDown = DropDown()
    let cardView = CardView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        //        collectionView.reloadData()
        return collectionView
    }()
    //    func updateSlideCardView(with contents: [Content]) {
    //        for content in contents {
    //            let slideCardView = SlideCardView()
    //            // content를 이용하여 slideCardView 설정
    //            slideCardView.loadImage(url: content.picture)
    //            slideCardView.userNameLabel.text = content.name
    //            slideCardView.userPartLabel.text = content.occupation
    //            slideCardView.userLangLabel.text = content.language // 예: title이라는 속성이 있다고 가정
    //            cardView.stackView.addArrangedSubview(slideCardView)
    //            slideCardView.snp.makeConstraints {
    //                $0.width.equalTo(cardView.scrollView)
    //            }
    //        }
    //    }
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
        getUserData(part: " ", lang: " ", old: " ")
        
    }
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(cardView.scrollView).offset(0)
        }
        
        collectionView.register(CardCollectionCellView.self, forCellWithReuseIdentifier: "CardCollectionCellView")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func getUserData(part: String, lang: String, old: String) {
        //keychain 토큰가저오기
        let keychain = KeychainSwift()
        guard let token = keychain.get("idToken") else {
            print("No token found in keychain.")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        // Body 설정
        let parameters: Parameters = [
            "memberId" : 17,
            "occupation": part == "직군" ? " " : part,
            "language": lang == "언어" ? " " :lang,
            "career": old == "경력" ? " " : old,
            "page":page,
            "size":10
            
        ]
        
        // Alamofire을 사용한 API 요청
        AF.request("", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON  { response in
                switch response.result {
                case .success(let apiResponse):
                    print("Api Response Success \(response)")
                    do {
                        // apiResponse를 Data 타입으로 변환
                        let data = try JSONSerialization.data(withJSONObject: apiResponse, options: [])
                        // JSONDecoder 인스턴스 생성
                        let decoder = JSONDecoder()
                        // 디코딩을 시도
                        let cardDTO = try decoder.decode(CardDTO.self, from: data)
                        // 디코딩 성공, cardDTO를 사용하여 원하는 작업 수행
                        print(cardDTO.statusCode)
                        self.contents.append(contentsOf: cardDTO.data.memberResDto.content)
                        self.last = cardDTO.data.memberResDto.last
                        DispatchQueue.main.async {
                            print("Updating SlideCardView")
                            self.collectionView.reloadData()
                        }
                        
                    } catch {
                        // 디코딩 실패, 에러 처리
                        print("Decoding Failed: \(error)")
                    }
                case .failure(let error):
                    print("Api Response Error: \(error)")
                }
            }
    }
    override func setUI() {
        
    }
    override func setLayout() {
        
    }
    override func setAddTarget() {
        
    }
    
    //button동작 설정
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
            self.getUserData(part: part,lang: lang,old: old)
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

