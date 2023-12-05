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


class CardViewController: BaseViewController {
    let dropDown = DropDown()
    let cardView = CardView()
    
    override func loadView() {
        // View를 생성하고 추가합니다.
        view = cardView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // DropDown 설정
        dropDown.anchorView = CardView().partContainerView  // DropDown 메뉴를 연결
        dropDown.dataSource = ["Mobile", "Server", "Web"]  // DropDown 메뉴의 항목 설정
        
        // 항목 선택시 동작 설정
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cardView.partLabel.text = item
        }
        
        // 버튼 클릭시 DropDown 메뉴 표시
        cardView.partButton.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
    }
    override func setUI() {
        
    }
    override func setLayout() {
        
    }
    override func setAddTarget() {
        
    }
    @objc func showDropDown() {
        dropDown.show()
    }
}
