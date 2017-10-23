//
//  ColorPickerView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/23/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ColorPickerView: UIView {
   
   @IBOutlet weak var serviceColorLabel: UILabel!
   @IBOutlet weak var firstColorsStackView: UIStackView!
   @IBOutlet weak var secondColorsStackView: UIStackView!
   
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      let cornerRadius: CGFloat = 8.0
      let arrowIndicatorHeight: CGFloat = 8.0
      let arrowIndicatorWidth: CGFloat = 12.0
      let arrowIndicatorPinX: CGFloat = 25.0
      
      self.clipsToBounds = false
      
      let popoverMaskLayer = CAShapeLayer()
      popoverMaskLayer.fillColor = UIColor.white.cgColor
      
      let maskPath = UIBezierPath()
      maskPath.move(to: CGPoint(x: 0.0, y: arrowIndicatorHeight + cornerRadius))
      maskPath.addArc(withCenter: CGPoint(x: cornerRadius, y: arrowIndicatorHeight + cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 3/2.0), clockwise: true)
      maskPath.addLine(to: CGPoint(x: arrowIndicatorPinX - (arrowIndicatorWidth / 2.0), y: arrowIndicatorHeight))
      maskPath.addLine(to: CGPoint(x: arrowIndicatorPinX, y: 0.0))
      maskPath.addLine(to: CGPoint(x: arrowIndicatorPinX + (arrowIndicatorWidth / 2.0), y: arrowIndicatorHeight))
      maskPath.addLine(to: CGPoint(x: rect.size.width - cornerRadius, y: arrowIndicatorHeight))
      maskPath.addArc(withCenter: CGPoint(x: rect.size.width - cornerRadius, y: arrowIndicatorHeight + cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi * 3/2.0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
      maskPath.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height - cornerRadius))
      maskPath.addArc(withCenter: CGPoint(x: rect.size.width - cornerRadius, y: rect.size.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat(0.0), endAngle: CGFloat(Double.pi / 2.0), clockwise: true)
      maskPath.addLine(to: CGPoint(x: cornerRadius, y: rect.size.height))
      maskPath.addArc(withCenter: CGPoint(x: cornerRadius, y: rect.size.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi / 2.0), endAngle: CGFloat(Double.pi), clockwise: true)
      maskPath.close()
      
      popoverMaskLayer.path = maskPath.cgPath
      popoverMaskLayer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      popoverMaskLayer.shadowOpacity = 0.25
      popoverMaskLayer.shadowRadius = 6.0
      popoverMaskLayer.shadowOffset = .zero
      
      self.layer.insertSublayer(popoverMaskLayer, at: 0)
      
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.serviceColorLabel.attributedText = UILabel.attributedString(withText: "COLORE SERVIZIO", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.serviceColorLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
   }
   
   func setupUI() {
      if let firstColorButtons = self.firstColorsStackView.arrangedSubviews as? [UIButton] {
         for (index, colorButton) in firstColorButtons.enumerated() {
            colorButton.clipsToBounds = true
            colorButton.setBackgroundColor(color: ServiceColor(rawValue: index)!.getColor(), forState: .normal)
            colorButton.layer.cornerRadius = colorButton.bounds.size.width / 2.0
         }
      }
      if let secondColorButtons = self.secondColorsStackView.arrangedSubviews as? [UIButton] {
         for (index, colorButton) in secondColorButtons.enumerated() {
            colorButton.clipsToBounds = true
            colorButton.setBackgroundColor(color: ServiceColor(rawValue: index + 10)!.getColor(), forState: .normal)
            colorButton.layer.cornerRadius = colorButton.bounds.size.width / 2.0
         }
      }
   }
   
}
