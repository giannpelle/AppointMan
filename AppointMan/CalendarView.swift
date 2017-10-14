//
//  CalendarView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/15/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class CalendarView: UIView {
   
   let numberOfMorningHours: CGFloat = 6.0
   let numberOfAfternoonHours: CGFloat = 4.0
   
   var morningViews: [ScheduleItemView] = []
   var afternoonViews: [ScheduleItemView] = []
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.backgroundColor = UIColor.clear
      
      for index in 0..<Int(Const.numberOfEmployees) {
         
         let morningView = ScheduleItemView(frame: CGRect(x: CGFloat(index) * Const.employeeHeaderWidth + (CGFloat(index) * Const.employeeColomnSpacing), y: 0.0, width: Const.employeeHeaderWidth, height: Const.hourUnitHeight * self.numberOfMorningHours))
         morningView.tag = 1
         morningView.backgroundColor = UIColor.white
         self.addSubview(morningView)
         self.morningViews.append(morningView)
         
         let afternoonView = ScheduleItemView(frame: CGRect(x: CGFloat(index) * Const.employeeHeaderWidth + (CGFloat(index) * Const.employeeColomnSpacing), y: Const.hourUnitHeight * self.numberOfMorningHours + Const.halfdayBreakSpacing, width: Const.employeeHeaderWidth, height: Const.hourUnitHeight * self.numberOfAfternoonHours))
         afternoonView.tag = 2
         afternoonView.backgroundColor = UIColor.white
         self.addSubview(afternoonView)
         self.afternoonViews.append(afternoonView)
         
      }
      
   }
   
   func drawRect() {
      
   }
   
}
