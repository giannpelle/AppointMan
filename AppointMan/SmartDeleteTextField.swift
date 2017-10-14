//
//  SmartDeleteTextField.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/31/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class SmartDeleteTextField: UITextField {
   
   var onDeleteKeyPressed: (() -> Void)?
   
   override func deleteBackward() {
      
      if let onDeleteKeyPressedClosure = self.onDeleteKeyPressed {
         onDeleteKeyPressedClosure()
      }
      
      super.deleteBackward()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
   }
   
   
   /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    // Drawing code
    }
   */
   
}
