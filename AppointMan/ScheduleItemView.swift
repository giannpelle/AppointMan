//
//  ScheduleItem.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 6/6/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ScheduleItemView: UIView {
   
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
      
      //1
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context.saveGState()
      //2
      context.setStrokeColor(red: 200 / 255.0, green: 212 / 255.0, blue: 230 / 255.0, alpha: 1.0)
      context.setLineCap(.square)
      context.setLineWidth(Const.employeeColomnSpacing)
      
      if self.tag == 1 {
         for index in 0..<Int(Const.numberOfMorningHours) {
            context.setLineDash(phase: 0.0, lengths: [self.bounds.size.width])
            context.move(to: CGPoint(x: 0, y: Int(Const.halfHourUnitHeight) + Int(Const.hourUnitHeight) * index - 1))
            context.addLine(to: CGPoint(x: Int(self.bounds.size.width), y: Int(Const.halfHourUnitHeight) + Int(Const.hourUnitHeight) * index - 1))
            context.strokePath()
            
            context.setLineDash(phase: 0, lengths: [6, 12])
            context.move(to: CGPoint(x: 0, y: Int(Const.hourUnitHeight) * index - 1))
            context.addLine(to: CGPoint(x: Int(self.bounds.size.width), y: Int(Const.hourUnitHeight) * index - 1))
            context.strokePath()
         }
      }
      
      if self.tag == 2 {
         for index in 0..<Int(Const.numberOfAfternoonHours) {
            context.setLineDash(phase: 0.0, lengths: [self.bounds.size.width])
            context.move(to: CGPoint(x: 0, y: Int(Const.halfHourUnitHeight) + Int(Const.hourUnitHeight) * index - 1))
            context.addLine(to: CGPoint(x: Int(self.bounds.size.width), y: Int(Const.halfHourUnitHeight) + Int(Const.hourUnitHeight) * index - 1))
            context.strokePath()
            
            context.setLineDash(phase: 0, lengths: [6, 12])
            context.move(to: CGPoint(x: 0, y: Int(Const.hourUnitHeight) * index - 1))
            context.addLine(to: CGPoint(x: Int(self.bounds.size.width), y: Int(Const.hourUnitHeight) * index - 1))
            context.strokePath()
         }
      }
      
      //3
      context.restoreGState()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
   }
   
   
}
