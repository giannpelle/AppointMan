//
//  GPSegmentedControl.swift
//  GPCustomSegmentedControl
//
//  Created by Gianluigi Pelle on 8/31/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

extension UISegmentedControl {
   
   func setup(withOptions options: [String], isBlueBackground: Bool) {
      
      self.tintColor = isBlueBackground ? UIColor.white : UIColor.amBlue
      self.layer.masksToBounds = true
      self.layer.cornerRadius = self.bounds.size.height / 2.0
      self.layer.borderColor = isBlueBackground ? UIColor.white.cgColor : UIColor.amBlue.cgColor
      self.layer.borderWidth = 1.0
      self.backgroundColor = isBlueBackground ? UIColor.amBlue : UIColor.white
      
      for (index, option) in options.enumerated() {
         self.setTitle(option, forSegmentAt: index)
      }
      
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 2.0
      style.alignment = .center
      self.setTitleTextAttributes([NSAttributedStringKey.paragraphStyle: style,
                                   NSAttributedStringKey.kern: 1.0,
                                   NSAttributedStringKey.font: UIFont.init(name: "SFUIText-Bold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0),
                                   NSAttributedStringKey.foregroundColor: isBlueBackground ? UIColor.white : UIColor.amBlue], for: .normal)
      self.setTitleTextAttributes([NSAttributedStringKey.paragraphStyle: style,
                                   NSAttributedStringKey.kern: 1.0,
                                   NSAttributedStringKey.font: UIFont.init(name: "SFUIText-Bold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0),
                                   NSAttributedStringKey.foregroundColor: isBlueBackground ? UIColor.amBlue : UIColor.white], for: .selected)
      self.selectedSegmentIndex = 0
   }

}
