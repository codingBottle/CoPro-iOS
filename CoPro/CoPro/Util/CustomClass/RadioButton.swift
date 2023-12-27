//
//  RadioButton.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import UIKit

import SnapKit
import Then

class RadioButton: UIControl {
    
    var unselectedBackgroundColor: UIColor = .white {
        didSet {
            updateState()
        }
    }

    var borderColor: UIColor = .gray {
        didSet {
            updateState()
        }
    }

    var selectedColor: UIColor = .black {
        didSet {
            updateState()
        }
    }

    var isOn: Bool = false {
        didSet {
            updateState()
        }
    }

    private let size: CGFloat = 16
    private let checkedViewSize: CGFloat = 8

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1.2
        return view
    }()

    private let checkedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(contentView)
        contentView.addSubview(checkedView)

        contentView.layer.cornerRadius = size / 2
        checkedView.layer.cornerRadius = checkedViewSize / 2

        updateState()

        contentView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.width.equalTo(size)
            $0.height.equalTo(size)
            $0.center.equalToSuperview()
        }
        
        checkedView.snp.makeConstraints {
            $0.width.equalTo(checkedViewSize)
            $0.height.equalTo(checkedViewSize)
            $0.center.equalTo(contentView)
        }
    }

    private func updateState() {
        contentView.layer.borderColor = isOn ? selectedColor.cgColor : borderColor.cgColor
        contentView.backgroundColor = isOn ? selectedColor : unselectedBackgroundColor
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isOn.toggle()
        sendActions(for: .valueChanged)
    }
}
