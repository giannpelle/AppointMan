//
//  CalendarDayButton.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/31/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class CalendarDayButton: UIButton {

   lazy var selectionLayer: CAShapeLayer = {
      let layer = CAShapeLayer()
      let path = UIBezierPath(ovalIn: CGRect(x: 4.0, y: 4.0, width: 28.0, height: 28.0))
      layer.path = path.cgPath
      layer.fillColor = UIColor.amBlue.cgColor
      return layer
   }()
   
   lazy var todayLayer: CAShapeLayer = {
      let layer = CAShapeLayer()
      let path = UIBezierPath()
      path.move(to: CGPoint(x: 12.0, y: 28.0))
      path.addLine(to: CGPoint(x: 12.0 + 12.0, y: 28.0))
      path.addLine(to: CGPoint(x: 12.0 + 12.0, y: 30.0))
      path.addLine(to: CGPoint(x: 12.0, y: 30.0))
      path.close()
      layer.path = path.cgPath
      layer.fillColor = UIColor.amOpaqueBlue.cgColor
      return layer
   }()
   
   override var isSelected: Bool {
      didSet {
         if self.isSelected {
            if let sublayers = self.layer.sublayers, sublayers.contains(self.selectionLayer) {
               for layer in sublayers {
                  if layer == self.selectionLayer {
                     layer.removeFromSuperlayer()
                  }
               }
            }
            if let sublayers = self.layer.sublayers, sublayers.contains(self.todayLayer) {
               self.layer.insertSublayer(self.selectionLayer, at: 1)
            } else {
               self.layer.insertSublayer(self.selectionLayer, at: 0)
            }
         } else {
            if let sublayers = self.layer.sublayers, sublayers.contains(self.selectionLayer) {
               for layer in sublayers {
                  if layer == self.selectionLayer {
                     layer.removeFromSuperlayer()
                  }
               }
            }
         }
      }
   }
   
   var isToday: Bool = false {
      didSet {
         if self.isToday {
            if let sublayers = self.layer.sublayers, sublayers.contains(self.todayLayer) {
               for layer in sublayers {
                  if layer == self.todayLayer {
                     layer.removeFromSuperlayer()
                  }
               }
            }
            self.layer.insertSublayer(self.todayLayer, at: 0)
         } else {
            if let sublayers = self.layer.sublayers, sublayers.contains(self.todayLayer) {
               for layer in sublayers {
                  if layer == self.todayLayer {
                     layer.removeFromSuperlayer()
                  }
               }
            }
         }
      }
   }

}
