//
//  AppointmentBox.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 6/4/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class AppointmentBox: UIView {
   
   @IBOutlet weak var appointmentAccessoryView: UIView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.layer.cornerRadius = 4.0
      self.clipsToBounds = true
      
   }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
