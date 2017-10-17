//
//  ServiceCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/14/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var serviceNameLabel: UILabel!
   @IBOutlet weak var serviceDurationLabel: UILabel!
   @IBOutlet weak var gendersStackView: UIStackView!
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      self.contentView.layer.masksToBounds = false
      self.layer.masksToBounds = false
      
      // drawing the shadow
      let shadowLayer = CAShapeLayer()
      shadowLayer.fillColor = UIColor.white.cgColor
      let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
      shadowLayer.path = path
      shadowLayer.frame = self.bounds
      shadowLayer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      shadowLayer.shadowOpacity = 0.25
      shadowLayer.shadowRadius = 6.0
      shadowLayer.shadowOffset = .zero
      self.layer.insertSublayer(shadowLayer, at: 0)
   
      // drawing the accessory rect
      let leadingAccessoryRectLayer = CAShapeLayer()
      let leadingAccessoryRectPath = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: 3.0, height: rect.size.height))
      leadingAccessoryRectLayer.fillColor = ServiceColor.getRandomColor(dark: true).cgColor
      leadingAccessoryRectLayer.path = leadingAccessoryRectPath.cgPath
      leadingAccessoryRectLayer.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: self.bounds.size.height)
      self.layer.addSublayer(leadingAccessoryRectLayer)
      
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.serviceNameLabel.attributedText = UILabel.attributedString(withText: "Nome servizio", andTextColor: ServiceColor.getRandomColor(dark: true), andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
      self.serviceDurationLabel.attributedText = UILabel.attributedString(withText: "45 minuti", andTextColor: ServiceColor.getRandomColor(), andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
      
      let maleImageView = UIImageView(image: #imageLiteral(resourceName: "iconcina_sesso_uomo"))
      self.gendersStackView.addArrangedSubview(maleImageView)
      
      
      
   }
   
}
