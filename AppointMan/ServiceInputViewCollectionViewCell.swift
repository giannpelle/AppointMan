//
//  ServiceInputViewCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/21/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ServiceInputViewCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var serviceNameLabel: UILabel!
   @IBOutlet weak var serviceDurationLabel: UILabel!
   @IBOutlet weak var gendersStackView: UIStackView!
   
   lazy var selectionBorderLayer: CAShapeLayer = {
      let selectionBorderLayer = CAShapeLayer()
      selectionBorderLayer.fillColor = UIColor.clear.cgColor
      let selectionPath = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 0.0, dy: -1.0), cornerRadius: 5.0)
      selectionBorderLayer.path = selectionPath.cgPath
      selectionBorderLayer.strokeColor = UIColor.amBlue.cgColor
      selectionBorderLayer.lineWidth = 3.0
      selectionBorderLayer.frame = self.bounds
      
      let circleLayer = CAShapeLayer()
      circleLayer.fillColor = UIColor.amBlue.cgColor
      let circlePath = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 16.0))
      circleLayer.path = circlePath.cgPath
      circleLayer.frame = CGRect(x: self.bounds.size.width - 11.0, y: -4.0, width: 16.0, height: 16.0)
      
      let checkLayer = CAShapeLayer()
      checkLayer.fillColor = UIColor.clear.cgColor
      let checkPath = UIBezierPath()
      checkPath.move(to: CGPoint(x: 4.0, y: 7.0))
      checkPath.addLine(to: CGPoint(x: 7.0, y: 10.0))
      checkPath.addLine(to: CGPoint(x: 12.0, y: 5.0))
      checkLayer.path = checkPath.cgPath
      checkLayer.strokeColor = UIColor.white.cgColor
      checkLayer.lineWidth = 2.0
      checkLayer.frame = circleLayer.bounds
      circleLayer.addSublayer(checkLayer)
      
      let totalLayer = CAShapeLayer()
      totalLayer.addSublayer(selectionBorderLayer)
      totalLayer.addSublayer(circleLayer)
      
      return totalLayer
   }()
   
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
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.serviceNameLabel.attributedText = UILabel.attributedString(withText: "Nome servizio", andTextColor: ServiceColor.getRandomColor(dark: true), andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
      self.serviceNameLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
      
      self.serviceDurationLabel.attributedText = UILabel.attributedString(withText: "45 minuti", andTextColor:
         ServiceColor.getRandomColor(), andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
      self.serviceDurationLabel.heightAnchor.constraint(equalToConstant: 13.0).isActive = true
   }
   
   func setupUI() {
      
      let maleImageView = UIImageView(image: #imageLiteral(resourceName: "iconcina_sesso_uomo"))
      self.gendersStackView.addArrangedSubview(maleImageView)
   }
   
   func showSelectionBorderLayer() {
      self.layer.addSublayer(self.selectionBorderLayer)
   }
   
}
