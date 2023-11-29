//
//  ViewController.swift
//  CoPro
//
//  Created by 박신영 on 10/10/23.
//

import UIKit
import SnapKit
import Then

class BaseViewController: UIViewController {
    // MARK: - Property
    override func loadView() {
        view = BaseView()
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        self.view.setNeedsUpdateConstraints()
        self.setUI()
        self.setLayout()
        self.setAddTarget()
    }
    
    
    // MARK: - UI Components
    func setUI() {}
    // MARK: - Layout Helper
    func setLayout() {}
    // MARK: - Add Target
    func setAddTarget() {}
}

