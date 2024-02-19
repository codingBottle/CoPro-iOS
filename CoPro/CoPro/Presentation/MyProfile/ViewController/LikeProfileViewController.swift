//
//  LikeProfileViewController.swift
//  CoPro
//
//  Created by 박현렬 on 2/18/24.
//

import UIKit

class LikeProfileViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, MiniCardGridViewDelegate  {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        getLoadLikeProfileData(page: 0)
        // MARK: NavigationBar Custom Settings
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Regular", size: 17)!, // Pretendard 폰트 적용
            .kern: 1.25, // 자간 조절
            .foregroundColor: UIColor.black // 폰트 색상
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "관심 프로필"
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.tintColor = UIColor.Black()
        let backButton = UIButton(type: .custom)
        guard let originalImage = UIImage(systemName: "chevron.left") else {
            return
        }
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24) // 이미지 크기 설정
        let boldImage = originalImage.withConfiguration(symbolConfiguration)
        
        backButton.setImage(boldImage, for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // 버튼의 크기설정
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 8 // 왼쪽 여백의 크기
        self.navigationItem.leftBarButtonItems?.insert(spacer, at: 0) // 왼쪽 여백 추가
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16) // 위쪽 여백
            $0.bottom.equalToSuperview().offset(-16) // 아래쪽 여백
            $0.leading.equalToSuperview().offset(16) // 왼쪽 여백
            $0.trailing.equalToSuperview().offset(-16) // 오른쪽 여백
        }
        
        collectionView.register(MiniCardGridView.self, forCellWithReuseIdentifier: "MiniCardGridView")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapChatButtonOnMiniCardGridView(in cell: MiniCardGridView, success: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let tabBarController = window.rootViewController as? BottomTabController {
            tabBarController.selectedIndex = 3
        }
        DispatchQueue.main.async {
            if success {
                CardViewController().showAlert(title: "🥳채팅방이 개설되었습니다🥳",
                                               message: "채팅을 보내 대화를 시작해보세요",
                                               confirmButtonName: "확인")
            }
            else {
                CardViewController().showAlert(title: "이미 채팅방에 존재하는 사람입니다",
                                               message: "채팅 리스트에서 확인하여주세요",
                                               confirmButtonName: "확인")
            }
        }
    }
    
    var contents: [LikeProfileContent] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                       nickname: contents[indexPath.item].name ?? "",
                       occupation: contents[indexPath.item].occupation ?? " ",
                       language: contents[indexPath.item].language ?? " ",old:contents[indexPath.item].career ?? 0, gitButtonURL:  contents[indexPath.item].gitHubURL ?? " ", likeCount: contents[indexPath.item].likeMembersCount ?? 0,memberId: contents[indexPath.item].memberLikeID ?? 0,isLike: contents[indexPath.item].isLike, email: contents[indexPath.item].email)
        cell.MiniCardGridViewdelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let numberOfItemsInRow: CGFloat = 2
        let spacingBetweenItems: CGFloat = 10
        
        let totalSpacing = (numberOfItemsInRow - 1) * spacingBetweenItems
        let cellWidth = (collectionView.frame.width - totalSpacing) / numberOfItemsInRow
        
        
        let cellHeight = 272
        
        return CGSize(width: cellWidth, height: 272)
    }
    // 셀사이 여백 값 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    var last = false
    var page = 0
    func getLoadLikeProfileData(page: Int) {
        CardAPI.shared.getLikeUser(page: self.page) { [weak self] result in
            switch result {
            case .success(let likeProfileDto):
                DispatchQueue.main.async {
                    self?.contents.append(contentsOf: likeProfileDto.data.content)
                    self?.last = likeProfileDto.data.last
                    
                    self?.collectionView.reloadData()
                    if self?.contents.count == 0 {
                        // contents가 비어있을 때 메시지 라벨을 추가합니다.
                        let messageLabel = UILabel().then {
                            $0.setPretendardFont(text: "관심 프로필이 없어요!", size: 17, weight: .regular, letterSpacing: 1.25)
                            $0.textColor = .black
                            $0.textAlignment = .center
                        }
            
                        let imageView = UIImageView(image: UIImage(named: "card_coproLogo")) // 이미지 생성
                        imageView.contentMode = .center // 이미지가 중앙에 위치하도록 설정
                        
                        let stackView = UIStackView(arrangedSubviews: [imageView, messageLabel]) // 이미지와 라벨을 포함하는 스택 뷰 생성
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
                    print("API Success: \(likeProfileDto.data.content.count)")
                    print("APIDATA : \(String(describing: self?.contents))")
                }
                
            case .failure(let error):
                print("API Error: \(error)")
            }
        }
    }
    
    
}


