//
//  EmployeeServiceCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/22/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class EmployeeServiceCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var serviceLabel: UILabel!
   @IBOutlet weak var removeServiceButton: UIButton!
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      self.layer.masksToBounds = false
      let shadowLayer = CAShapeLayer()
      shadowLayer.fillColor = UIColor.white.cgColor
      let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.size.height / 2.0)
      shadowLayer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      shadowLayer.shadowOpacity = 0.25
      shadowLayer.shadowRadius = 5.0
      shadowLayer.shadowOffset = .zero
      shadowLayer.path = shadowPath.cgPath
      shadowLayer.frame = self.bounds
      self.layer.insertSublayer(shadowLayer, at: 0)
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.serviceLabel.attributedText = UILabel.attributedString(withText: "Shatush", andTextColor: UIColor.grayWith(value: 182), andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
   }
   
   func setupUI() {
      self.removeServiceButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)
   }
}
