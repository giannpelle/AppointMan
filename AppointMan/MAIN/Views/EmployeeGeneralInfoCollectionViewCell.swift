//
//  EmployeeGeneralInfoCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/19/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class EmployeeGeneralInfoCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var employeeImageView: UIImageView!
   @IBOutlet weak var employeeNameLabel: UILabel!
   @IBOutlet weak var employeeCellPhoneNumberLabel: UILabel!
   @IBOutlet weak var employeeMailLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
   }
   
   func applyTypography() {
      self.employeeNameLabel.attributedText = UILabel.attributedString(withText: "Francesca Lopelli", andTextColor: UIColor.grayWith(value: 85.0), andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
   }
   
   func setupUI() {
      
   }
   
}
