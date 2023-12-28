//
//  UIColor++.swift
//  CoPro
//
//  Created by 박신영 on 10/10/23.
//

import UIKit

enum AssetsColor {
  // placeHolderBackgroundColor
  case placeHolderBackgroundColor
    
  // placeHolderColor
  case placeHolderColor
  
}

extension UIColor {
    // 두 가지 방법 사용 가능, 나중에 보고 편한거로 결정
    static func appColor(_ name: AssetsColor) -> UIColor {
      switch name {
      case .placeHolderBackgroundColor:
        return #colorLiteral(red: 0.937, green: 0.937, blue: 0.937, alpha: 1)
      case .placeHolderColor:
        return #colorLiteral(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
      }
    }
    
    static var primary = UIColor(red: 91/255, green: 156/255, blue: 203/255, alpha: 1)
    /// 연한 회색
    static var incomingMessageBackground = UIColor(red: 98/255, green: 98/255, blue: 98/255, alpha: 1)
    
    /// Color Picker 에서 UIColor 를 고르면 Hex String 으로 변환한다.
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    /// Hex Code 를 입력하면 UIColor 로 반환한다.
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}

