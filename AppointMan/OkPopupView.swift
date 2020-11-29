//
//  OkPopupView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/23/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class OkPopupView: UIView {
   
   @IBOutlet weak var navigationBarView: UIView!
   @IBOutlet weak var popupTitleLabel: UILabel!
   @IBOutlet weak var closePopupButton: UIButton!
   @IBOutlet weak var popupMessageLabel: UILabel!
   @IBOutlet weak var okButton: UIButton!
   
   var onOkButtonPressed: (() -> Void)?
   var onDismissPopupView: (() -> Void)?
   
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
      // Drawing code
      
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
   
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.okButton.setAttributedTitle(UILabel.attributedString(withText: "OK", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
   }
   
   func setupUI() {
      self.navigationBarView.layer.roundCorners(corners: [.topLeft, .topRight], radius: 5.0, viewBounds: self.navigationBarView.bounds)
      self.okButton.layer.cornerRadius = 5.0
      self.okButton.addTarget(self, action: #selector(self.okButtonPressed(sender:)), for: .touchUpInside)
      self.closePopupButton.addTarget(self, action:#selector(self.closePopupButtonPressed(sender:)), for: .touchUpInside)
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      let shadowLayer = CAShapeLayer()
      shadowLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 5.0, height: 5.0)).cgPath
      shadowLayer.fillColor = UIColor.white.cgColor
      shadowLayer.shadowColor = UIColor.black.cgColor
      shadowLayer.shadowOffset = CGSize.zero
      shadowLayer.shadowRadius = 16.0
      shadowLayer.shadowOpacity = 0.45
      self.layer.insertSublayer(shadowLayer, at: 0)
      self.layer.cornerRadius = 5.0
   }
   
   func setupPopupMessage(withTitle title: String, andMessage message: String) {
      self.popupTitleLabel.attributedText = UILabel.attributedString(withText: title, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
      self.popupMessageLabel.attributedText = UILabel.attributedString(withText: message, andTextColor: UIColor.grayWith(value: 75), andFont: UIFont.init(name: "SFUIText-Regular", size: 13.0)!, andCharacterSpacing: 0.0, isCentered: true)
   }
   
   @objc func okButtonPressed(sender: UIButton) {
      if let onOkButtonPressed = self.onOkButtonPressed {
         onOkButtonPressed()
      }
      self.removeFromSuperview()
   }
   
   @objc func closePopupButtonPressed(sender: UIButton) {
      if let onDismissPopupView = self.onDismissPopupView {
         onDismissPopupView()
      }
      self.removeFromSuperview()
   }
   
}
