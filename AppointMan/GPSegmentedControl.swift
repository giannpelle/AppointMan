//
//  GPSegmentedControl.swift
//  GPCustomSegmentedControl
//
//  Created by Gianluigi Pelle on 8/31/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class GPSegmentedControl: UISegmentedControl {

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
      self.tintColor = UIColor.white
      self.layer.masksToBounds = true
      self.layer.cornerRadius = 5.0
      self.layer.borderColor = UIColor.white.cgColor
      self.layer.borderWidth = 1.0
      self.backgroundColor = UIColor.amBlue
      
      self.setup(withOptions: ["GIORNO", "MESE"])
   }
   
   func setup(withOptions options: [String]) {
      for (index, option) in options.enumerated() {
         self.setTitle(option, forSegmentAt: index)
      }
      
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 2.0
      style.alignment = .center
      self.setTitleTextAttributes([NSParagraphStyleAttributeName: style,
           NSKernAttributeName: 1.0,
           NSFontAttributeName: UIFont.init(name: "SFUIText-Bold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0),
           NSForegroundColorAttributeName: UIColor.white], for: .normal)
      self.setTitleTextAttributes([NSParagraphStyleAttributeName: style,
           NSKernAttributeName: 1.0,
           NSFontAttributeName: UIFont.init(name: "SFUIText-Bold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0),
           NSForegroundColorAttributeName: UIColor.amBlue], for: .selected)
      self.selectedSegmentIndex = 0
   }
}
