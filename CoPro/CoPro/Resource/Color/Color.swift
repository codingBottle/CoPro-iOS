//
//  Colors.swift
//  CoPro
//
//  Created by 박현렬 on 1/30/24.
//

import UIKit

extension UIColor {
    // Hex color 코드를 UIColor로 변환하는 메서드
    convenience init(fromHex: String, alpha: CGFloat = 1.0) {
        let v = fromHex.map { String($0) } + Array(repeating: "0", count: max(6 - fromHex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    static func Black(alpha: CGFloat = 1.0) -> UIColor {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor.white.withAlphaComponent(alpha)
                } else {
                    return UIColor.black.withAlphaComponent(alpha)
                }
            }
        }
    static func White(alpha: CGFloat = 1.0) -> UIColor {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor.black.withAlphaComponent(alpha)
                } else {
                    return UIColor.white.withAlphaComponent(alpha)
                }
            }
        }
    static func G1(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "D1D1D2", alpha: alpha)
    }
    static func G2(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "ACACAE", alpha: alpha)
    }
    static func G3(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "949598", alpha: alpha)
    }
    static func G4(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "6D6E72", alpha: alpha)
    }
    static func G5(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "363637", alpha: alpha)
    }
    static func G6(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "121213", alpha: alpha)
    }
    static func L1(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "F5F6F8", alpha: alpha)
    }
    static func L2(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "E6E9ED", alpha: alpha)
    }
    static func L3(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "DEE2E8", alpha: alpha)
    }
    static func P1(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "FA2925", alpha: alpha)
    }
    static func P2(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "2577FE", alpha: alpha)
    }
    static func P3(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "687794", alpha: alpha)
    }
    static func P4(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "3532DC", alpha: alpha)
    }
    static func P5(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "0300A8", alpha: alpha)
    }
    static func P6(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "04028A", alpha: alpha)
    }
    static func P7(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(fromHex: "B5C4DD", alpha: alpha)
    }
}
