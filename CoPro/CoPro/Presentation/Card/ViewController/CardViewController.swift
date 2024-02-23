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


class CardViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, CardCollectionCellViewDelegate, MiniCardGridViewDelegate {
    
    func didTapChatButtonOnMiniCardGridView(in cell: MiniCardGridView, success: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let tabBarController = window.rootViewController as? BottomTabController {
            tabBarController.selectedIndex = 3
        }
       else {print("현재 여기로 들어옴.")}
        DispatchQueue.main.async {
            if success {
                self.showAlert(title: "🥳채팅방이 개설되었습니다🥳",
                               message: "채팅 리스트에서 확인하여주세요!",
                               confirmButtonName: "확인")
            }
            else {
                self.showAlert(title: "이미 채팅방에 존재하는 사람입니다",
                               message: "채팅 리스트에서 확인하여주세요",
                               confirmButtonName: "확인")
            }
        }
    }
    
    func didTapChatButtonOnCardCollectionCellView(in cell: CardCollectionCellView, success: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let tabBarController = window.rootViewController as? BottomTabController {
            tabBarController.selectedIndex = 3
        }
       else {print("현재 여기로 들어옴.")}
        DispatchQueue.main.async {
            if success {
                self.showAlert(title: "🥳채팅방이 개설되었습니다🥳",
                               message: "채팅 리스트에서 확인하여주세요!",
                               confirmButtonName: "확인")
            }
            else {
                self.showAlert(title: "이미 채팅방에 존재하는 사람입니다",
                               message: "채팅 리스트에서 확인하여주세요",
                               confirmButtonName: "확인")
            }
        }
       
       
       /* 화면 전환은 이루어지나 뷰 생명주기에 위반하는 것 같아 일단 보류.
       if let tabBarController = self.tabBarController as? BottomTabController {
               tabBarController.selectedIndex = 3
           }

           DispatchQueue.main.async {
               if success {
                   self.showAlert(title: "🥳채팅방이 개설되었습니다🥳",
                                  message: "채팅 리스트에서 확인하여주세요!",
                                  confirmButtonName: "확인")
               } else {
                   self.showAlert(title: "이미 채팅방에 존재하는 사람입니다",
                                  message: "채팅 리스트에서 확인하여주세요",
                                  confirmButtonName: "확인")
               }
           }
        */
    }
    
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
            cell.configure(with: contents[indexPath.item].picture ?? "",
                           nickname: contents[indexPath.item].nickName ?? "",
                           occupation: contents[indexPath.item].occupation ?? " ",
                           language: contents[indexPath.item].language ?? " ", gitButtonURL:  contents[indexPath.item].gitHubURL ?? " ", likeCount: contents[indexPath.item].likeMembersCount ?? 0,memberId: contents[indexPath.item].memberId ?? 0 ,isLike: contents[indexPath.item].isLikeMembers, email: contents[indexPath.item].email ?? "")
            cell.CardCollectionCellViewdelegate = self
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
        cell.configure(with: contents[indexPath.item].picture ?? "",
                       nickname: contents[indexPath.item].nickName ?? "",
                       occupation: contents[indexPath.item].occupation ?? " ",
                       language: contents[indexPath.item].language ?? " ",old:contents[indexPath.item].career ?? 0, gitButtonURL:  contents[indexPath.item].gitHubURL ?? " ", likeCount: contents[indexPath.item].likeMembersCount ?? 0,memberId: contents[indexPath.item].memberId ?? 0,isLike: contents[indexPath.item].isLikeMembers, email: contents[indexPath.item].email ?? "")
        cell.MiniCardGridViewdelegate = self
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
        if myViewType == 0 {
            return 0
        }else{
            return 10
        }
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
            
            //            if last == true{
            //                print("가로 마지막 페이지 - 처음 페이지로 돌아갑니다.")
            //                DispatchQueue.main.async {
            //                    //                    self.loadFirstPage()
            //                }
            //            }
            if index == contents.count - 1 {
                DispatchQueue.main.async {
                    print("PageUpDate")
                    self.loadNextPage()
                }
            }
        }
        else {
            let height =  272.0
            let index = Int(scrollView.contentOffset.y / height)
            print("세로 현재 페이지: \(index)")
            if index > 1 {
                DispatchQueue.main.async {
                    print("PageUpDate")
                    self.loadNextPage()
                    
                }
            }
        }
    }
    // 다음 페이지의 데이터를 불러오는 메서드
    func loadNextPage() {
        //        if last == true {
        //            print("마지막 페이지")
        //            DispatchQueue.main.async {
        //
        //                //                self.loadFirstPage()
        //            }
        //        }else{
        // 페이지 번호를 증가시키고 데이터를 불러옴
        self.page += 1
        let part = self.cardView.partLabel.text ?? " "
        let lang = self.cardView.langLabel.text ?? " "
        let old = self.oldIndex
        print(self.page)
        self.loadCardDataFromAPI(part: part, lang: lang, old: old,page: self.page)
        
        print("page value: \(self.page)")
        //        }
    }
    //첫 페이지로 돌아가는 메소드
    //    func loadFirstPage() {
    //        self.page = 0
    //        self.contents.removeAll()
    //        let part = self.cardView.partLabel.text ?? " "
    //        let lang = self.cardView.langLabel.text ?? " "
    //        let old = self.oldIndex
    //        loadCardDataFromAPI(part: part, lang: lang, old: old, page: 0)
    //        print("첫 페이지로 돌아갔습니다.")
    //    }
    
    var myViewType = 0
    var last = false
    var page = 0
    var oldIndex = 0
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
        loadCardDataFromAPI(part: " ", lang: " ", old: 0,page: 0)
        view.backgroundColor = UIColor.White()
        //        setDropDownText()
        setupDropDown(dropDown: partDropDown, anchorView: cardView.partContainerView, button: cardView.partButton, items: ["전체","Frontend", "Backend", "Mobile", "AI"])
        setupDropDown(dropDown: langDropDown, anchorView: cardView.langContainerView, button: cardView.langButton, items: ["SwiftUI", "UIKit", "Flutter", "Kotlin", "Java", "RN","Spring", "Django", "Flask", "Node.js", "Go","React.js", "Vue.js", "Angular.js", "TypeScript", "TensorFlow", "Keras", "PyTorch"])
        setupDropDown(dropDown: oldDropDown, anchorView: cardView.oldContainerView, button: cardView.oldButton, items: ["전체","신입", "3년 미만", "3년 이상", "5년 이상", "10년 이상"])
        setupCollectionView()
        
    }
    private func setDropDownText(){
        self.cardView.partLabel.text = "직무"
        self.cardView.partLabel.textColor = UIColor.G3()
        self.cardView.partButton.tintColor = UIColor.G3()
        self.cardView.langLabel.text = "언어"
        self.cardView.langLabel.textColor = UIColor.G3()
        self.cardView.langButton.tintColor = UIColor.G3()
        self.cardView.oldLabel.text = "경력"
        self.cardView.oldLabel.textColor = UIColor.G3()
        self.cardView.oldButton.tintColor = UIColor.G3()
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
    func reloadData() {
        CardAPI.shared.getUserData(part: " ", lang: " ", old: 0,page: page) { [weak self] result in
            DispatchQueue.main.async {
                self?.collectionView.reloadData() // 컬렉션 뷰일 경우
            }
        }
    }
    //API호출
    func loadCardDataFromAPI(part: String, lang: String, old: Int, page: Int) {
        
        CardAPI.shared.getUserData(part: part, lang: lang, old: old, page: page) { [weak self] result in
            switch result {
            case .success(let cardDTO):
                DispatchQueue.main.async {
                    self?.contents.append(contentsOf: cardDTO.data.memberResDto.content)
                    self?.collectionView.reloadData()
                    self?.last = cardDTO.data.memberResDto.last
                    self?.myViewType = cardDTO.data.myViewType
                    let scrollDirection: UICollectionView.ScrollDirection = (self?.myViewType == 0) ? .horizontal : .vertical
                    
                    if let layout = self?.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                        layout.scrollDirection = scrollDirection
                        self?.collectionView.isPagingEnabled = (scrollDirection == .horizontal)
                    }
                    
                    
                    if self?.contents.count == 0 {
                        // contents가 비어있을 때 메시지 라벨을 추가합니다.
                        let messageLabel = UILabel().then {
                            $0.setPretendardFont(text: "조건에 맞는 개발자가 없어요!", size: 17, weight: .regular, letterSpacing: 1.25)
                            $0.textColor = .black
                            $0.textAlignment = .center
                        }
                        let messageLabel2 = UILabel().then {
                            $0.setPretendardFont(text: "조건을 수정해보세요.", size: 17, weight: .regular, letterSpacing: 1.25)
                            $0.textColor = .black
                            $0.textAlignment = .center
                        }
                        
                        let imageView = UIImageView(image: UIImage(named: "card_coproLogo")) // 이미지 생성
                        imageView.contentMode = .center // 이미지가 중앙에 위치하도록 설정
                        
                        let stackView = UIStackView(arrangedSubviews: [imageView, messageLabel,messageLabel2]) // 이미지와 라벨을 포함하는 스택 뷰 생성
                        stackView.axis = .vertical // 세로 방향으로 정렬
                        stackView.alignment = .center // 가운데 정렬
                        stackView.spacing = 10 // 이미지와 라벨 사이의 간격 설정
                        
                        self?.collectionView.backgroundView = UIView() // 배경 뷰 생성
                        
                        if let backgroundView = self?.collectionView.backgroundView {
                            backgroundView.addSubview(stackView) // 스택 뷰를 배경 뷰에 추가
                            
                            stackView.snp.makeConstraints {
                                $0.centerX.equalTo(backgroundView) // 스택 뷰의 가로 중앙 정렬
                                $0.centerY.equalTo(backgroundView) // 스택 뷰의 세로 중앙 정렬
                            }
                        }
                    } else {
                        // contents가 비어있지 않을 때 메시지 라벨을 제거합니다.
                        self?.collectionView.backgroundView = nil
                    }
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
        dropDown.direction = .bottom
        dropDown.offsetFromWindowBottom = 400
        dropDown.cornerRadius = 15
        dropDown.backgroundColor = UIColor.White()
        dropDown.textColor = UIColor.G3()
        dropDown.selectedTextColor = UIColor.P2()
        dropDown.textFont = UIFont(name: "Pretendard-Bold", size: 15)!
        dropDown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.textAlignment = .center
        }
       
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if dropDown == self.partDropDown {
                
                self.cardView.partLabel.text = item
                self.cardView.partLabel.textColor = UIColor.P2()
                self.cardView.partButton.tintColor = UIColor.P2()
                self.cardView.langLabel.text = "언어"
                self.cardView.langLabel.textColor = UIColor.G3()
                self.cardView.langButton.tintColor = UIColor.G3()
                self.cardView.oldLabel.text = "경력"
                self.cardView.oldLabel.textColor = UIColor.G3()
                self.cardView.oldButton.tintColor = UIColor.G3()
                print(self.cardView.partLabel.text!)
                updateLangDropDown(part: item)
                
            } else if dropDown == self.langDropDown {
                self.cardView.langLabel.text = item
                self.cardView.langLabel.textColor = UIColor.P2()
                self.cardView.langButton.tintColor = UIColor.P2()
                print(self.cardView.partLabel.text!)
                
            } else if dropDown == self.oldDropDown {
                self.cardView.oldLabel.text = item
                self.cardView.oldLabel.textColor = UIColor.P2()
                self.cardView.oldButton.tintColor = UIColor.P2()
                switch item {
                case "전체":
                    self.oldIndex = 0
                case "신입":
                    self.oldIndex = 1
                case "3년 미만":
                    self.oldIndex = 2
                case "3년 이상":
                    self.oldIndex = 3
                case "5년 이상":
                    self.oldIndex = 4
                case "10년 이상":
                    self.oldIndex = 5
                default:
                    self.oldIndex = 0
                }
                print(oldIndex)
            }
            DispatchQueue.main.async {
                self.contents.removeAll()
                let part = self.cardView.partLabel.text != "전체" ? self.cardView.partLabel.text : " "
                let lang = self.cardView.langLabel.text != "전체" ? self.cardView.langLabel.text : " "
                self.loadCardDataFromAPI(part: part!, lang: lang!, old: self.oldIndex, page: 0)
                self.collectionView.reloadData()}
        }
        
        button.addTarget(self, action: #selector(showDropDown(sender:)), for: .touchUpInside)
        
    }
    // 두 번째 드롭다운 내용 업데이트 메서드
    func updateLangDropDown(part: String) {
        var langItems: [String] = []
        // 첫 번째 드롭다운 선택값에 따라 두 번째 드롭다운 내용 설정
        if part == "Mobile" {
            langItems = ["SwiftUI", "UIKit", "Flutter", "Kotlin", "Java", "RN"]
        } else if part == "Backend" {
            langItems = ["Spring", "Django", "Flask", "Node.js", "Go"]
        } else if part == "Frontend" {
            langItems = ["React.js", "Vue.js", "Angular.js", "TypeScript"]
        } else if part == "AI"{
            langItems = ["TensorFlow", "Keras", "PyTorch"]
        } else if part == "전체"{
            langItems = ["SwiftUI", "UIKit", "Flutter", "Kotlin", "Java", "RN","Spring", "Django", "Flask", "Node.js", "Go","React.js", "Vue.js", "Angular.js", "TypeScript", "TensorFlow", "Keras", "PyTorch"]
        }
        
        // 두 번째 드롭다운 업데이트
        langDropDown.dataSource = langItems
        langDropDown.reloadAllComponents()
    }
    
    //Dropdown show function
    @objc func showDropDown(sender: UIButton) {
        if sender == cardView.partButton {
            partDropDown.bottomOffset = CGPoint(x: 0, y:(partDropDown.anchorView?.plainView.bounds.height)!)
            partDropDown.show()
        } else if sender == cardView.langButton {
            langDropDown.bottomOffset = CGPoint(x: 0, y:(langDropDown.anchorView?.plainView.bounds.height)!)
            langDropDown.show()
        } else if sender == cardView.oldButton {
            oldDropDown.bottomOffset = CGPoint(x: 0, y:(oldDropDown.anchorView?.plainView.bounds.height)!)
            oldDropDown.show()
        }
    }
}
