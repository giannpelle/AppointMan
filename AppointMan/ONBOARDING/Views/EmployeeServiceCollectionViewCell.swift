//
//  EmployeeServiceCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/22/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol EmployeeServiceCollectionViewCellDelegate: class {
   func didRemove(service: Service)
}

class EmployeeServiceCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var serviceLabel: UILabel!
   @IBOutlet weak var serviceLabelMaxWidthConstraint: NSLayoutConstraint!
   @IBOutlet weak var removeServiceButton: UIButton!
   
   weak var delegate: EmployeeServiceCollectionViewCellDelegate?
   
   var shadowLayer: CAShapeLayer?
   
   var service: Service! {
      didSet {
         if let serviceName = self.service.name {
            self.serviceLabel.attributedText = UILabel.attributedString(withText: serviceName, andTextColor: UIColor.grayWith(value: 182), andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         }
      }
   }
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.serviceLabelMaxWidthConstraint.constant = UIScreen.main.bounds.size.width - 42.0
      self.applyTypography()
      self.setupUI()
   }
   
   func drawBorder() {
      self.layer.masksToBounds = false
      
      if let sublayers = self.layer.sublayers {
         for layer in sublayers {
            if layer == self.shadowLayer {
               layer.removeFromSuperlayer()
            }
         }
      }
      
      if let shadowLayer = self.shadowLayer {
         let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.size.height / 2.0)
         shadowLayer.path = shadowPath.cgPath
         shadowLayer.frame = self.bounds
         self.layer.insertSublayer(shadowLayer, at: 0)
      } else {
         let shadowLayer = CAShapeLayer()
         shadowLayer.fillColor = UIColor.white.cgColor
         let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.size.height / 2.0)
         shadowLayer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
         shadowLayer.shadowOpacity = 0.25
         shadowLayer.shadowRadius = 5.0
         shadowLayer.shadowOffset = .zero
         shadowLayer.path = shadowPath.cgPath
         shadowLayer.frame = self.bounds
         self.shadowLayer = shadowLayer
         self.layer.insertSublayer(shadowLayer, at: 0)
      }
      
   }
   
   func applyTypography() {
      
   }
   
   func setupUI() {
      self.removeServiceButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)
      self.removeServiceButton.addTarget(self, action: #selector(self.removeServiceButtonPressed(sender:)), for: .touchUpInside)
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      self.drawBorder()
   }
   
   @objc func removeServiceButtonPressed(sender: UIButton) {
      self.delegate?.didRemove(service: self.service)
   }
}
