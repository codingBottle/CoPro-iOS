//
//  CardView.swift
//  CoPro
//
//  Created by 박현렬 on 11/29/23.
//

import UIKit
import SnapKit
import Then


class CardView: BaseView {
    
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
        $0.textAlignment = .left
        $0.attributedText = NSAttributedString(string: "직군", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1), NSAttributedString.Key.kern: 1.25])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let partButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1)
    }
    let langContainerView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24)
        $0.layer.cornerRadius = 20
    }
    let langLabel = UILabel().then {
        $0.textAlignment = .left
        $0.attributedText = NSAttributedString(string: "언어", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1), NSAttributedString.Key.kern: 1.25])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let langButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1)
    }
    let oldContainerView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24)
        $0.layer.cornerRadius = 20
    }
    let oldLabel = UILabel().then {
        $0.textAlignment = .left
        $0.attributedText = NSAttributedString(string: "경력", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1), NSAttributedString.Key.kern: 1.25])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let oldButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1)
    }
    
    let slideCardView = SlideCardView()
    let carouselSlideView = CarouselSlideView()
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        
    }
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    let miniCardView = MiniCard()
    
    override func setUI() {
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubviews(partContainerView,langContainerView,oldContainerView)
        partContainerView.addSubviews(partLabel,partButton)
        langContainerView.addSubviews(langLabel,langButton)
        oldContainerView.addSubviews(oldLabel,oldButton)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
            
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
        
        
        //        slideCardView.snp.makeConstraints{
        //            $0.top.equalTo(buttonStackView.snp.bottom).offset(20)
        //            $0.centerX.equalTo(self.safeAreaLayoutGuide)
        //            $0.width.equalTo(self.safeAreaLayoutGuide).inset(20)
        //            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(100)
        //        }
        scrollView.snp.makeConstraints{
            $0.top.equalTo(buttonStackView.snp.bottom).offset(20)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(self.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(100)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(scrollView)
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
