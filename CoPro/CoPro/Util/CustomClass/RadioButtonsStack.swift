//
//  RadioButtonsStack.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import UIKit

import SnapKit
import Then

protocol SendStringData: AnyObject {
    func sendData(mydata: String, groupId: Int)
    func radioButtonDidSelect()
}


class RadioButtonsStack: UIView {
    
    weak var delegate: SendStringData?
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 11
        return view
    }()

    private var radioViews = [RadioButtonView]()

    var selectedIndex: Int?
    var groupId: Int?

    init(groupId: Int) {
            self.groupId = groupId // 그룹 식별 변수 초기화
            super.init(frame: .zero)
            setup()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func set(_ options: [String], defaultSelection: String?) {
            radioViews.removeAll()
            stackView.removeAllArrangedSubviews()
            for (index, text) in options.enumerated() {
                let radioView: RadioButtonView = {
                    let view = RadioButtonView()
                    view.radioButton.tag = index
                    view.radioButton.addTarget(self, action: #selector(radioSelected(_:)), for: .valueChanged)
                    view.set(text)
                    
                    if let defaultSelection = defaultSelection, text == defaultSelection {
                                    selectedIndex = index
                                    view.select(true)
                                }
                    
                    return view
                }()
                stackView.addArrangedSubview(radioView)
                radioViews.append(radioView)
            }
        }

    @objc private func radioSelected(_ sender: RadioButton?) {
        guard let sender else { return }
        selectedIndex = sender.tag
        let desiredTag = sender.tag
        if let radioButtonView = radioViews.first(where: { $0.radioButton.tag == desiredTag }) {
            let labelText = radioButtonView.label.text ?? ""
            print("Label Text: \(labelText)")
            self.delegate?.sendData(mydata: labelText, groupId: groupId ?? 0)
            radioViews.forEach {
                $0.select($0.radioButton.tag == sender.tag)
            }
            delegate?.radioButtonDidSelect()
        }
    }

    class RadioButtonView: UIView {

        let radioButton: RadioButton = {
            let radioButton = RadioButton(frame: .zero)
            radioButton.translatesAutoresizingMaskIntoConstraints = false
            return radioButton
        }()
        
        let emptyView = UIView()

        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.textAlignment = .left
            label.font = .systemFont(ofSize: 14)
            return label
        }()

        let stackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.alignment = .center
            view.distribution = .fill
            view.axis = .horizontal
            view.spacing = 4
            return view
        }()

        init() {
            super.init(frame: .zero)
            setup()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }

        func setup() {
            addSubview(stackView)
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(radioButton)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor)])
        }

        func set(_ text: String) {
            label.text = text
        }

        func select(_ select: Bool) {
            radioButton.isOn = select
        }
    }
}
