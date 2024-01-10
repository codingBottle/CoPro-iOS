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


class CardViewController: BaseViewController {
    let partDropDown = DropDown()
    let langDropDown = DropDown()
    let oldDropDown = DropDown()
    let cardView = CardView()
    
    func updateSlideCardView(with contents: [Content]) {
        for content in contents {
            let slideCardView = SlideCardView()
            // content를 이용하여 slideCardView 설정
            slideCardView.userNameLabel.text = content.name
            slideCardView.userPartLabel.text = content.occupation
            slideCardView.userLangLabel.text = content.language // 예: title이라는 속성이 있다고 가정
            cardView.stackView.addArrangedSubview(slideCardView)
            slideCardView.snp.makeConstraints {
                $0.width.equalTo(cardView.scrollView)
            }
        }
    }
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
            "occupation": cardView.partLabel.text! == "직군" ? " " : cardView.partLabel.text!,
            "language": cardView.langLabel.text! == "언어" ? " " : cardView.langLabel.text!,
            "career": cardView.oldLabel.text! == "경력" ? " " : cardView.oldLabel.text!,
            "page":0,
            "size":10
            
        ]
        
        // Alamofire을 사용한 API 요청
        AF.request("-/api/infos", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
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
                        // SlideCardView를 생성하고 데이터를 설정
                        DispatchQueue.main.async {
                            self.updateSlideCardView(with: cardDTO.data.memberResDto.content)
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
            } else if dropDown == self.langDropDown {
                self.cardView.langLabel.text = item
            } else if dropDown == self.oldDropDown {
                self.cardView.oldLabel.text = item
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

