//
//  ClosingDaysCalendarBackgroundView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/11/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ClosingDaysCalendarBackgroundView: UIView {
   
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      //1
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context.saveGState()
      //2
      context.setStrokeColor(UIColor.amDarkBlue.withAlphaComponent(0.3).cgColor)
      context.setLineCap(.square)
      context.setLineWidth(2.0)
      
      // drawing vertical separator lines
      for index in 1...6 {
         let originX = self.bounds.size.width * (CGFloat(index) / 7.0)
         context.move(to: CGPoint(x: originX, y: 0.0))
         context.addLine(to: CGPoint(x: originX, y: self.bounds.maxY))
         context.strokePath()
      }
      
      // drawing horizontal separator lines
      for index in 1...5 {
         let originY = self.bounds.size.height * (CGFloat(index) / 6)
         context.move(to: CGPoint(x: 0.0, y: originY))
         context.addLine(to: CGPoint(x: self.bounds.maxX, y: originY))
         context.strokePath()
      }
      
      //3
      context.restoreGState()
   }
   
}
