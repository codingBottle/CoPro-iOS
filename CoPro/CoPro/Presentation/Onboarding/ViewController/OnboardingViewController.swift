//
//  OnboardingViewController.swift
//  CoPro
//
//  Created by 박현렬 on 2/20/24.
//

import UIKit
import SnapKit
import Then

class OnboardingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 로고 이미지 설정
        let labelText = "협업할 개발자를 찾는다면?"
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "Logo")
        let label = UILabel().then{
            $0.setPretendardFont(text: "", size: 25.0, weight: .bold, letterSpacing: 1.37)
            
            $0.textAlignment = .center
        }
        label.alpha = 0
        let characters = Array(labelText)

        var index = 0
        var timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
          if index < characters.count {
            label.text?.append(characters[index])
            index += 1
          } else {
            timer.invalidate()
          }
        }
        UIView.animate(withDuration: 1.0) {
          label.alpha = 1.0
        }

        view.then {
          $0.addSubview(logoImageView)
          $0.addSubview(label)
        }
        label.snp.makeConstraints { make in
          make.centerX.equalToSuperview()
          
        }
        
        logoImageView.snp.makeConstraints { make in
          make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
          make.top.equalTo(label.snp.bottom).offset(20)
            make.width.height.equalTo(100)
        }
        
      }
}
