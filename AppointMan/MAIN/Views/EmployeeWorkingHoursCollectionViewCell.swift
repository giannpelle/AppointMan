//
//  EmployeeWorkingHoursCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/20/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class EmployeeWorkingHoursCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var workingHoursLabel: UILabel!
   @IBOutlet weak var weekDaysStackView: UIStackView!
   @IBOutlet weak var timetableView: UIView!
   @IBOutlet weak var dayOffButton: UIButton!
   
   var timetable: [[(from: String, to: String)]]?
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.workingHoursLabel.attributedText = UILabel.attributedString(withText: "ORARIO DI LAVORO", andTextColor: UIColor.grayWith(value: 75.0), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
      if let weekDayLabels = self.weekDaysStackView.arrangedSubviews as? [UILabel] {
         let weekDays = Date.weekDays(withShortFormat: true).map { $0.uppercased() }
         for (index, weekDayLabel) in weekDayLabels.enumerated() {
            weekDayLabel.attributedText = UILabel.attributedString(withText: weekDays[index], andTextColor: UIColor.grayWith(value: 214.0), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
         }
      }
      self.dayOffButton.setAttributedTitle(UILabel.attributedString(withText: "AGGIUNGI FERIE / PERMESSI", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
   }
   
   func setupUI() {
      self.dayOffButton.layer.cornerRadius = 5.0
   }
   
   func setupTimetable() {
      if let timetable = self.timetable {
         for view in self.timetableView.subviews {
            view.removeFromSuperview()
         }
         if let sublayers = self.timetableView.layer.sublayers, sublayers.count > 0 {
            for layer in sublayers {
               layer.removeFromSuperlayer()
            }
         }
         
         let oneSeventhWidth = CGFloat(Int(self.timetableView.bounds.size.width / 7.0))
         let boxSize = CGSize(width: oneSeventhWidth, height: 35.0)
         let boxSpacing: CGFloat = 15.0
         
         for (colomn, weekDay) in timetable.enumerated() {
            for (row, element) in weekDay.enumerated() {
               switch colomn {
               case 0:
                  let fromLabel = UILabel()
                  fromLabel.attributedText = UILabel.attributedString(withText: element.from, andTextColor: UIColor.grayWith(value: 85.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 11.0)!, andCharacterSpacing: 0.0, isCentered: true)
                  self.timetableView.addSubview(fromLabel)
                  fromLabel.translatesAutoresizingMaskIntoConstraints = false
                  fromLabel.topAnchor.constraint(equalTo: self.timetableView.topAnchor, constant: (boxSize.height + boxSpacing) * row).isActive = true
                  fromLabel.leadingAnchor.constraint(equalTo: self.timetableView.leadingAnchor).isActive = true
                  fromLabel.widthAnchor.constraint(equalToConstant: oneSeventhWidth).isActive = true
                  
                  let separatorLayer = CALayer()
                  separatorLayer.backgroundColor = UIColor.grayWith(value: 214.0).cgColor
                  separatorLayer.frame = CGRect(x: CGFloat(Int(oneSeventhWidth / 2.0)), y: (boxSize.height + boxSpacing) * row + UIFont.init(name: "SFUIText-Regular", size: 11.0)!.lineHeight + 1, width: 1.0, height: 7.0)
                  self.timetableView.layer.addSublayer(separatorLayer)
                  
                  let toLabel = UILabel()
                  toLabel.attributedText = UILabel.attributedString(withText: element.to, andTextColor: UIColor.grayWith(value: 85.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 11.0)!, andCharacterSpacing: 0.0, isCentered: true)
                  self.timetableView.addSubview(toLabel)
                  toLabel.translatesAutoresizingMaskIntoConstraints = false
                  toLabel.topAnchor.constraint(equalTo: self.timetableView.topAnchor, constant: (boxSize.height + boxSpacing) * row + 9.0 + UIFont.init(name: "SFUIText-Regular", size: 11.0)!.lineHeight).isActive = true
                  toLabel.leadingAnchor.constraint(equalTo: self.timetableView.leadingAnchor).isActive = true
                  toLabel.widthAnchor.constraint(equalToConstant: oneSeventhWidth).isActive = true
                  
               case 3:
                  let fromLabel = UILabel()
                  fromLabel.attributedText = UILabel.attributedString(withText: element.from, andTextColor: UIColor.grayWith(value: 85.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 11.0)!, andCharacterSpacing: 0.0, isCentered: true)
                  self.timetableView.addSubview(fromLabel)
                  fromLabel.translatesAutoresizingMaskIntoConstraints = false
                  fromLabel.topAnchor.constraint(equalTo: self.timetableView.topAnchor, constant: (boxSize.height + boxSpacing) * row).isActive = true
                  fromLabel.centerXAnchor.constraint(equalTo: self.timetableView.centerXAnchor).isActive = true
                  fromLabel.widthAnchor.constraint(equalToConstant: oneSeventhWidth).isActive = true
                  
                  let separatorLayer = CALayer()
                  separatorLayer.backgroundColor = UIColor.grayWith(value: 214.0).cgColor
                  separatorLayer.frame = CGRect(x: CGFloat(Int(self.timetableView.bounds.size.width / 2.0)), y: (boxSize.height + boxSpacing) * row + UIFont.init(name: "SFUIText-Regular", size: 11.0)!.lineHeight + 1, width: 1.0, height: 7.0)
                  self.timetableView.layer.addSublayer(separatorLayer)
                  
                  let toLabel = UILabel()
                  toLabel.attributedText = UILabel.attributedString(withText: element.to, andTextColor: UIColor.grayWith(value: 85.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 11.0)!, andCharacterSpacing: 0.0, isCentered: true)
                  self.timetableView.addSubview(toLabel)
                  toLabel.translatesAutoresizingMaskIntoConstraints = false
                  toLabel.topAnchor.constraint(equalTo: self.timetableView.topAnchor, constant: (boxSize.height + boxSpacing) * row + 9.0 + UIFont.init(name: "SFUIText-Regular", size: 11.0)!.lineHeight).isActive = true
                  toLabel.centerXAnchor.constraint(equalTo: self.timetableView.centerXAnchor).isActive = true
                  toLabel.widthAnchor.constraint(equalToConstant: oneSeventhWidth).isActive = true
                  
               case 6:
                  let fromLabel = UILabel()
                  fromLabel.attributedText = UILabel.attributedString(withText: element.from, andTextColor: UIColor.grayWith(value: 85.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 11.0)!, andCharacterSpacing: 0.0, isCentered: true)
                  self.timetableView.addSubview(fromLabel)
                  fromLabel.translatesAutoresizingMaskIntoConstraints = false
                  fromLabel.topAnchor.constraint(equalTo: self.timetableView.topAnchor, constant: (boxSize.height + boxSpacing) * row).isActive = true
                  fromLabel.trailingAnchor.constraint(equalTo: self.timetableView.trailingAnchor).isActive = true
                  fromLabel.widthAnchor.constraint(equalToConstant: oneSeventhWidth).isActive = true
                  
                  let separatorLayer = CALayer()
                  separatorLayer.backgroundColor = UIColor.grayWith(value: 214.0).cgColor
                  separatorLayer.frame = CGRect(x: self.timetableView.bounds.size.width - CGFloat(Int(oneSeventhWidth / 2.0)), y: (boxSize.height + boxSpacing) * row + UIFont.init(name: "SFUIText-Regular", size: 11.0)!.lineHeight + 1, width: 1.0, height: 7.0)
                  self.timetableView.layer.addSublayer(separatorLayer)
                  
                  let toLabel = UILabel()
                  toLabel.attributedText = UILabel.attributedString(withText: element.to, andTextColor: UIColor.grayWith(value: 85.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 11.0)!, andCharacterSpacing: 0.0, isCentered: true)
                  self.timetableView.addSubview(toLabel)
                  toLabel.translatesAutoresizingMaskIntoConstraints = false
                  toLabel.topAnchor.constraint(equalTo: self.timetableView.topAnchor, constant: (boxSize.height + boxSpacing) * row + 9.0 + UIFont.init(name: "SFUIText-Regular", size: 11.0)!.lineHeight).isActive = true
                  toLabel.trailingAnchor.constraint(equalTo: self.timetableView.trailingAnchor).isActive = true
                  toLabel.widthAnchor.constraint(equalToConstant: oneSeventhWidth).isActive = true
                  
               default:
                  let fromLabel = UILabel()
                  fromLabel.attributedText = UILabel.attributedString(withText: element.from, andTextColor: UIColor.grayWith(value: 85.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 11.0)!, andCharacterSpacing: 0.0, isCentered: true)
                  self.timetableView.addSubview(fromLabel)
                  fromLabel.translatesAutoresizingMaskIntoConstraints = false
                  fromLabel.topAnchor.constraint(equalTo: self.timetableView.topAnchor, constant: (boxSize.height + boxSpacing) * row).isActive = true
                  fromLabel.leadingAnchor.constraint(equalTo: self.timetableView.leadingAnchor, constant: colomn * oneSeventhWidth).isActive = true
                  fromLabel.widthAnchor.constraint(equalToConstant: oneSeventhWidth).isActive = true
                  
                  let separatorLayer = CALayer()
                  separatorLayer.backgroundColor = UIColor.grayWith(value: 214.0).cgColor
                  separatorLayer.frame = CGRect(x: colomn * oneSeventhWidth + CGFloat(Int(oneSeventhWidth / 2.0)), y: (boxSize.height + boxSpacing) * row + UIFont.init(name: "SFUIText-Regular", size: 11.0)!.lineHeight + 1, width: 1.0, height: 7.0)
                  self.timetableView.layer.addSublayer(separatorLayer)
                  
                  let toLabel = UILabel()
                  toLabel.attributedText = UILabel.attributedString(withText: element.to, andTextColor: UIColor.grayWith(value: 85.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 11.0)!, andCharacterSpacing: 0.0, isCentered: true)
                  self.timetableView.addSubview(toLabel)
                  toLabel.translatesAutoresizingMaskIntoConstraints = false
                  toLabel.topAnchor.constraint(equalTo: self.timetableView.topAnchor, constant: (boxSize.height + boxSpacing) * row + 9.0 + UIFont.init(name: "SFUIText-Regular", size: 11.0)!.lineHeight).isActive = true
                  toLabel.leadingAnchor.constraint(equalTo: self.timetableView.leadingAnchor, constant: colomn * oneSeventhWidth).isActive = true
                  toLabel.widthAnchor.constraint(equalToConstant: oneSeventhWidth).isActive = true
               }
               
               
            }
         }
      }
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      self.setupTimetable()
   }
   
   
   
}
