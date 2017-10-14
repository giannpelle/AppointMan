//
//  GPFloatingTextField.swift
//  GPFloatingTextField
//
//  Created by Gianluigi Pelle on 8/27/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class GPFloatingTextField: UITextField {
   
   var underlineLayer: CALayer!
   var titleHeaderLabel: UILabel!
   var titleHeaderLabelTopAnchor: NSLayoutConstraint!
   
   override var attributedText: NSAttributedString? {
      get {
         if let text = super.attributedText, text.string != "" {
            self.showTitleHeaderLabel()
         } else {
            self.hideTitleHeaderLabel()
         }
         return super.attributedText
      }
      set {
         self.attributedText = newValue
      }
   }
   
   lazy var textAttributes: [String: Any] = {
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 14.0
      style.alignment = .natural
      let attributes: [String: Any] = [NSParagraphStyleAttributeName: style, NSKernAttributeName: 0.0, NSFontAttributeName: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, NSForegroundColorAttributeName: UIColor.amFloatingTextFieldText]
      return attributes
   }()
   
   override var isEditing: Bool {
      get {
         self.typingAttributes = self.textAttributes
         return super.isEditing
      }
   }

   override func textRect(forBounds bounds: CGRect) -> CGRect {
      return CGRect(x: bounds.origin.x + 1, y: bounds.origin.y + 14.0, width: bounds.size.width - 1.0, height: bounds.size.height - (14.0 + 4.0))
   }
   
   override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return CGRect(x: bounds.origin.x + 1, y: bounds.origin.y + 14.0, width: bounds.size.width - 1.0, height: bounds.size.height - (14.0 + 4.0))
   }
   
   init() {
      super.init(frame: CGRect.zero)
      self.setup()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.setup()
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.setup()
   }
   
   private func setup() {
      self.borderStyle = .none
      
      self.underlineLayer = CALayer()
      self.underlineLayer.frame = CGRect(x: 0.0, y: self.bounds.size.height - 3.0, width: self.bounds.size.width, height: 2.0)
      self.underlineLayer.backgroundColor = UIColor.amLightGray.cgColor
      self.layer.insertSublayer(self.underlineLayer, at: 1)
      
      self.titleHeaderLabel = UILabel()
      self.titleHeaderLabel.alpha = 0.0
      self.addSubview(self.titleHeaderLabel)
      self.titleHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
      self.titleHeaderLabelTopAnchor = self.titleHeaderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 21.0)
      self.titleHeaderLabelTopAnchor.isActive = true
      self.titleHeaderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1.0).isActive = true
   }
   
   func setPlaceholderText(placeholderText: String) {
      self.attributedPlaceholder = UILabel.attributedString(withText: placeholderText, andTextColor: UIColor.amFloatingTextFieldPlaceholderText, andFont: UIFont.init(name: "SFUIText-Regular", size: 14)!, andCharacterSpacing: nil)
      self.titleHeaderLabel.attributedText = UILabel.attributedString(withText: placeholderText, andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 11)!, andCharacterSpacing: 0.2)
      self.titleHeaderLabel.setLineHeightInset(2.0)
   }
   
   private func showTitleHeaderLabel() {
      self.titleHeaderLabelTopAnchor.constant = 0.0
      UIView.animate(withDuration: 0.7, animations: { 
         self.titleHeaderLabel.alpha = 1.0
         self.layoutIfNeeded()
      }) { (success) in
         
      }
   }
   
   private func hideTitleHeaderLabel() {
      self.titleHeaderLabelTopAnchor.constant = 21.0
      UIView.animate(withDuration: 0.7, animations: {
         self.titleHeaderLabel.alpha = 0.0
         self.layoutIfNeeded()
      }) { (success) in
         
      }
   }
}
