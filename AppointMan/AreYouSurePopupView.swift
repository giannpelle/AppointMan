//
//  AreYouSurePopupView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/3/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class AreYouSurePopupView: UIView {
   
   @IBOutlet weak var navigationBarView: UIView!
   @IBOutlet weak var popupTitleLabel: UILabel!
   @IBOutlet weak var closePopupButton: UIButton!
   @IBOutlet weak var popupMessageLabel: UILabel!
   @IBOutlet weak var confirmButton: UIButton!
   @IBOutlet weak var cancelButton: UIButton!
   
   var onConfirmButtonPressed: (() -> Void)?
   var onDismissPopupView: (() -> Void)?
   
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
      // Drawing code
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.setupUI()
   }
   
   func setupUI() {
      self.navigationBarView.layer.roundCorners(corners: [.topLeft, .topRight], radius: 5.0, viewBounds: self.navigationBarView.bounds)
      self.confirmButton.layer.cornerRadius = 5.0
      self.confirmButton.addTarget(self, action: #selector(self.confirmButtonPressed(sender:)), for: .touchUpInside)
      self.cancelButton.layer.cornerRadius = 5.0
      self.cancelButton.addTarget(self, action: #selector(self.closePopupButtonPressed(sender:)), for: .touchUpInside)
      self.closePopupButton.addTarget(self, action:#selector(self.closePopupButtonPressed(sender:)), for: .touchUpInside)
   }
   
   func setupPopupMessage(withTitle title: String, andMessage message: String, andConfirmText confirmText: String) {
      self.popupTitleLabel.attributedText = UILabel.attributedString(withText: title, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
      self.popupMessageLabel.attributedText = UILabel.attributedString(withText: message, andTextColor: UIColor.grayWith(value: 75), andFont: UIFont.init(name: "SFUIText-Regular", size: 13.0)!, andCharacterSpacing: 0.0, isCentered: true)
      
      self.cancelButton.setAttributedTitle(UILabel.attributedString(withText: "ANNULLA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
      self.confirmButton.setAttributedTitle(UILabel.attributedString(withText: confirmText, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
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
   
   @objc func confirmButtonPressed(sender: UIButton) {
      if let onConfirmButtonPressed = self.onConfirmButtonPressed {
         onConfirmButtonPressed()
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
