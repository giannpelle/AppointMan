//
//  AppointmentView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/25/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class AppointmentView: UIView {
   
   @IBOutlet weak var timeLabel: UILabel!
   @IBOutlet weak var serviceLabel: UILabel!
   @IBOutlet weak var customerLabel: UILabel!
   //@IBOutlet weak var appointmentDescriptionLabel: UILabel!
   
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
      // Drawing code
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      
   }
   
}
