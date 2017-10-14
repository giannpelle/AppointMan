//
//  TagsTextField.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/24/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit

class TagsTextField: UIView {
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      let bottomBorderLine = CALayer()
      bottomBorderLine.frame = CGRect(x: 0.0, y: self.bounds.size.height - 1, width: UIScreen.main.bounds.size.width / 2.0 - 18.0 - 76.0, height: 1.0)
      bottomBorderLine.backgroundColor = UIColor.orange.cgColor
      self.layer.addSublayer(bottomBorderLine)
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      let bottomBorderLine = CALayer()
      bottomBorderLine.frame = CGRect(x: 0.0, y: self.bounds.size.height - 1, width: UIScreen.main.bounds.size.width / 2.0 - 18.0 - 76.0, height: 1.0)
      bottomBorderLine.backgroundColor = UIColor.orange.cgColor
      self.layer.addSublayer(bottomBorderLine)
   }
   
   
}
