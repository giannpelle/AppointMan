//
//  NewServiceViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/10/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class NewServiceViewController: UIViewController {
   
   @IBOutlet weak var newServiceLabel: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
   }
   
   func applyTypography() {
      self.newServiceLabel.attributedText = UILabel.attributedString(withText: "NUOVO SERVIZIO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
   }
   
   
}
