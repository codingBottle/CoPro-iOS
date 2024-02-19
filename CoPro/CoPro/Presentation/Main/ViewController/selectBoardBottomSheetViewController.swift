//
//  selectBoardBottomSheetViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/17/24.
//

import UIKit

import SnapKit
import Then

final class SelectBoardBottomSheetViewController: UIViewController, SendStringData, radioDelegate {
    func sendDefaultSelect(withOpt opt: String) {
        tmp = opt
    }
    
    func sendData(mydata: String, groupId: Int) {
        delegate?.sendData(mydata: mydata, groupId: groupId)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI Components
    
    private let boardLabel = UILabel()
    private let lineView = UIView()
    private let sortRadioButton = RadioButtonsStack(groupId: 1)
    weak var delegate: SendStringData?
    var tmp = String()
    
    // MARK: - Properties
    
    // MARK: - Initializer
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let options = ["프로젝트", "자유"]
        sortRadioButton.set(options, defaultSelection: tmp)
        setUI()
        setLayout()
        addTarget()
        setDelegate()
    }
}

extension SelectBoardBottomSheetViewController {
    
    // MARK: - UI Components Property
    
    private func setDelegate() {
        sortRadioButton.delegate = self
    }
    private func setUI() {
        
        view.backgroundColor = UIColor.White()
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 20
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [.custom {context in
                return 200
            }]
            boardLabel.do {
                $0.setPretendardFont(text: "게시판 선택", size: 20, weight: .regular, letterSpacing: 1.0)
            }
            lineView.do {
                $0.backgroundColor = UIColor.G1()
            }
            sortRadioButton.do {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
        }
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        view.addSubviews(boardLabel, lineView,sortRadioButton)
        boardLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(boardLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        sortRadioButton.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func addTarget() {
//        cancelButton.addTarget(self, action: #selector(dismissToCreateEvaluateViewController), for: .touchUpInside)
//        saveButton.addTarget(self, action: #selector(saveEvaluate), for: .touchUpInside)
    }
 
    // MARK: - @objc Methods
    
    @objc
    private func dismissToCreateEvaluateViewController() {
        dismiss(animated: true, completion: nil)
    }
}

