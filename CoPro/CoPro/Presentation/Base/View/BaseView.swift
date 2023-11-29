//
//  BaseView.swift
//  CoPro
//
//  Created by 박신영 on 10/10/23.
//

import UIKit
import Then
import SnapKit

class BaseView: UIView {
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
        setDelegate()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI Components Property
    func setUI(){}
    // MARK: - Layout Helper
    func setLayout(){}
    // MARK: - Delegate Helper
    func setDelegate(){}
}
