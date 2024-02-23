//
//  SortBottomSheetViewController.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import UIKit

import SnapKit
import Then

final class SortBottomSheetViewController: UIViewController, SendStringData, radioDelegate {
    func sendDefaultSelect(withOpt opt: String) {
        tmp = opt
    }
    
    func sendData(mydata: String, groupId: Int) {
        delegate?.sendData(mydata: mydata, groupId: groupId)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI Components
    
    private let sortRadioButton = RadioButtonsStack(groupId: 1)
    weak var delegate: SendStringData?
    var tmp = String()
    
    // MARK: - Properties
    
    // MARK: - Initializer
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let options = ["최신순", "인기순"]
        sortRadioButton.set(options, defaultSelection: tmp)
        setUI()
        setLayout()
        addTarget()
        setDelegate()
    }
}

extension SortBottomSheetViewController {
    
    // MARK: - UI Components Property
    
    private func setDelegate() {
        sortRadioButton.delegate = self
    }
    private func setUI() {
        
        self.view.backgroundColor = UIColor.systemBackground
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 20
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [.custom {context in
                return 200
            }]
            
            sortRadioButton.do {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
        }
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        view.addSubviews(sortRadioButton)
        
        sortRadioButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
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
