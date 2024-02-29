//
//  Checkbox.swift
//  CoPro
//
//  Created by 문인호 on 2/19/24.
//

import UIKit

class Checkbox: UIView {
    var isChecked = false
    let checkbox = UIImageView()
    let label = UILabel()
    
    private func createSubViews(text: String) {
        label.textColor = .Black()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = text
        label.textAlignment = .left
            
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
        checkbox.image = UIImage(systemName: "square")
        checkbox.contentMode = .scaleAspectFit
        checkbox.tintColor = .P2()
            
        addSubview(checkbox)
        checkbox.snp.makeConstraints { make in
            make.right.equalToSuperview()
        }
    }


    public func toggle() {
        self.isChecked = !isChecked
            
        if isChecked {
            checkbox.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            checkbox.image = UIImage(systemName: "square")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init (text: String) {
        super.init(frame: .zero)
        createSubViews(text: text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
