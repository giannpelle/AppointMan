//
//  GPSliderDatePickerView.swift
//  GPSliderDatePicker
//
//  Created by Gianluigi Pelle on 8/27/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol GPSliderDatePickerViewDelegate {
   func sliderDatePickerView(sliderDatePickerView: GPSliderDatePickerView, didSelectDate: Date)
}

class GPSliderDatePickerView: UIView {
   
   var currentDayAccessoryView: UIView!
   var currentDayAccessoryLabel: UILabel!
   var daysCollectionView: UICollectionView!
   
   var delegate: GPSliderDatePickerViewDelegate?
   
   var currentDateSelected: Date = Date() {
      didSet {
         print(self.currentDateSelected.getFullDayDescription())
         self.currentDayAccessoryLabel.attributedText = UILabel.attributedString(withText: self.currentDateSelected.getFullDayDescription(), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 12.0) ?? UIFont.systemFont(ofSize: 12), andCharacterSpacing: nil, isCentered: true)
         self.currentDayAccessoryLabel.setLineHeightInset(2.0)
         self.delegate?.sliderDatePickerView(sliderDatePickerView: self, didSelectDate: self.currentDateSelected)
         let date1 = Calendar.current.startOfDay(for: Date().startOfMonth())
         let date2 = Calendar.current.startOfDay(for: self.currentDateSelected.startOfMonth())
         let numberOfMonths: Int = Calendar.current.dateComponents([.month], from: date1, to: date2).month ?? 0
         self.currentMonthIndex = numberOfMonths
         DispatchQueue.main.async {
            self.daysCollectionView.reloadData()
            self.daysCollectionView.scrollToItem(at: IndexPath(row: self.currentDateSelected.getDay() - 1, section: 2), at: .centeredHorizontally, animated: false)
         }
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.currentDayAccessoryView.isHidden = true
         })
      }
   }
   var currentMonthIndex: Int = 0
   var firstMonth: [Int] {
      return [Int](1...Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: -2).getNumberOfDaysInMonth())
   }
   var secondMonth: [Int] {
      return [Int](1...Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: -1).getNumberOfDaysInMonth())
   }
   var thirdMonth: [Int] {
      return [Int](1...Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: 0).getNumberOfDaysInMonth())
   }
   var fourthMonth: [Int] {
      return [Int](1...Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: 1).getNumberOfDaysInMonth())
   }
   var fifthMonth: [Int] {
      return [Int](1...Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: 2).getNumberOfDaysInMonth())
   }
   var calendarDays: [[Int]] {
      get {
         return [self.firstMonth, self.secondMonth, self.thirdMonth, self.fourthMonth, self.fifthMonth]
      }
   }
   var didSelectIndexPath: IndexPath?
   
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
   
   func setup() {
      
      self.currentDayAccessoryView = UIView()
      self.addSubview(self.currentDayAccessoryView)
      self.currentDayAccessoryView.translatesAutoresizingMaskIntoConstraints = false
      self.currentDayAccessoryView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5.0).isActive = true
      self.currentDayAccessoryView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      self.currentDayAccessoryView.widthAnchor.constraint(equalToConstant: 160.0).isActive = true
      self.currentDayAccessoryView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
      
      self.currentDayAccessoryLabel = UILabel()
      self.currentDayAccessoryLabel.attributedText = UILabel.attributedString(withText: Date().getFullDayDescription(), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 12.0) ?? UIFont.systemFont(ofSize: 12), andCharacterSpacing: nil, isCentered: true)
      self.currentDayAccessoryLabel.setLineHeightInset(2.0)
      self.currentDayAccessoryView.addSubview(self.currentDayAccessoryLabel)
      self.currentDayAccessoryLabel.translatesAutoresizingMaskIntoConstraints = false
      self.currentDayAccessoryLabel.leadingAnchor.constraint(equalTo: self.currentDayAccessoryView.leadingAnchor, constant: 10.0).isActive = true
      self.currentDayAccessoryLabel.trailingAnchor.constraint(equalTo: self.currentDayAccessoryView.trailingAnchor, constant: -10.0).isActive = true
      self.currentDayAccessoryLabel.centerYAnchor.constraint(equalTo: self.currentDayAccessoryView.centerYAnchor, constant: -2.5).isActive = true
      
      let layout = UICollectionViewFlowLayout()
      layout.itemSize = CGSize(width: self.bounds.size.width / 11.0, height: self.bounds.size.height)
      layout.minimumLineSpacing = 0.0
      layout.minimumInteritemSpacing = 0.0
      layout.scrollDirection = .horizontal
      self.daysCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
      self.daysCollectionView.backgroundColor = UIColor.amDarkBlue
      self.daysCollectionView.showsHorizontalScrollIndicator = false
      self.daysCollectionView.dataSource = self
      self.daysCollectionView.delegate = self
      self.daysCollectionView.register(SliderDatePickerDayCollectionViewCell.self, forCellWithReuseIdentifier: "sliderDatePickerDayCellId")
      self.addSubview(self.daysCollectionView)
      self.daysCollectionView.translatesAutoresizingMaskIntoConstraints = false
      self.daysCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      self.daysCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      self.daysCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      self.daysCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      self.daysCollectionView.scrollToItem(at: IndexPath(row: Date().getDay() - 1, section: 2), at: .centeredHorizontally, animated: false)
      self.currentDayAccessoryView.isHidden = true
      
      let bubbleLayer = CAShapeLayer()
      bubbleLayer.path = self.currentDayAccessoryView.topBubblePath().cgPath
      bubbleLayer.fillColor = UIColor.amSliderDatePickerBubble.cgColor
      self.currentDayAccessoryView.layer.insertSublayer(bubbleLayer, at: 0)
   }
}

extension GPSliderDatePickerView: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return self.calendarDays.count
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return self.calendarDays[section].count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderDatePickerDayCellId", for: indexPath) as! SliderDatePickerDayCollectionViewCell
      cell.backgroundColor = UIColor.clear
      cell.setup(withDay: "\(self.calendarDays[indexPath.section][indexPath.row])")
      if indexPath.section == 2 && indexPath.row == self.currentDateSelected.getDay() - 1 {
         cell.isDaySelected = true
      } else {
         cell.isDaySelected = false
      }
      if self.currentMonthIndex == 0 && indexPath.section == 2 && indexPath.row == Date().getDay() - 1 || self.currentMonthIndex == 1 && indexPath.section == 1 && indexPath.row == Date().getDay() - 1 || self.currentMonthIndex == 2 && indexPath.section == 0 && indexPath.row == Date().getDay() - 1 || self.currentMonthIndex == -1 && indexPath.section == 3 && indexPath.row == Date().getDay() - 1 || self.currentMonthIndex == -2 && indexPath.section == 4 && indexPath.row == Date().getDay() - 1 {
         cell.isToday = true
      } else {
         cell.isToday = false
      }
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if let cell = cell as? SliderDatePickerDayCollectionViewCell {
         cell.isToday = false
         if self.currentMonthIndex == 0 && indexPath.section == 2 && indexPath.row == Date().getDay() - 1 || self.currentMonthIndex == 1 && indexPath.section == 1 && indexPath.row == Date().getDay() - 1 || self.currentMonthIndex == 2 && indexPath.section == 0 && indexPath.row == Date().getDay() - 1 || self.currentMonthIndex == -1 && indexPath.section == 3 && indexPath.row == Date().getDay() - 1 || self.currentMonthIndex == -2 && indexPath.section == 4 && indexPath.row == Date().getDay() - 1 {
            cell.isToday = true
         } else {
            cell.isToday = false
         }
      }
      
   }
   
   func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if let cell = cell as? SliderDatePickerDayCollectionViewCell {
         cell.isToday = false
      }
   }
}

extension GPSliderDatePickerView: UICollectionViewDelegate {
   
//   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//      
//      collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//      DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { 
//         DispatchQueue.main.async {
//            self.currentDateSelected = Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: indexPath.section - 2).convert(toDay: self.calendarDays[indexPath.section][indexPath.row])
//         }
//      }
//   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      self.didSelectIndexPath = indexPath
      
      var numberOfCellsBefore: Int = 0
      if indexPath.row == 0 {
         numberOfCellsBefore = indexPath.row
      } else {
         for i in 0..<indexPath.section {
            numberOfCellsBefore += self.calendarDays[i].count
         }
         numberOfCellsBefore += indexPath.row
      }
      numberOfCellsBefore -= 5
      
      let contentOffsetX = numberOfCellsBefore * Int(self.bounds.size.width / 11.0)
      collectionView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
      // updating UI to make bigger and whiter FONT
      if let visibleCells = self.daysCollectionView.visibleCells as? [SliderDatePickerDayCollectionViewCell] {
         for cell in visibleCells {
            let value = abs(cell.superview!.convert(cell.frame, to: self).midX - self.daysCollectionView.frame.size.width / 2.0)
            if value <= cell.bounds.size.width {
               let percentage = (value * 1.0 / cell.bounds.size.width)
               cell.dayLabel.attributedText = UILabel.attributedString(withText: cell.dayLabel.attributedText?.string ?? "", andTextColor: UIColor.getMiddleColor(fromColor: UIColor.amOpaqueBlue, toColor: UIColor.white, withPercentage: 1 - percentage), andFont: UIFont.init(name: "SFUIText-Bold", size: (21.0 - 13.0) - (value * (21.0 - 13.0) / cell.bounds.size.width) + 13.0) ?? UIFont.systemFont(ofSize: (21.0 - 13.0) - (value * (21.0 - 13.0) / cell.bounds.size.width) + 13.0), andCharacterSpacing: nil, isCentered: true)
               cell.dayLabel.setLineHeightInset(2.0)
            } else {
               cell.dayLabel.attributedText = UILabel.attributedString(withText: cell.dayLabel.attributedText?.string ?? "", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0), andCharacterSpacing: nil, isCentered: true)
               cell.dayLabel.setLineHeightInset(2.0)
            }
         }
      }
      
      self.currentDayAccessoryView.isHidden = false
      
      // updating accessoryLabel to display current Date being displayed
      let scrollViewCurrentCenterX = scrollView.contentOffset.x + (scrollView.bounds.size.width / 2.0)
      if let cellWidth = (self.daysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize.width {
         let leftCellIndex = CGFloat(Int(scrollViewCurrentCenterX / cellWidth))
         let rightCellIndex = CGFloat(Int(scrollViewCurrentCenterX / cellWidth) + 1)
         let leftCellDistance = abs(scrollViewCurrentCenterX - (leftCellIndex * cellWidth + (cellWidth / 2.0)))
         let rightCellDistance = abs(scrollViewCurrentCenterX - (rightCellIndex * cellWidth + (cellWidth / 2.0)))
         let nearestCellIndex = rightCellDistance < leftCellDistance ? rightCellIndex : leftCellIndex
         let newIndexPath = self.getIndexPath(fromCurrentIndex: Int(nearestCellIndex))
         self.currentDayAccessoryLabel.attributedText = UILabel.attributedString(withText: Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: newIndexPath.section - 2).convert(toDay: self.calendarDays[newIndexPath.section][newIndexPath.row]).getFullDayDescription(), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 12.0) ?? UIFont.systemFont(ofSize: 12), andCharacterSpacing: nil, isCentered: true)
         self.currentDayAccessoryLabel.setLineHeightInset(2.0)
      }
   }
   
   func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      guard !decelerate else {
         return
      }
      
      let scrollViewCurrentCenterX = scrollView.contentOffset.x + (scrollView.bounds.size.width / 2.0)
      if let cellWidth = (self.daysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize.width {
         let leftCellIndex = CGFloat(Int(scrollViewCurrentCenterX / cellWidth))
         let rightCellIndex = CGFloat(Int(scrollViewCurrentCenterX / cellWidth) + 1)
         let leftCellDistance = abs(scrollViewCurrentCenterX - (leftCellIndex * cellWidth + (cellWidth / 2.0)))
         let rightCellDistance = abs(scrollViewCurrentCenterX - (rightCellIndex * cellWidth + (cellWidth / 2.0)))
         let nearestCellIndex = rightCellDistance < leftCellDistance ? rightCellIndex : leftCellIndex
         UIView.animate(withDuration: 0.3, animations: {
            scrollView.contentOffset.x = (nearestCellIndex - 5) * cellWidth
         }) { (success) in
            if success {
               let newIndexPath = self.getIndexPath(fromCurrentIndex: Int(nearestCellIndex))
               self.currentDateSelected = Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: newIndexPath.section - 2).convert(toDay: self.calendarDays[newIndexPath.section][newIndexPath.row])
            }
         }
      }
   }
   
   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      
      let scrollViewCurrentCenterX = scrollView.contentOffset.x + (scrollView.bounds.size.width / 2.0)
      if let cellWidth = (self.daysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize.width {
         let leftCellIndex = CGFloat(Int(scrollViewCurrentCenterX / cellWidth))
         let rightCellIndex = CGFloat(Int(scrollViewCurrentCenterX / cellWidth) + 1)
         let leftCellDistance = abs(scrollViewCurrentCenterX - (leftCellIndex * cellWidth + (cellWidth / 2.0)))
         let rightCellDistance = abs(scrollViewCurrentCenterX - (rightCellIndex * cellWidth + (cellWidth / 2.0)))
         let nearestCellIndex = rightCellDistance < leftCellDistance ? rightCellIndex : leftCellIndex
         UIView.animate(withDuration: 0.3, animations: {
            scrollView.contentOffset.x = (nearestCellIndex - 5) * cellWidth
         }) { (success) in
            if success {
               let newIndexPath = self.getIndexPath(fromCurrentIndex: Int(nearestCellIndex))
               self.currentDateSelected = Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: newIndexPath.section - 2).convert(toDay: self.calendarDays[newIndexPath.section][newIndexPath.row])
            }
         }
      }
   }
   
   func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
      
      if let indexPath = self.didSelectIndexPath {
         self.currentDateSelected = Date().increaseMonth(by: self.currentMonthIndex).increaseMonth(by: indexPath.section - 2).convert(toDay: self.calendarDays[indexPath.section][indexPath.row])
         self.didSelectIndexPath = nil
      }
   }
   
   func getIndexPath(fromCurrentIndex currentIndex: Int) -> IndexPath {
      
      var row: Int = 0
      var section: Int = 0
      for index in 0..<self.calendarDays.count {
         var count: Int = 0
         for i in 0...index {
            count += self.calendarDays[i].count
         }
         if currentIndex < count {
            section = index
            if index > 0 {
               row = currentIndex - (count - self.calendarDays[index].count)
            } else {
               row = currentIndex
            }
            break
         }
      }
      return IndexPath(row: row, section: section)
   }
}
