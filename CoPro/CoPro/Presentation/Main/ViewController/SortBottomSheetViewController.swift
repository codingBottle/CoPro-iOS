//
//  SortBottomSheetViewController.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import UIKit

import SnapKit
import Then

final class SortBottomSheetViewController: UIViewController {

    // MARK: - UI Components
    
    private let sortRadioButton = RadioButtonsStack(groupId: 1)

    // MARK: - Properties
                    
    // MARK: - Initializer

    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addTarget()
    }
}

extension SortBottomSheetViewController {
    
    // MARK: - UI Components Property
    
    private func setUI() {
        
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 20
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [.custom {context in
                return 200
            }]
            
            sortRadioButton.do {
                let options = ["최신순", "인기순"]
                $0.set(options, defaultSelection: "최신순")
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
