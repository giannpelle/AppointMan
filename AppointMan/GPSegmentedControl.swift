//
//  GPSegmentedControl.swift
//  GPCustomSegmentedControl
//
//  Created by Gianluigi Pelle on 8/31/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

extension UISegmentedControl {
   
   func onBoardingSetUp(withOptions options: [String]) {
      self.tintColor = UIColor.amBlue
      self.layer.masksToBounds = false
      self.clipsToBounds = false
      self.layer.cornerRadius = 5.0
      
      self.setup(withOptions: options)
   }
   
   func setup(withOptions options: [String]) {
      for (index, option) in options.enumerated() {
         self.setTitle(option, forSegmentAt: index)
      }
      
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 2.0
      style.alignment = .center
      self.setTitleTextAttributes([NSAttributedStringKey.paragraphStyle: style,
                                   NSAttributedStringKey.kern: 1.0,
                                   NSAttributedStringKey.font: UIFont.init(name: "SFUIText-Bold", size: 10.0)!,
                                   NSAttributedStringKey.foregroundColor: UIColor.amBlue], for: .normal)
      self.setTitleTextAttributes([NSAttributedStringKey.paragraphStyle: style,
                                   NSAttributedStringKey.kern: 1.0,
                                   NSAttributedStringKey.font: UIFont.init(name: "SFUIText-Bold", size: 10.0)!,
                                   NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
      self.selectedSegmentIndex = 0
   }

}
