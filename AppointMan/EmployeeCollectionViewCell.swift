//
//  EmployeeCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/19/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol EmployeeCollectionViewCellDelegate: class {
   func editEmployee(employee: Employee)
}

class EmployeeCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var employeeImageView: UIImageView!
   @IBOutlet weak var employeeFullNameLabel: UILabel!
   @IBOutlet weak var employeeCellPhoneNumberLabel: UILabel!
   @IBOutlet weak var employeeEmailLabel: UILabel!
   @IBOutlet weak var workingHoursStackView: UIStackView!
   @IBOutlet weak var employeeServicesLabel: UILabel!
   
   weak var delegate: EmployeeCollectionViewCellDelegate?
   
   var employee: Employee? {
      didSet {
         self.loadEmployeeData()
      }
   }
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      self.layer.masksToBounds = false
      let shadowLayer = CAShapeLayer()
      shadowLayer.fillColor = UIColor.white.cgColor
      let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5.0)
      shadowLayer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      shadowLayer.shadowOpacity = 0.25
      shadowLayer.shadowRadius = 6.0
      shadowLayer.shadowOffset = .zero
      shadowLayer.path = shadowPath.cgPath
      shadowLayer.frame = self.bounds
      self.layer.insertSublayer(shadowLayer, at: 0)
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
      self.setupUI()
      self.loadEmployeeData()
   }
   
   func applyTypography() {
      self.employeeFullNameLabel.heightAnchor.constraint(equalToConstant: 19.0).isActive = true
      self.employeeCellPhoneNumberLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
      self.employeeEmailLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
      
      if let weekDayLabels = self.workingHoursStackView.arrangedSubviews as? [UILabel] {
         for (index, weekDayLabel) in weekDayLabels.enumerated() {
            if index == 0 || index == 4 || index == 6 {
               weekDayLabel.attributedText = UILabel.attributedString(withText: Date.weekDays(withShortFormat: true)[index].uppercased(), andTextColor: UIColor.grayWith(value: 214), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
               weekDayLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
            } else {
               weekDayLabel.attributedText = UILabel.attributedString(withText: Date.weekDays(withShortFormat: true)[index].uppercased(), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
               weekDayLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
            }
         }
      }
   }
   
   func getEmojiiString(from services: [Service]) -> NSAttributedString {
      let splitServices = self.splitServices(services: services)
      
      let maleAttachment = NSTextAttachment()
      maleAttachment.image = #imageLiteral(resourceName: "emoji_sesso_uomo")
      maleAttachment.bounds = CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0)
      
      let femaleAttachment = NSTextAttachment()
      femaleAttachment.image = #imageLiteral(resourceName: "emoji_sesso_donna")
      femaleAttachment.bounds = CGRect(x: 0.0, y: -1.0, width: 9.0, height: 12.0)
      
      var isStarted = false
      let attributedString = NSMutableAttributedString()
      
      if splitServices.manServices.count > 0 {
         for service in splitServices.manServices {
            if let serviceName = service.name, let serviceColor = ServiceColor(withInt16: service.color) {
               if !isStarted {
                  isStarted = true
                  attributedString.append(NSAttributedString(string: serviceName + " ", attributes: [NSAttributedStringKey.foregroundColor: serviceColor.getColor()]))
                  attributedString.append(NSAttributedString(attachment: maleAttachment))
               } else {
                  attributedString.append(NSAttributedString(string: "   " + serviceName + " ", attributes: [NSAttributedStringKey.foregroundColor: serviceColor.getColor()]))
                  attributedString.append(NSAttributedString(attachment: maleAttachment))
               }
            }
         }
      }
      
      if splitServices.womanServices.count > 0 {
         for service in splitServices.womanServices {
            if let serviceName = service.name, let serviceColor = ServiceColor(withInt16: service.color) {
               if !isStarted {
                  isStarted = true
                  attributedString.append(NSAttributedString(string: serviceName + " ", attributes: [NSAttributedStringKey.foregroundColor: serviceColor.getColor()]))
                  attributedString.append(NSAttributedString(attachment: femaleAttachment))
               } else {
                  attributedString.append(NSAttributedString(string: "   " + serviceName + " ", attributes: [NSAttributedStringKey.foregroundColor: serviceColor.getColor()]))
                  attributedString.append(NSAttributedString(attachment: femaleAttachment))
               }
            }
         }
      }
      
      if splitServices.unisexServices.count > 0 {
         for services in splitServices.unisexServices {
            if let serviceName = services.first?.name, let serviceColor = ServiceColor(withInt16: services.first?.color) {
               if !isStarted {
                  isStarted = true
                  attributedString.append(NSAttributedString(string: serviceName + " ", attributes: [NSAttributedStringKey.foregroundColor: serviceColor.getColor()]))
                  attributedString.append(NSAttributedString(attachment: maleAttachment))
                  attributedString.append(NSAttributedString(string: " "))
                  attributedString.append(NSAttributedString(attachment: femaleAttachment))
               } else {
                  attributedString.append(NSAttributedString(string: "   " + serviceName + " ", attributes: [NSAttributedStringKey.foregroundColor: serviceColor.getColor()]))
                  attributedString.append(NSAttributedString(attachment: maleAttachment))
                  attributedString.append(NSAttributedString(string: " "))
                  attributedString.append(NSAttributedString(attachment: femaleAttachment))
               }
            }
         }
      }
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 6
      attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
      attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, range: NSMakeRange(0, attributedString.length))
      return attributedString
   }
   
   func splitServices(services: [Service]) -> (manServices: [Service], womanServices: [Service], unisexServices: [[Service]]) {
      var manServices: [Service] = []
      var womanServices: [Service] = []
      var unisexServices: [[Service]] = []
      
      var pairNames: [String] = []
      
      for service in services {
         if let serviceName = service.name {
            if !(pairNames.contains(serviceName)) {
               if (services.filter { $0.name == service.name }).count > 1 {
                  unisexServices.append(services.filter { $0.name == service.name })
                  pairNames.append(serviceName)
               } else {
                  if service.gender == Int16(Gender.male.rawValue) {
                     manServices.append(service)
                  } else if service.gender == Int16(Gender.female.rawValue) {
                     womanServices.append(service)
                  }
               }
            }
         }
      }
      
      return (manServices: manServices, womanServices: womanServices, unisexServices: unisexServices)
   }
   
   func setupUI() {
      self.employeeImageView.layer.cornerRadius = self.employeeImageView.bounds.size.width / 2.0
   }
   
   func loadEmployeeData() {
      if let employee = self.employee, let firstName = employee.firstName, let lastName = employee.lastName {
         self.employeeFullNameLabel.attributedText = UILabel.attributedString(withText: firstName + " " + lastName, andTextColor: UIColor.grayWith(value: 85), andFont: UIFont.init(name: "SFUIText-Semibold", size: 16)!, andCharacterSpacing: 0.0, isCentered: true)
         
         if let employeePictureData = employee.picture?.pictureData as Data? {
            let employeePicture = UIImage(data: employeePictureData)
            self.employeeImageView.image = employeePicture
         }
         
         if let cellPhoneNumber = employee.phoneNumber {
            self.employeeCellPhoneNumberLabel.attributedText = UILabel.attributedString(withText: cellPhoneNumber, andTextColor: UIColor.grayWith(value: 85), andFont: UIFont.init(name: "SFUIText-Regular", size: 13.0)!, andCharacterSpacing: 0.0, isCentered: true)
         }
         
         if let email = employee.email {
            self.employeeEmailLabel.attributedText = UILabel.attributedString(withText: email, andTextColor: UIColor.grayWith(value: 85), andFont: UIFont.init(name: "SFUIText-Regular", size: 13.0)!, andCharacterSpacing: 0.0, isCentered: true)
         }
         
         if let services = employee.services?.allObjects as? [Service] {
            self.employeeServicesLabel.attributedText = self.getEmojiiString(from: services)
         }
         
      }
   }
   
   @IBAction func editEmployeeButtonPressed(sender: UIButton) {
      if let employee = self.employee {
         self.delegate?.editEmployee(employee: employee)
      }
   }
   
}

