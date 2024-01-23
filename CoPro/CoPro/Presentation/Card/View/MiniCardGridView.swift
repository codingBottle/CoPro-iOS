//
//  MiniCardGridView.swift
//  CoPro
//
//  Created by 박현렬 on 1/23/24.
//

import UIKit
import SnapKit
import Then


class MiniCardGridView: UICollectionViewCell {
    let miniCardView = MiniCard()
    var gitButtonURL: String?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGitButtonTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(miniCardView)
        miniCardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func setupGitButtonTarget() {
        miniCardView.gitButton.addTarget(self, action: #selector(gitButtonTapped), for: .touchUpInside)
        miniCardView.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
    }
    
    //Github버튼 동작 메소드
    @objc func gitButtonTapped() {
        if let gitURL = gitButtonURL {
            print("Git 버튼이 눌렸습니다. URL: \(gitURL)")
            // Open the URL in Safari
            if gitButtonURL == " "{
                print("URL미등록")
            }else{
                UIApplication.shared.open(URL(string: gitButtonURL!)!, options: [:], completionHandler: nil)
            }
        } else {
            print("Git 버튼이 눌렸지만 URL이 없습니다.")
        }
    }
    //Chat버튼 동작 메소드
    @objc func chatButtonTapped() {
        print("Chat 버튼이 눌렸습니다.")
    }
    
    func configure(with imageUrl: String,name: String, occupation: String, language: String, gitButtonURL: String) {
        self.gitButtonURL = gitButtonURL
        miniCardView.loadImage(url: imageUrl)
        miniCardView.userNameLabel.text = name
        miniCardView.userPartLabel.text = occupation
        miniCardView.userLangLabel.text = language
        print("Configuring cell with URL: \(imageUrl), name: \(name), occupation: \(occupation), language: \(language), gitButtonURL: \(gitButtonURL)")

    }
}
