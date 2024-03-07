//
//  CardView.swift
//  CoPro
//
//  Created by 박현렬 on 11/29/23.
//

import UIKit
import SnapKit
import Then


class CardView: BaseView{
    // UIStackView 생성
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal  // 가로 방향으로 정렬
        $0.distribution = .fillEqually  // 모든 뷰의 크기를 동일하게 설정
        $0.spacing = 20  // 뷰 사이의 간격을 20으로 설정
    }
    let partContainerView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24)
        $0.layer.cornerRadius = 20
    }
    let partLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "직무", size: 17, weight: .bold, letterSpacing: 1.23)
        $0.textColor = UIColor.G3()
    }
    let partButton = UIButton().then {
        guard let originalImage = UIImage(systemName: "chevron.down") else {
            return
        }
        // 이미지를 두꺼운 스타일로 생성
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .bold) // 두꺼운 굵기를 적용
        let boldImage = originalImage.withConfiguration(symbolConfiguration)
        // 버튼에 이미지 설정
        $0.setImage(boldImage, for: .normal)
        $0.tintColor = UIColor.G3()
    }
    let langContainerView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24)
        $0.layer.cornerRadius = 20
    }
    let langLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "언어", size: 17, weight: .bold, letterSpacing: 1.23)
        $0.textColor = UIColor.G3()
    }
    let langButton = UIButton().then {
        guard let originalImage = UIImage(systemName: "chevron.down") else {
            return
        }
        // 이미지를 두꺼운 스타일로 생성
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .bold) // 두꺼운 굵기를 적용
        let boldImage = originalImage.withConfiguration(symbolConfiguration)
        // 버튼에 이미지 설정
        $0.setImage(boldImage, for: .normal)
        $0.tintColor = UIColor.G3()
    }
    let oldContainerView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24)
        $0.layer.cornerRadius = 20
    }
    let oldLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "경력", size: 17, weight: .bold, letterSpacing: 1.23)
        $0.textColor = UIColor.G3()
    }
    let oldButton = UIButton().then {
        guard let originalImage = UIImage(systemName: "chevron.down") else {
            return
        }
        // 이미지를 두꺼운 스타일로 생성
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .bold) // 두꺼운 굵기를 적용
        let boldImage = originalImage.withConfiguration(symbolConfiguration)
        // 버튼에 이미지 설정
        $0.setImage(boldImage, for: .normal)
        $0.tintColor = UIColor.G3()
    }
    
    let slideCardView = SlideCardView()
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = UIColor.White()
    }
    let miniCardView = MiniCard()
    
    override func setUI() {
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubviews(partContainerView,langContainerView,oldContainerView)
        partContainerView.addSubviews(partLabel,partButton)
        langContainerView.addSubviews(langLabel,langButton)
        oldContainerView.addSubviews(oldLabel,oldButton)
        addSubview(scrollView)
    }
    
    override func setLayout() {
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
        partLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        partButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.trailing.equalTo(partLabel.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }

        langLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        langButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.trailing.equalTo(langLabel.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        oldLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        oldButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.trailing.equalTo(oldLabel.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        scrollView.snp.makeConstraints{
            $0.top.equalTo(buttonStackView.snp.bottom).offset(20)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(self.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(0)
        }
    }
    
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

