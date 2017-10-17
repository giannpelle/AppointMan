//
//  GPCalendarView.swift
//  GPCalendar
//
//  Created by Gianluigi Pelle on 8/26/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol GPCalendarViewDelegate {
   func calendarView(calendarView: GPCalendarView, didSelectDate: Date)
}

class GPCalendarView: UIView {
   
   // TOP BAR
   var topBar: UIView!
   var previousMonthButton: UIButton!
   var nextMonthButton: UIButton!
   var monthLabel: UILabel!
   
   // CALENDAR VIEW
   var calendarBoxView: UIView!
   var weekDaysStackView: UIStackView!
   var daysCollectionView: UICollectionView!
   
   var delegate: GPCalendarViewDelegate?
   
   var currentIndexPathSelected: Int?
   var currentDateSelected: Date = Date() {
      didSet {
         let formatter = DateFormatter()
         formatter.dateFormat = "didSelect: dd/MM/yyyy"
         print(formatter.string(from: self.currentDateSelected))
         self.delegate?.calendarView(calendarView: self, didSelectDate: self.currentDateSelected)
      }
   }
   var currentMonthIndex: Int = 0 {
      didSet {
         self.monthLabel.attributedText = UILabel.attributedString(withText: Date().increaseMonth(by: self.currentMonthIndex).getMonthAndYearText().capitalized, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true)
         self.monthLabel.setLineHeightInset(2.0)
         self.cleanCells()
         self.currentIndexPathSelected = nil
         self.daysCollectionView.reloadData()
      }
   }
   var currentMonthDays: [(day: Int, dayColor: UIColor)] {
      get {
         return [Int](1...Date().increaseMonth(by: self.currentMonthIndex).getNumberOfDaysInMonth()).map {
            (day: $0, dayColor: UIColor.amOpaqueBlue)
         }
      }
   }
   var previousMonthDays: [(day: Int, dayColor: UIColor)] {
      get {
         if let firstDayOfWeek = Date().increaseMonth(by: self.currentMonthIndex).startOfMonth().dayOfWeek() {
            let previousMonthDays = Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: -1).getNumberOfDaysInMonth()
            if firstDayOfWeek == 2 {
               return []
            } else if firstDayOfWeek == 1 {
               // 6 elements
               return [Int]((previousMonthDays - 5)...previousMonthDays).map {
                  (day: $0, dayColor: UIColor.amCalendarOutOfBoundsDaysGrey)
               }
            } else {
               //firstDayOfWeek - 2 elements
               return [Int]((previousMonthDays - (firstDayOfWeek - 3))...previousMonthDays).map {
                  (day: $0, dayColor: UIColor.amCalendarOutOfBoundsDaysGrey)
               }
            }
         } else {
            return []
         }
      }
   }
   var nextMonthDays: [(day: Int, dayColor: UIColor)] {
      get {
         let numberOfDays = self.currentMonthDays.count + self.previousMonthDays.count
         return [Int](1...(42 - numberOfDays)).map {
            (day: $0, dayColor: UIColor.amCalendarOutOfBoundsDaysGrey)
         }
      }
   }
   var calendarDays: [(day: Int, dayColor: UIColor)] {
      get {
         return previousMonthDays + currentMonthDays + nextMonthDays
      }
   }
   
   init() {
      super.init(frame: CGRect.zero)
      self.setup()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.setup()
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.setup()
   }
   
   private func setup() {
      
      // TOP BAR setup
      self.topBar = UIView()
      self.topBar.backgroundColor = UIColor.amDarkBlue
      self.addSubview(self.topBar)
      self.topBar.translatesAutoresizingMaskIntoConstraints = false
      self.topBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      self.topBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      self.topBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      self.topBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
      
      let leftAccessoryLayer = CAShapeLayer()
      let leftPath = UIBezierPath()
      leftPath.move(to: CGPoint(x: 44.0, y: 0.0))
      leftPath.addLine(to: CGPoint(x: 45.0, y: 0.0))
      leftPath.addLine(to: CGPoint(x: 45.0, y: 44.0))
      leftPath.addLine(to: CGPoint(x: 44.0, y: 44.0))
      leftPath.close()
      leftAccessoryLayer.path = leftPath.cgPath
      leftAccessoryLayer.fillColor = UIColor.amOpaqueBlue.cgColor
      self.topBar.layer.addSublayer(leftAccessoryLayer)
      
      let rightAccessoryLayer = CAShapeLayer()
      let rightPath = UIBezierPath()
      rightPath.move(to: CGPoint(x: self.bounds.size.width - 45.0, y: 0.0))
      rightPath.addLine(to: CGPoint(x: self.bounds.size.width - 44, y: 0.0))
      rightPath.addLine(to: CGPoint(x: self.bounds.size.width - 44, y: 44.0))
      rightPath.addLine(to: CGPoint(x: self.bounds.size.width - 45, y: 44.0))
      rightPath.close()
      rightAccessoryLayer.path = rightPath.cgPath
      rightAccessoryLayer.fillColor = UIColor.amOpaqueBlue.cgColor
      self.topBar.layer.addSublayer(rightAccessoryLayer)
      
      self.previousMonthButton = UIButton()
      self.previousMonthButton.setImage(#imageLiteral(resourceName: "freccetta_previous_month"), for: .normal)
      self.previousMonthButton.addTarget(self, action: #selector(self.previousMonthButtonPressed(sender:)), for: .touchUpInside)
      self.topBar.addSubview(self.previousMonthButton)
      self.previousMonthButton.translatesAutoresizingMaskIntoConstraints = false
      self.previousMonthButton.topAnchor.constraint(equalTo: self.topBar.topAnchor).isActive = true
      self.previousMonthButton.leadingAnchor.constraint(equalTo: self.topBar.leadingAnchor).isActive = true
      self.previousMonthButton.bottomAnchor.constraint(equalTo: self.topBar.bottomAnchor).isActive = true
      self.previousMonthButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
      
      self.nextMonthButton = UIButton()
      self.nextMonthButton.setImage(#imageLiteral(resourceName: "freccetta_next_month"), for: .normal)
      self.nextMonthButton.addTarget(self, action: #selector(self.nextMonthButtonPressed(sender:)), for: .touchUpInside)
      self.topBar.addSubview(self.nextMonthButton)
      self.nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
      self.nextMonthButton.topAnchor.constraint(equalTo: self.topBar.topAnchor).isActive = true
      self.nextMonthButton.trailingAnchor.constraint(equalTo: self.topBar.trailingAnchor).isActive = true
      self.nextMonthButton.bottomAnchor.constraint(equalTo: self.topBar.bottomAnchor).isActive = true
      self.nextMonthButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
      
      self.monthLabel = UILabel()
      self.monthLabel.attributedText = UILabel.attributedString(withText: Date().increaseMonth(by: self.currentMonthIndex).getMonthAndYearText().capitalized, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true)
      self.monthLabel.setLineHeightInset(2.0)
      self.topBar.addSubview(self.monthLabel)
      self.monthLabel.translatesAutoresizingMaskIntoConstraints = false
      self.monthLabel.centerXAnchor.constraint(equalTo: self.topBar.centerXAnchor).isActive = true
      self.monthLabel.centerYAnchor.constraint(equalTo: self.topBar.centerYAnchor).isActive = true
      
      // CALENDAR VIEW setup
      self.calendarBoxView = UIView()
      self.calendarBoxView.backgroundColor = UIColor.clear
      self.addSubview(self.calendarBoxView)
      self.calendarBoxView.translatesAutoresizingMaskIntoConstraints = false
      self.calendarBoxView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor).isActive = true
      self.calendarBoxView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      self.calendarBoxView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      self.calendarBoxView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
      
      var weekDayLabels = [UILabel]()
      for dayOfWeek in Date.weekDays(withShortFormat: true) {
         let weekDayLabel = UILabel()
         weekDayLabel.attributedText = UILabel.attributedString(withText: dayOfWeek.uppercased(), andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 10)!, andCharacterSpacing: nil, isCentered: true)
         weekDayLabel.setLineHeightInset(2.0)
         weekDayLabels.append(weekDayLabel)
      }
      
      self.weekDaysStackView = UIStackView(arrangedSubviews: weekDayLabels)
      self.weekDaysStackView.axis = .horizontal
      self.weekDaysStackView.distribution = .fillEqually
      self.calendarBoxView.addSubview(self.weekDaysStackView)
      self.weekDaysStackView.translatesAutoresizingMaskIntoConstraints = false
      self.weekDaysStackView.topAnchor.constraint(equalTo: self.calendarBoxView.topAnchor, constant: 20.0).isActive = true
      self.weekDaysStackView.leadingAnchor.constraint(equalTo: self.calendarBoxView.leadingAnchor, constant: 20.0).isActive = true
      self.weekDaysStackView.trailingAnchor.constraint(equalTo: self.calendarBoxView.trailingAnchor, constant: -20.0).isActive = true
      self.weekDaysStackView.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
      
      let layout = UICollectionViewFlowLayout()
      layout.itemSize = CGSize(width: (self.bounds.size.width - 40) / 7.0, height: (self.bounds.size.height - 96.0) / 6.0)
      layout.minimumLineSpacing = 0.0
      layout.minimumInteritemSpacing = 0.0
      self.daysCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
      self.daysCollectionView.backgroundColor = UIColor.white
      self.daysCollectionView.dataSource = self
      self.daysCollectionView.delegate = self
      self.daysCollectionView.register(CalendarDayCollectionViewCell.self, forCellWithReuseIdentifier: "calendarDayCellId")
      self.calendarBoxView.addSubview(self.daysCollectionView)
      self.daysCollectionView.translatesAutoresizingMaskIntoConstraints = false
      self.daysCollectionView.topAnchor.constraint(equalTo: self.weekDaysStackView.bottomAnchor, constant: 4.0).isActive = true
      self.daysCollectionView.leadingAnchor.constraint(equalTo: self.calendarBoxView.leadingAnchor, constant: 20.0).isActive = true
      self.daysCollectionView.trailingAnchor.constraint(equalTo: self.calendarBoxView.trailingAnchor, constant: -20.0).isActive = true
      self.daysCollectionView.bottomAnchor.constraint(equalTo: self.calendarBoxView.bottomAnchor, constant: -14.0).isActive = true
   }
   
   @objc func previousMonthButtonPressed(sender: UIButton) {
      self.updateDaysCollectionViewMonth(withValue: -1)
   }
   
   @objc func nextMonthButtonPressed(sender: UIButton) {
      self.updateDaysCollectionViewMonth(withValue: 1)
   }
   
   func updateDaysCollectionViewMonth(withValue value: Int) {
      self.currentMonthIndex += value
   }
   
}

extension GPCalendarView: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return self.calendarDays.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarDayCellId", for: indexPath) as! CalendarDayCollectionViewCell
      cell.setup(withDay: "\(self.calendarDays[indexPath.row].day)", andDayColor: self.calendarDays[indexPath.row].dayColor)
      if abs(indexPath.row - self.previousMonthDays.count + 1) == Date().getDay() && self.currentMonthIndex == 0 {
         cell.dayButton.isToday = true
      }
      if abs(indexPath.row - self.previousMonthDays.count + 1) == self.currentDateSelected.getDay() && Date().increaseMonth(by: self.currentMonthIndex).getMonth() == self.currentDateSelected.getMonth() {
         cell.dayButton.isSelected = true
         self.currentIndexPathSelected = indexPath.row
      }
      return cell
   }
   
   fileprivate func cleanCells() {
      for index in 0...41 {
         if let cell = self.daysCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? CalendarDayCollectionViewCell {
            cell.dayButton.isSelected = false
            cell.dayButton.isToday = false
         }
      }
   }
   
}

extension GPCalendarView: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      guard indexPath.row >= self.previousMonthDays.count else {
         self.updateDaysCollectionViewMonth(withValue: -1)
         return
      }
      guard indexPath.row < (self.previousMonthDays.count + self.currentMonthDays.count) else {
         self.updateDaysCollectionViewMonth(withValue: 1)
         return
      }
      
      if let currentIndexSelected = self.currentIndexPathSelected, currentIndexSelected != indexPath.row {
         if let selectedCell = collectionView.cellForItem(at: IndexPath(row: currentIndexSelected, section: 0)) as? CalendarDayCollectionViewCell {
            selectedCell.dayButton.isSelected = false
         }
      }
      if let currentCell = collectionView.cellForItem(at: indexPath) as? CalendarDayCollectionViewCell {
         currentCell.dayButton.isSelected = true
      }
      self.currentIndexPathSelected = indexPath.row
      self.currentDateSelected = Date().increaseMonth(by: self.currentMonthIndex).convert(toDay: abs(indexPath.row - self.previousMonthDays.count + 1))
   }
}
