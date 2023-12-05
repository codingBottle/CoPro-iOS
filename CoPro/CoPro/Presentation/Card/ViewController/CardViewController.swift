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
    let partDropDown = DropDown()
    let langDropDown = DropDown()
    let oldDropDown = DropDown()
    let cardView = CardView()
    
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
