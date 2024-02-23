//
//  UISegmented++.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
  private lazy var underlineView: UIView = {
    let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
    let height = 2.0
    let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
    let yPosition = self.bounds.size.height - 1.0
    let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
    let view = UIView(frame: frame)
      view.backgroundColor = UIColor.P2()
    self.addSubview(view)
    return view
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.removeBackgroundAndDivider()
  }
  override init(items: [Any]?) {
    super.init(items: items)
    self.removeBackgroundAndDivider()
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func removeBackgroundAndDivider() {
      let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
          UIColor.clear.set()  // 투명한 색상을 설정합니다.
          UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))  // 색상으로 1x1 크기의 사각형을 채웁니다.
      }
    self.setBackgroundImage(image, for: .normal, barMetrics: .default)
    self.setBackgroundImage(image, for: .selected, barMetrics: .default)
    self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
    
    self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
    UIView.animate(
      withDuration: 0.1,
      animations: {
                  self.underlineView.frame.origin.x = underlineFinalXPosition
      }
    )
  }
}
