//
//  ClosingDaysViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/14/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ClosingDaysViewController: UIViewController {
   
   @IBOutlet weak var navigationTitleViewLabel: UILabel!
   @IBOutlet weak var navigationRightBarButton: UIButton!
   @IBOutlet weak var navigationBackButton: UIButton!
   @IBOutlet weak var closingDaysLabel: UILabel!
   @IBOutlet weak var closureLabel: UILabel!
   @IBOutlet weak var weekDaysStackView: UIStackView!
   @IBOutlet weak var closingDaysCalendarAccessoryLabel: UILabel!
   @IBOutlet weak var closingDaysCalendarBackgroundView: UIView!
   @IBOutlet weak var closingDaysCalendarBackView: ClosingDaysCalendarBackgroundView!
   @IBOutlet weak var closingDaysCalendarTitleLabel: UILabel!
   @IBOutlet weak var closingDaysCalendarPreviousMonthButton: UIButton!
   @IBOutlet weak var closingDaysCalendarNextMonthButton: UIButton!
   @IBOutlet weak var closingDaysCalendarWeekDaysStackView: UIStackView!
   @IBOutlet weak var closingDaysCalendarCollectionView: UICollectionView!
   
   var currentMonthIndex: Int = 0 {
      didSet {
         self.currentMonthDays = self.getCurrentMonthDays()
         self.previousMonthDays = self.getPreviousMonthDays()
         self.nextMonthDays = self.getNextMonthDays()
         self.calendarDays = self.getCalendarDays()
         
         self.closingDaysCalendarTitleLabel.attributedText = UILabel.attributedString(withText: "\(Date().increaseMonth(by: self.currentMonthIndex).monthStr()) \(Date().increaseMonth(by: self.currentMonthIndex).getYear())", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
         self.closingDaysCalendarPreviousMonthButton.setAttributedTitle(UILabel.attributedString(withText: "\(Date().increaseMonth(by: self.currentMonthIndex - 1).monthStr().uppercased())", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86), for: .normal)
         self.closingDaysCalendarNextMonthButton.setAttributedTitle(UILabel.attributedString(withText: "\(Date().increaseMonth(by: self.currentMonthIndex + 1).monthStr().uppercased())", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86), for: .normal)
         
         self.closingDaysCalendarCollectionView.reloadData()
      }
   }
   
   var currentMonthDays: [(day: Int, dayColor: UIColor)] = []
   
   func getCurrentMonthDays() -> [(day: Int, dayColor: UIColor)] {
      return [Int](1...Date().increaseMonth(by: self.currentMonthIndex).getNumberOfDaysInMonth()).map {
         (day: $0, dayColor: UIColor.amDarkBlue)
      }
   }
   
   var previousMonthDays: [(day: Int, dayColor: UIColor)] = []
   
   func getPreviousMonthDays() -> [(day: Int, dayColor: UIColor)] {
      if let firstDayOfWeek = Date().increaseMonth(by: self.currentMonthIndex).startOfMonth().dayOfWeek() {
         let previousMonthDays = Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: -1).getNumberOfDaysInMonth()
         if firstDayOfWeek == 2 {
            return []
         } else if firstDayOfWeek == 1 {
            // 6 elements
            return [Int]((previousMonthDays - 5)...previousMonthDays).map {
               (day: $0, dayColor: UIColor.amDarkBlue.withAlphaComponent(0.3))
            }
         } else {
            //firstDayOfWeek - 2 elements
            return [Int]((previousMonthDays - (firstDayOfWeek - 3))...previousMonthDays).map {
               (day: $0, dayColor: UIColor.amDarkBlue.withAlphaComponent(0.3))
            }
         }
      } else {
         return []
      }
   }
   
   var nextMonthDays: [(day: Int, dayColor: UIColor)] = []
   
   func getNextMonthDays() -> [(day: Int, dayColor: UIColor)] {
      let numberOfDays = self.currentMonthDays.count + self.previousMonthDays.count
      return [Int](1...(42 - numberOfDays)).map {
         (day: $0, dayColor: UIColor.amDarkBlue.withAlphaComponent(0.3))
      }
   }
   
   var calendarDays: [(day: Int, dayColor: UIColor)] = []
   
   func getCalendarDays() -> [(day: Int, dayColor: UIColor)] {
      return previousMonthDays + currentMonthDays + nextMonthDays
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.navigationTitleViewLabel.attributedText = UILabel.attributedString(withText: "Seleziona giorni di chiusura", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
      self.navigationRightBarButton.setAttributedTitle(UILabel.attributedString(withText: "Fine", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
      self.closingDaysLabel.attributedText = UILabel.attributedString(withText: "Giorni di chiusura", andTextColor: UIColor.grayWith(value: 85), andFont: UIFont.init(name: "SFUIText-Regular", size: 22.0)!, andCharacterSpacing: nil)
      self.closureLabel.attributedText = UILabel.attributedString(withText: "TURNO DI CHIUSURA", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      
      if let weekDayButtons = self.weekDaysStackView.arrangedSubviews as? [UIButton] {
         for (index, weekDayButton) in weekDayButtons.enumerated() {
            weekDayButton.setAttributedTitle(UILabel.attributedString(withText: Date.weekDays(withShortFormat: true)[index].uppercased(), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
            weekDayButton.setAttributedTitle(UILabel.attributedString(withText: Date.weekDays(withShortFormat: true)[index].uppercased(), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true), for: .selected)
            weekDayButton.setAttributedTitle(UILabel.attributedString(withText: Date.weekDays(withShortFormat: true)[index].uppercased(), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true), for: .highlighted)
         }
      }
         
      let attrText = NSMutableAttributedString(string: "GIORNI DI CHIUSURA (premi per selezionare)")
      attrText.addAttributes(UILabel.attributes(forTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86), range: NSRange(location: 0, length: 18))
      attrText.addAttributes(UILabel.attributes(forTextColor: UIColor.grayWith(value: 182.0), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86), range: NSRange(location: 18, length: 24))
      self.closingDaysCalendarAccessoryLabel.attributedText = attrText
      
      let weekDays = Date.weekDays()
      if let weekDayLabels = self.closingDaysCalendarWeekDaysStackView.arrangedSubviews as? [UILabel] {
         for (index, weekDayLabel) in weekDayLabels.enumerated() {
            weekDayLabel.attributedText = UILabel.attributedString(withText: weekDays[index], andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 14.0)!, andCharacterSpacing: 0.88, isCentered: true)
         }
      }
      
      self.closingDaysCalendarTitleLabel.attributedText = UILabel.attributedString(withText: "\(Date().increaseMonth(by: self.currentMonthIndex).monthStr()) \(Date().getYear())", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
      self.closingDaysCalendarPreviousMonthButton.setAttributedTitle(UILabel.attributedString(withText: "\(Date().increaseMonth(by: self.currentMonthIndex - 1).monthStr().uppercased())", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86), for: .normal)
      self.closingDaysCalendarNextMonthButton.setAttributedTitle(UILabel.attributedString(withText: "\(Date().increaseMonth(by: self.currentMonthIndex + 1).monthStr().uppercased())", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86), for: .normal)
   }
   
   func setupUI() {
      self.currentMonthDays = self.getCurrentMonthDays()
      self.previousMonthDays = self.getPreviousMonthDays()
      self.nextMonthDays = self.getNextMonthDays()
      self.calendarDays = self.getCalendarDays()
      
      self.navigationRightBarButton.addTarget(self, action: #selector(self.nextBarButtonItemPressed(sender:)), for: .touchUpInside)
      self.navigationBackButton.addTarget(self, action: #selector(self.backBarButtonItemPressed(sender:)), for: .touchUpInside)
      
      if let weekDayButtons = self.weekDaysStackView.arrangedSubviews as? [UIButton] {
         for weekDayButton in weekDayButtons {
            weekDayButton.clipsToBounds = true
            weekDayButton.layer.cornerRadius = 3.0
            weekDayButton.setBackgroundColor(color: UIColor(red: 227/255.0, green: 227/255.0, blue: 234/255.0, alpha: 1.0), forState: .normal)
            weekDayButton.setBackgroundColor(color: UIColor.amBlue, forState: .selected)
            weekDayButton.setBackgroundColor(color: UIColor.amBlue, forState: .highlighted)
            weekDayButton.addTarget(self, action: #selector(self.weekDayButtonPressed(sender:)), for: .touchUpInside)
         }
      }
      
      self.closingDaysCalendarPreviousMonthButton.addTarget(self, action: #selector(self.previousMonthButtonPressed(sender:)), for: .touchUpInside)
      self.closingDaysCalendarNextMonthButton.addTarget(self, action: #selector(self.nextMonthButtonPressed(sender:)), for: .touchUpInside)
      
      self.closingDaysCalendarBackgroundView.layer.cornerRadius = 5.0
      self.closingDaysCalendarBackView.layer.borderColor = UIColor.amDarkBlue.withAlphaComponent(0.3).cgColor
      self.closingDaysCalendarBackView.layer.borderWidth = 2.0
      self.closingDaysCalendarCollectionView.delegate = self
      self.closingDaysCalendarCollectionView.dataSource = self
   }
   
   @objc func weekDayButtonPressed(sender: UIButton) {
      sender.isSelected = !sender.isSelected
   }
   
   @objc func previousMonthButtonPressed(sender: UIButton) {
      self.currentMonthIndex -= 1
   }
   
   @objc func nextMonthButtonPressed(sender: UIButton) {
      self.currentMonthIndex += 1
   }
   
   @objc func nextBarButtonItemPressed(sender: UIBarButtonItem) {
      let homeVC = UIStoryboard.revealMenuVC()
      self.present(homeVC, animated: true, completion: nil)
      //nextVC.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "on_boarding_back_button"), style: .plain, target: self, action: nil)
   }
   
   @objc func backBarButtonItemPressed(sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
   }
   
}

extension ClosingDaysViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return self.calendarDays.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "closingDaysCalendarCellId", for: indexPath) as? ClosingCalendarCollectionViewCell else {
         return UICollectionViewCell()
      }
      
      cell.day = self.calendarDays[indexPath.row]
      if let festivityDescr = FestivityManager.shared.getFestivity(for: self.getDate(for: indexPath)) {
         cell.dayAccessoryText = festivityDescr
      } else {
         cell.dayAccessoryText = nil
      }
      cell.isClosed = false
      return cell
   }
   
   func getDate(for indexPath: IndexPath) -> Date {
      var components = DateComponents()
      components.day = self.calendarDays[indexPath.row].day
      if indexPath.row < self.previousMonthDays.count {
         components.month = Date().increaseMonth(by: self.currentMonthIndex - 1).getMonth()
      } else if indexPath.row < self.previousMonthDays.count + self.currentMonthDays.count {
         components.month = Date().increaseMonth(by: self.currentMonthIndex).getMonth()
      } else {
         components.month = Date().increaseMonth(by: self.currentMonthIndex + 1).getMonth()
      }
      if indexPath.row < self.previousMonthDays.count {
         components.year = Date().increaseMonth(by: self.currentMonthIndex - 1).getYear()
      } else if indexPath.row < self.previousMonthDays.count + self.currentMonthDays.count {
         components.year = Date().increaseMonth(by: self.currentMonthIndex).getYear()
      } else {
         components.year = Date().increaseMonth(by: self.currentMonthIndex + 1).getYear()
      }
      return Calendar.current.date(from: components)!
   }

}

extension ClosingDaysViewController: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if let currentCell = collectionView.cellForItem(at: indexPath) as? ClosingCalendarCollectionViewCell {
         currentCell.isClosed = !currentCell.isClosed
      }
   }
   
}

extension ClosingDaysViewController: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 130.0, height: 50.0)
   }
}
