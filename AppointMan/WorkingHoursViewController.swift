//
//  WorkingHoursViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/31/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class WorkingHoursViewController: UIViewController {
   
   let hourUnitHeight: CGFloat = 80.0
   let numberOfHours: CGFloat = 17.0
   let placeholderInsetHeight: CGFloat = 10.0
   
   @IBOutlet weak var employeeLabel: UILabel!
   @IBOutlet weak var weekDaysStackView: UIStackView!
   @IBOutlet weak var hoursScrollView: UIScrollView!
   @IBOutlet weak var workingHoursPlannerScrollView: UIScrollView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.employeeLabel.attributedText = UILabel.attributedString(withText: "Gianluigi Pelle", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
      self.employeeLabel.setLineHeightInset(3.0)
      
      self.setupWeekdaysStackView()
      self.setupHoursScrollView()
      self.setupWorkingHoursPlannerScrollView()
   }
   
   func setupWeekdaysStackView() {
      let days = Date.weekDays()
      for (index, view) in self.weekDaysStackView.arrangedSubviews.enumerated() {
         if let dayLabel = view as? UILabel {
            dayLabel.attributedText = UILabel.attributedString(withText: days[index], andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 16.0)!, andCharacterSpacing: 1.14, isCentered: true)
            dayLabel.setLineHeightInset(3.0)
         }
      }
   }
   
   func setupHoursScrollView() {
      self.hoursScrollView.showsVerticalScrollIndicator = false
      self.hoursScrollView.isScrollEnabled = false
      self.hoursScrollView.contentSize = CGSize(width: self.hoursScrollView.bounds.size.width, height: self.placeholderInsetHeight + (self.numberOfHours * self.hourUnitHeight) + self.placeholderInsetHeight)
      
      let topInsetView = UIView()
      topInsetView.backgroundColor = UIColor.clear
      topInsetView.widthAnchor.constraint(equalToConstant: self.hoursScrollView.bounds.size.width).isActive = true
      topInsetView.heightAnchor.constraint(equalToConstant: self.placeholderInsetHeight).isActive = true
      
      var hourLabels = [UIView]()
      for index in 0..<Int(self.numberOfHours) {
         let myLabel = UILabel()
         myLabel.widthAnchor.constraint(equalToConstant: self.hoursScrollView.bounds.size.width).isActive = true
         myLabel.heightAnchor.constraint(equalToConstant: self.hourUnitHeight).isActive = true
         myLabel.attributedText = UILabel.attributedString(withText: "\(index + 6):00", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil, isCentered: true)
         myLabel.setLineHeightInset(2.0)
         hourLabels.append(myLabel)
      }
      
      let bottomInsetView = UIView()
      bottomInsetView.widthAnchor.constraint(equalToConstant: self.hoursScrollView.bounds.size.width).isActive = true
      bottomInsetView.heightAnchor.constraint(equalToConstant: self.placeholderInsetHeight).isActive = true
      bottomInsetView.backgroundColor = UIColor.clear
      
      let arrangedSubview = [topInsetView] + hourLabels + [bottomInsetView]
      let hoursStackView = UIStackView(arrangedSubviews: arrangedSubview)
      hoursStackView.axis = .vertical
      hoursStackView.alignment = .center
      hoursStackView.spacing = 0.0
      hoursStackView.distribution = .fill
      
      self.hoursScrollView.addSubview(hoursStackView)
      hoursStackView.translatesAutoresizingMaskIntoConstraints = false
      hoursStackView.leadingAnchor.constraint(equalTo: self.hoursScrollView.leadingAnchor, constant: 0.0).isActive = true
      hoursStackView.topAnchor.constraint(equalTo: self.hoursScrollView.topAnchor, constant: 0.0).isActive = true
      hoursStackView.widthAnchor.constraint(equalToConstant: self.hoursScrollView.bounds.size.width).isActive = true
      hoursStackView.heightAnchor.constraint(equalToConstant: self.placeholderInsetHeight + (self.numberOfHours * self.hourUnitHeight) + self.placeholderInsetHeight).isActive = true
   }
   
   func setupWorkingHoursPlannerScrollView() {
      
      self.workingHoursPlannerScrollView.clipsToBounds = false
      self.workingHoursPlannerScrollView.delegate = self
      self.workingHoursPlannerScrollView.bounces = false
      self.workingHoursPlannerScrollView.showsVerticalScrollIndicator = false
      self.workingHoursPlannerScrollView.contentSize = CGSize(width: self.workingHoursPlannerScrollView.bounds.size.width, height: self.hourUnitHeight * (self.numberOfHours))
      self.workingHoursPlannerScrollView.layer.borderWidth = 2.0
      self.workingHoursPlannerScrollView.layer.borderColor = UIColor.amDarkBlue.withAlphaComponent(0.3).cgColor
      
//      let maskLayer = CALayer()
//      maskLayer.backgroundColor = UIColor.clear.cgColor
//      maskLayer.frame = CGRect(x: 0.0, y: 0.0, width: 900.0, height: 500.0)
//      self.workingHoursPlannerScrollView.layer.mask = maskLayer
      
      guard let workingHoursPlannerView = Bundle.main.loadNibNamed("WorkingHoursPlannerView", owner: self, options: nil)?[0] as? WorkingHoursPlannerView else {
         return
      }
      self.workingHoursPlannerScrollView.addSubview(workingHoursPlannerView)
      workingHoursPlannerView.translatesAutoresizingMaskIntoConstraints = false
      workingHoursPlannerView.backgroundColor = UIColor.clear
      workingHoursPlannerView.leadingAnchor.constraint(equalTo: self.workingHoursPlannerScrollView.leadingAnchor, constant: 0.0).isActive = true
      workingHoursPlannerView.widthAnchor.constraint(equalToConstant: self.workingHoursPlannerScrollView.bounds.size.width).isActive = true
      workingHoursPlannerView.topAnchor.constraint(equalTo: self.workingHoursPlannerScrollView.topAnchor, constant: 0.0).isActive = true
      workingHoursPlannerView.heightAnchor.constraint(equalToConstant: self.hourUnitHeight * (self.numberOfHours)).isActive = true
   }
}

extension WorkingHoursViewController: UIScrollViewDelegate {
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      self.hoursScrollView.contentOffset = scrollView.contentOffset
   }
}
