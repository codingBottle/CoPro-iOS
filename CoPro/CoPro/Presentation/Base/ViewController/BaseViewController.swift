//
//  ViewController.swift
//  CoPro
//
//  Created by 박신영 on 10/10/23.
//

import UIKit
import SnapKit
import Then

final class BaseViewController: UIViewController {
    
    // MARK: - UI Components
    
    // MARK: - Properties
    
    // MARK: - Initializer
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

extension BaseViewController {
    
    // MARK: - UI Components Property
    
    private func setUI() {
        view.backgroundColor = .blue
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        
    }
    
    // MARK: - Methods
    
    // MARK: - @objc Methods
}
