//
//  ClientiViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/13/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ClientiViewController: UIViewController {
   
   @IBOutlet weak var customersLabel: UILabel!
   
   weak var revealMenuDelegate: RevealMenuDelegate?

   override func viewDidLoad() {
      super.viewDidLoad()

      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.customersLabel.attributedText = UILabel.attributedString(withText: "Clienti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
   }
   
   func setupUI() {
      
   }
   
   @IBAction func hamburgerMenuButtonPressed(sender: UIButton) {
      self.revealMenuDelegate?.openRevealMenu()
   }

}
