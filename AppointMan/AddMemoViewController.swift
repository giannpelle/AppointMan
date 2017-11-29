//
//  AddMemoViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/29/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class AddMemoViewController: UIViewController {
   
   @IBOutlet weak var addMemoLabel: UILabel!
   @IBOutlet weak var isFavoriteButton: UIButton!
   @IBOutlet weak var memoTextView: PlaceholderTextView!
   @IBOutlet weak var notificationLabel: UILabel!
   @IBOutlet weak var setNotificationButton: UIButton!
   @IBOutlet weak var notificationButton: UIButton!
   @IBOutlet weak var saveButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.addMemoLabel.attributedText = UILabel.attributedString(withText: "AGGIUNGI MEMO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
      self.isFavoriteButton.setAttributedTitle(UILabel.attributedString(withText: "In evidenza", andTextColor: UIColor.grayWith(value: 152.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: 0.0), for: .normal)
      self.notificationLabel.attributedText = UILabel.attributedString(withText: "NOTIFICA", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.setNotificationButton.setAttributedTitle(UILabel.attributedString(withText: "IMPOSTA NOTIFICA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0), for: .normal)
      //self.notificationButton.setAttributedTitle(UILabel.attributedString(withText: <#T##String#>, andTextColor: <#T##UIColor#>, andFont: <#T##UIFont#>, andCharacterSpacing: <#T##CGFloat?#>), for: <#T##UIControlState#>)
      //self.saveButton.setAttributedTitle(UILabel.attributedString(withText: "SALVA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-", size: <#T##CGFloat#>), andCharacterSpacing: <#T##CGFloat?#>), for: <#T##UIControlState#>)
   }
   
   func setupUI() {
      self.memoTextView.layer.borderWidth = 2.0
      self.memoTextView.layer.borderColor = UIColor.grayWith(value: 243.0).cgColor
      self.memoTextView.placeholder = "Scrivi qualcosa..."
      self.setNotificationButton.layer.cornerRadius = 5.0
      self.notificationButton.isHidden = true
   }
   
   @IBAction func closeButtonPressed(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
   
}
