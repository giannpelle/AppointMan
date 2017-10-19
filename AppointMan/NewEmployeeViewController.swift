//
//  NewEmployeeViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/19/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class NewEmployeeViewController: UIViewController {
   
   @IBOutlet weak var newEmployeeLabel: UILabel!
   @IBOutlet weak var employeeImageView: UIImageView!
   @IBOutlet weak var employeeFirstNameFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeLastNameFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeCellPhoneNumberFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeEmailFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeWorkingHoursLabel: UILabel!
   @IBOutlet weak var addEmployeeWorkingHoursButton: UIButton!
   @IBOutlet weak var servicesLabel: UILabel!
   @IBOutlet weak var saveButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.newEmployeeLabel.attributedText = UILabel.attributedString(withText: "NUOVO DIPENDENTE", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
      self.employeeWorkingHoursLabel.attributedText = UILabel.attributedString(withText: "ORARIO DI LAVORO", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.addEmployeeWorkingHoursButton.setAttributedTitle(UILabel.attributedString(withText: "SELEZIONA ORARIO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
      self.servicesLabel.attributedText = UILabel.attributedString(withText: "SERVIZI", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.saveButton.setAttributedTitle(UILabel.attributedString(withText: "SALVA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 16.0)!, andCharacterSpacing: 1.14, isCentered: true), for: .normal)
   }
   
   func setupUI() {
      self.employeeImageView.layer.cornerRadius = self.employeeImageView.bounds.size.width / 2.0
      self.employeeFirstNameFloatingTextField.setPlaceholderText(placeholderText: "Nome")
      self.employeeLastNameFloatingTextField.setPlaceholderText(placeholderText: "Cognome")
      self.employeeCellPhoneNumberFloatingTextField.setPlaceholderText(placeholderText: "Telefono")
      self.employeeEmailFloatingTextField.setPlaceholderText(placeholderText: "Email")
      self.addEmployeeWorkingHoursButton.layer.cornerRadius = 5.0
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      self.view.endEditing(true)
   }
   
}
