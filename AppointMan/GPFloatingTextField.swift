//
//  GPFloatingTextField.swift
//  GPFloatingTextField
//
//  Created by Gianluigi Pelle on 8/27/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

// You'll have 14 pixels on top and 3 pixels on bottom, the height of textRect is the difference

class GPFloatingTextField: UITextField {
   
   var underlineLayer: CALayer!
   var titleHeaderLabel: UILabel!
   var titleHeaderLabelTopAnchor: NSLayoutConstraint!
   
   lazy var textAttributes: [String: Any] = {
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 14.0
      style.alignment = .natural
      let attributes: [String: Any] = [NSAttributedStringKey.paragraphStyle.rawValue: style, NSAttributedStringKey.kern.rawValue: 0.0, NSAttributedStringKey.font.rawValue: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, NSAttributedStringKey.foregroundColor.rawValue: UIColor.amFloatingTextFieldText]
      return attributes
   }()
   
   override var isEditing: Bool {
      get {
         self.typingAttributes = self.textAttributes
         if let text = self.attributedText, text.string != "" {
            self.showTitleHeaderLabel()
         } else {
            self.hideTitleHeaderLabel()
         }
         return super.isEditing
      }
   }

   override func textRect(forBounds bounds: CGRect) -> CGRect {
      return CGRect(x: bounds.origin.x + 1, y: bounds.origin.y + 14.0, width: bounds.size.width - 1.0, height: bounds.size.height - (14.0 + 3.0))
   }
   
   override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return CGRect(x: bounds.origin.x + 1, y: bounds.origin.y + 14.0, width: bounds.size.width - 1.0, height: bounds.size.height - (14.0 + 3.0))
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
      
      // to avoid auto layout conflicts, really strange, test on real device uncommenting the following lines of code
      self.autocorrectionType = .no
      self.inputAssistantItem.leadingBarButtonGroups.removeAll()
      self.inputAssistantItem.trailingBarButtonGroups.removeAll()
      
      self.borderStyle = .none
      
      self.underlineLayer = CALayer()
      self.underlineLayer.frame = CGRect(x: 0.0, y: self.bounds.size.height - 2.0, width: self.bounds.size.width, height: 2.0)
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
      self.titleHeaderLabel.heightAnchor.constraint(equalToConstant: 13.0).isActive = true
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
