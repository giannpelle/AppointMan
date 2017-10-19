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
   @IBOutlet weak var serviceColorButton: UIButton!
   @IBOutlet weak var serviceNameTextField: GPFloatingTextField!
   @IBOutlet weak var durationLabel: UILabel!
   @IBOutlet weak var manBoxView: UIView!
   @IBOutlet weak var manLabel: UILabel!
   @IBOutlet weak var manCheckboxButton: UIButton!
   @IBOutlet weak var manDurationPickerView: UIPickerView!
   @IBOutlet weak var womanBoxView: UIView!
   @IBOutlet weak var womanLabel: UILabel!
   @IBOutlet weak var womanCheckboxButton: UIButton!
   @IBOutlet weak var womanDurationPickerView: UIPickerView!
   
   var isManBoxEnabled: Bool = false {
      didSet {
         self.manCheckboxButton.isSelected = self.isManBoxEnabled
         self.manLabel.attributedText = UILabel.attributedString(withText: "UOMO", andTextColor: self.isManBoxEnabled ? UIColor.amBlue : UIColor.grayWith(value: 214), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
         self.manLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
         self.manDurationPickerView.isUserInteractionEnabled = self.isManBoxEnabled
         self.manDurationPickerView.reloadAllComponents()
      }
   }
   var isWomanBoxEnabled: Bool = false {
      didSet {
         self.womanCheckboxButton.isSelected = self.isWomanBoxEnabled
         self.womanLabel.attributedText = UILabel.attributedString(withText: "DONNA", andTextColor: self.isWomanBoxEnabled ? UIColor.amBlue : UIColor.grayWith(value: 214), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
         self.womanLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
         self.womanDurationPickerView.isUserInteractionEnabled = self.isWomanBoxEnabled
         self.womanDurationPickerView.reloadAllComponents()
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.newServiceLabel.attributedText = UILabel.attributedString(withText: "NUOVO SERVIZIO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.newServiceLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
      
      self.durationLabel.attributedText = UILabel.attributedString(withText: "DURATA", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.durationLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
      
      self.manLabel.attributedText = UILabel.attributedString(withText: "UOMO", andTextColor: UIColor.grayWith(value: 214), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.manLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
      
      self.womanLabel.attributedText = UILabel.attributedString(withText: "DONNA", andTextColor: UIColor.grayWith(value: 214), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.womanLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
      
   }
   
   func setupUI() {
      self.serviceColorButton.layer.cornerRadius = self.serviceColorButton.bounds.size.height / 2.0
      self.serviceColorButton.addTarget(self, action: #selector(self.openColorPicker), for: .touchUpInside)

      self.serviceNameTextField.setPlaceholderText(placeholderText: "Nome servizio")
      
      let manTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.manBoxViewTapped(sender:)))
      self.manBoxView.addGestureRecognizer(manTapGesture)
      
      let womanTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.womanBoxViewTapped(sender:)))
      self.womanBoxView.addGestureRecognizer(womanTapGesture)
      
      self.manBoxView.layer.cornerRadius = 5.0
      self.manBoxView.layer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      self.manBoxView.layer.shadowOpacity = 0.25
      self.manBoxView.layer.shadowRadius = 6.0
      self.manBoxView.layer.shadowOffset = .zero
      
      self.womanBoxView.layer.cornerRadius = 5.0
      self.womanBoxView.layer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      self.womanBoxView.layer.shadowOpacity = 0.25
      self.womanBoxView.layer.shadowRadius = 6.0
      self.womanBoxView.layer.shadowOffset = .zero
      
      self.manCheckboxButton.layer.cornerRadius = self.manCheckboxButton.bounds.size.width / 2.0
      self.manCheckboxButton.setImage(#imageLiteral(resourceName: "uncheck_24"), for: .normal)
      self.manCheckboxButton.setImage(#imageLiteral(resourceName: "check_24"), for: .selected)
      
      self.womanCheckboxButton.layer.cornerRadius = self.womanCheckboxButton.bounds.size.width / 2.0
      self.womanCheckboxButton.setImage(#imageLiteral(resourceName: "uncheck_24"), for: .normal)
      self.womanCheckboxButton.setImage(#imageLiteral(resourceName: "check_24"), for: .selected)
      
      let manSeparatorLineLayer = CALayer()
      manSeparatorLineLayer.frame = CGRect(x: 0.0, y: 40.0, width: self.manBoxView.bounds.size.width, height: 1.0)
      manSeparatorLineLayer.backgroundColor = UIColor.grayWith(value: 188).cgColor
      self.manBoxView.layer.insertSublayer(manSeparatorLineLayer, at: 0)
      
      let womanSeparatorLineLayer = CALayer()
      womanSeparatorLineLayer.frame = CGRect(x: 0.0, y: 40.0, width: self.womanBoxView.bounds.size.width, height: 1.0)
      womanSeparatorLineLayer.backgroundColor = UIColor.grayWith(value: 188).cgColor
      self.womanBoxView.layer.insertSublayer(womanSeparatorLineLayer, at: 0)
      
      self.manDurationPickerView.tag = 0
      self.manDurationPickerView.isUserInteractionEnabled = false
      self.manDurationPickerView.dataSource = self
      self.manDurationPickerView.delegate = self
      self.manDurationPickerView.selectRow(30, inComponent: 2, animated: false)
      
      self.womanDurationPickerView.tag = 1
      self.womanDurationPickerView.isUserInteractionEnabled = false
      self.womanDurationPickerView.dataSource = self
      self.womanDurationPickerView.delegate = self
      self.womanDurationPickerView.selectRow(30, inComponent: 2, animated: false)
      
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      self.view.endEditing(true)
   }
   
   @IBAction func closeButtonPressed(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
   @objc func openColorPicker() {
      
   }
   
   @objc func manBoxViewTapped(sender: UITapGestureRecognizer) {
      guard self.isManBoxEnabled == false else {
         return
      }
      
      self.isManBoxEnabled = true
   }
   
   @objc func womanBoxViewTapped(sender: UITapGestureRecognizer) {
      guard self.isWomanBoxEnabled == false else {
         return
      }
      
      self.isWomanBoxEnabled = true
   }
   
   @IBAction func manCheckboxButtonPressed(sender: UIButton) {
      self.isManBoxEnabled = !self.isManBoxEnabled
   }
   
   @IBAction func womanCheckboxButtonPressed(sender: UIButton) {
      self.isWomanBoxEnabled = !self.isWomanBoxEnabled
   }
   
}

extension NewServiceViewController: UIGestureRecognizerDelegate {
   
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
   }
}

extension NewServiceViewController: UIPickerViewDataSource {
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 4
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch component {
      case 0:
         return 15
      case 1:
         return 1
      case 2:
         return 60
      case 3:
         return 1
      default:
         return 0
      }
   }
   
   func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return 30.0
   }
   
   func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
      switch component {
      case 1, 3:
         return 48.0
      default:
         return 40.0
      }
   }
   
   func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
      if pickerView.tag == 0 {
         if component == 1 { return NSAttributedString(string: "h", attributes: [NSAttributedStringKey.foregroundColor : self.isManBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)]) }
         if component == 3 { return NSAttributedString(string: "min", attributes: [NSAttributedStringKey.foregroundColor : self.isManBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)]) }
         return NSAttributedString(string: "\(row)", attributes: [NSAttributedStringKey.foregroundColor : self.isManBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)])
      } else {
         if component == 1 { return NSAttributedString(string: "h", attributes: [NSAttributedStringKey.foregroundColor : self.isWomanBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)]) }
         if component == 3 { return NSAttributedString(string: "min", attributes: [NSAttributedStringKey.foregroundColor : self.isWomanBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)]) }
         return NSAttributedString(string: "\(row)", attributes: [NSAttributedStringKey.foregroundColor : self.isWomanBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)])
      }
   }

}

extension NewServiceViewController: UIPickerViewDelegate {
   
}
