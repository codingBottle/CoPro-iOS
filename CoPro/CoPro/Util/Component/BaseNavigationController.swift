//
//  BaseNavigationController.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarStyle()
    }
    
    private func setupNavigationBarStyle() {
        let mainColor = UIColor.label
        navigationBar.tintColor = mainColor
        navigationBar.prefersLargeTitles = true
        navigationBar.titleTextAttributes = [.foregroundColor: mainColor]
    }
}

