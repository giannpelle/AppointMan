//
//  AgendaView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/17/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

enum Direction: Int {
   case up = 0, left, right, down
}

protocol AgendaViewDelegate: class {
   func scrollAgenda(to: Direction)
}

class AgendaView: UIView {
   let topHeaderHeight: CGFloat = 92.0
   let hourUnitHeight: CGFloat = 120.0
   let halfHourUnitHeight: CGFloat = 60.0
   let leadingHeaderWidth: CGFloat = 80.0
   var colomnWidth: CGFloat = 240.0
   let numberOfHours: Int = 16
   let numberOfEmployees: Int = 5
   
   var isHoveringColomnIndex: Int? {
      willSet {
         self.removeColomnHoveringLayer()
         
         if let newValue = newValue {
            self.hoveringColomBackgroundLayer.frame.origin.x = newValue * self.colomnWidth
            self.layer.insertSublayer(self.hoveringColomBackgroundLayer, at: 0)
         }
      }
   }
   var borderLineAgendaTimer: Timer?
   var isBorderLineAgendaTimerRunning: Bool = false
   weak var delegate: AgendaViewDelegate?
   
   lazy var hoveringColomBackgroundLayer: CALayer = {
      let hoveringLayer = CALayer()
      hoveringLayer.backgroundColor = UIColor.grayWith(value: 140.0).withAlphaComponent(0.25).cgColor
      hoveringLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.colomnWidth, height: self.bounds.size.height)
      return hoveringLayer
   }()
   var currentNewAppointmentView: UIView?
   
   func removeColomnHoveringLayer() {
      if let sublayers = self.layer.sublayers {
         for layer in sublayers {
            if layer == self.hoveringColomBackgroundLayer {
               layer.removeFromSuperlayer()
            }
         }
      }
   }
   
   override func draw(_ rect: CGRect) {
      
      //1
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context.saveGState()
      //2
      context.setStrokeColor(UIColor.amDarkBlue.withAlphaComponent(0.3).cgColor)
      context.setLineCap(.square)
      context.setLineWidth(2.0)
      
      // drawing vertical separator lines
      for index in 0...self.numberOfEmployees {
         var originX = self.colomnWidth * index
         if index == 0 {
            originX += 1.0
         } else if index == self.numberOfEmployees {
            originX -= 1.0
         }
         context.move(to: CGPoint(x: originX, y: 0.0))
         context.addLine(to: CGPoint(x: originX, y: self.bounds.maxY))
         context.strokePath()
      }
      
      // drawing hours separator lines
      for index in 1..<self.numberOfHours * 2 {
         if index % 2 == 0 { continue }
         
         let originY = index * halfHourUnitHeight
         context.move(to: CGPoint(x: 0.0, y: originY))
         context.addLine(to: CGPoint(x: self.bounds.maxX, y: originY))
         context.strokePath()
      }
      
      // drawing half hours separator lines
      context.setLineDash(phase: 0, lengths: [3, 6])
      for index in 1..<self.numberOfHours {
         let originY = index * hourUnitHeight
         context.move(to: CGPoint(x: 0.0, y: originY))
         context.addLine(to: CGPoint(x: self.bounds.maxX, y: originY))
         context.strokePath()
      }
      
      //3
      context.restoreGState()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      let longPressGestureRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.handleGesture(sender:)))
      self.addGestureRecognizer(longPressGestureRecog)
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
   }
   
   @objc func handleGesture(sender: UILongPressGestureRecognizer) {
      // variables setup every time
      let locationInView = sender.location(in: self)
      self.isHoveringColomnIndex = Int(locationInView.x / self.colomnWidth)
      
      switch sender.state {
      case .began:
         let appointmentView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.colomnWidth, height: self.hourUnitHeight))
         appointmentView.center = locationInView
         appointmentView.backgroundColor = UIColor.purple
         self.currentNewAppointmentView = appointmentView
         self.addSubview(appointmentView)
         break
      case .changed:
         
         if let agendaScrollView = self.superview as? UIScrollView {
            
            let locationInAgendaScrollView = locationInView - agendaScrollView.contentOffset
            if locationInAgendaScrollView.y < 0 || locationInAgendaScrollView.x < 0 {
               self.stopBorderLineAgendaTimer()
            } else if locationInAgendaScrollView.y < self.hourUnitHeight {
               self.startBorderLineAgendaTimer()
               if let currentNewAppointmentView = self.currentNewAppointmentView {
                  currentNewAppointmentView.center = locationInView
               }
            } else {
               self.stopBorderLineAgendaTimer()
               if let currentNewAppointmentView = self.currentNewAppointmentView {
                  currentNewAppointmentView.center = locationInView
               }
            }
         }
         
         break
      case .ended:
         if let currentNewAppointmentView = self.currentNewAppointmentView {
            if let isHoveringColomnIndex = self.isHoveringColomnIndex {
               UIView.animate(withDuration: 0.25, animations: {
                  currentNewAppointmentView.frame = CGRect(x: isHoveringColomnIndex * self.colomnWidth, y: 0.0, width: self.colomnWidth, height: self.hourUnitHeight)
                  currentNewAppointmentView.center.y = locationInView.y
               }) { success in
                  if success {
                     self.removeColomnHoveringLayer()
                  }
               }
            }
         }
         break
      default:
         break
      }
   }
   
   func startBorderLineAgendaTimer() {
      self.isBorderLineAgendaTimerRunning = true
      guard borderLineAgendaTimer == nil else { return }
      
      self.borderLineAgendaTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateScrollViewContentOffset), userInfo: nil, repeats: true)
   }
   
   func stopBorderLineAgendaTimer() {
      self.isBorderLineAgendaTimerRunning = false
      guard borderLineAgendaTimer != nil else { return }
      
      borderLineAgendaTimer?.invalidate()
      borderLineAgendaTimer = nil
   }
   
   @objc func updateScrollViewContentOffset(from locationInView: CGPoint) {
      self.delegate?.scrollAgenda(to: .up)
   }
   
}
