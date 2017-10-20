//
//  EmployeeCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/19/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class EmployeeCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var employeeImageView: UIImageView!
   @IBOutlet weak var employeeFullNameLabel: UILabel!
   @IBOutlet weak var employeeCellPhoneNumberLabel: UILabel!
   @IBOutlet weak var employeeEmailLabel: UILabel!
   @IBOutlet weak var workingHoursStackView: UIStackView!
   @IBOutlet weak var employeeServicesLabel: UILabel!
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      self.contentView.layer.masksToBounds = false
      self.layer.masksToBounds = false
      
      self.layer.cornerRadius = 5.0
      self.layer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      self.layer.shadowOpacity = 0.25
      self.layer.shadowRadius = 6.0
      self.layer.shadowOffset = .zero
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
      self.setupUI()
      
   }
   
   func applyTypography() {
      
      self.employeeFullNameLabel.attributedText = UILabel.attributedString(withText: "Gianluigi Pelle", andTextColor: UIColor.grayWith(value: 85), andFont: UIFont.init(name: "SFUIText-Semibold", size: 16)!, andCharacterSpacing: 0.0, isCentered: true)
      self.employeeFullNameLabel.heightAnchor.constraint(equalToConstant: 19.0).isActive = true
      
      self.employeeCellPhoneNumberLabel.attributedText = UILabel.attributedString(withText: "347 5205469", andTextColor: UIColor.grayWith(value: 85), andFont: UIFont.init(name: "SFUIText-Regular", size: 13.0)!, andCharacterSpacing: 0.0, isCentered: true)
      self.employeeCellPhoneNumberLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
      
      self.employeeEmailLabel.attributedText = UILabel.attributedString(withText: "luca.verdde@gmail.com", andTextColor: UIColor.grayWith(value: 85), andFont: UIFont.init(name: "SFUIText-Regular", size: 13.0)!, andCharacterSpacing: 0.0, isCentered: true)
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
      
      let attributedString = NSMutableAttributedString(string: "Taglio Capelli ", attributes: [NSAttributedStringKey.foregroundColor: ServiceColor.getRandomColor()])
      
      let maleAttachment = NSTextAttachment()
      maleAttachment.image = #imageLiteral(resourceName: "emoji_sesso_uomo")
      maleAttachment.bounds = CGRect(x: 0.0, y: 2.0, width: 10.0, height: 10.0)
      attributedString.append(NSAttributedString(attachment: maleAttachment))
      
      attributedString.append(NSAttributedString(string: " "))
      
      let femaleAttachment = NSTextAttachment()
      femaleAttachment.image = #imageLiteral(resourceName: "emoji_sesso_donna")
      femaleAttachment.bounds = CGRect(x: 0.0, y: 1.0, width: 9.0, height: 12.0)
      attributedString.append(NSAttributedString(attachment: femaleAttachment))
      
      attributedString.append(NSAttributedString(string: "   Colore ", attributes: [NSAttributedStringKey.foregroundColor: ServiceColor.getRandomColor()]))
      
      attributedString.append(NSAttributedString(attachment: femaleAttachment))
      
      attributedString.append(NSAttributedString(string: "   Taglio Barba ", attributes: [NSAttributedStringKey.foregroundColor: ServiceColor.getRandomColor()]))
      
      attributedString.append(NSAttributedString(attachment: maleAttachment))
      
      attributedString.append(NSAttributedString(string: "   Shampoo Fluo ", attributes: [NSAttributedStringKey.foregroundColor: ServiceColor.getRandomColor()]))
      
      attributedString.append(NSAttributedString(attachment: maleAttachment))
      
      attributedString.append(NSAttributedString(string: "   Taglio criniera ", attributes: [NSAttributedStringKey.foregroundColor: ServiceColor.getRandomColor()]))
      
      attributedString.append(NSAttributedString(attachment: maleAttachment))
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 6
      attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
      
      attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, range: NSMakeRange(0, attributedString.length))
      
      self.employeeServicesLabel.attributedText = attributedString
      
//      attributedString.append(NSAttributedString(string: " was holdin'\n"))
//      attributedString.append(NSAttributedString(string: "Ripped "))
//
//      let jeansAttachment = NSTextAttachment()
//      jeansAttachment.image = emojisCollection[1]
//      jeansAttachment.bounds = iconsSize
//      attributedString.appendAttributedString(NSAttributedString(attachment: jeansAttachment))
//
//      attributedString.appendAttributedString(NSAttributedString(string: " ,\n"))
//      attributedString.appendAttributedString(NSAttributedString(string: "skin was showin'\n"))
//
//      let fireAttachment = NSTextAttachment()
//      fireAttachment.image = emojisCollection[2]
//      fireAttachment.bounds = iconsSize
//      attributedString.appendAttributedString(NSAttributedString(attachment: fireAttachment))
//
//      attributedString.appendAttributedString(NSAttributedString(string: " night, wind was "))
//
//      let dashAttachment = NSTextAttachment()
//      dashAttachment.image = emojisCollection[3]
//      dashAttachment.bounds = iconsSize
//      attributedString.appendAttributedString(NSAttributedString(attachment: dashAttachment))
//
//      attributedString.appendAttributedString(NSAttributedString(string: "\nWhere you think\n"))
//      attributedString.appendAttributedString(NSAttributedString(string: "you're going, "))
//
//      let babyAttachment = NSTextAttachment()
//      babyAttachment.image = emojisCollection[4]
//      babyAttachment.bounds = iconsSize
//      attributedString.appendAttributedString(NSAttributedString(attachment: babyAttachment))
//
//      attributedString.appendAttributedString(NSAttributedString(string: " ?"))
//
//      label.attributedText = attributedString
      
      
   }
   
   func setupUI() {
      self.employeeImageView.layer.cornerRadius = self.employeeImageView.bounds.size.width / 2.0
   }
   
}
