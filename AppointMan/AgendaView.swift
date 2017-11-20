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
   func highlightAccessoryTimetable(at index: Int)
   func resetHighlightStateOnAccessoryTimetable()
}

class AgendaView: UIView {
   
   let topHeaderHeight: CGFloat = 92.0
   let leadingHeaderWidth: CGFloat = 80.0
   let numberOfHours: Int = 16
   let numberOfEmployees: Int = 5
   
   var borderLineAgendaTimer: Timer?
   var isBorderLineAgendaTimerRunning: Bool = false
   var borderlineAgendaTimerIsGoing: Direction?
   weak var delegate: AgendaViewDelegate?
   var currentNewAppointmentView: UIView?
   var longPressCancelledOutOfBounds: Bool = false
   
   var isHoveringColomnIndex: Int? {
      willSet {
         guard self.longPressCancelledOutOfBounds == false else { return }
         self.removeColomnHoveringLayer()
         
         if let newValue = newValue {
            self.hoveringColomBackgroundLayer.frame.origin.x = newValue * Const.agendaEmployeeColomnWidth
            self.layer.insertSublayer(self.hoveringColomBackgroundLayer, at: 0)
         }
      }
   }
   
   lazy var hoveringColomBackgroundLayer: CALayer = {
      let hoveringLayer = CALayer()
      hoveringLayer.backgroundColor = UIColor.grayWith(value: 140.0).withAlphaComponent(0.25).cgColor
      hoveringLayer.frame = CGRect(x: 0.0, y: 0.0, width: Const.agendaEmployeeColomnWidth, height: self.bounds.size.height)
      return hoveringLayer
   }()
   
   var agendaScrollView: UIScrollView? {
      return self.superview as? UIScrollView
   }
   
   func removeColomnHoveringLayer() {
      if let sublayers = self.layer.sublayers {
         for layer in sublayers {
            if layer == self.hoveringColomBackgroundLayer {
               layer.removeFromSuperlayer()
            }
         }
      }
   }
   
   lazy var timeIndicatorTopLineView: UIView = {
      let timeIndicatorView = UIView()
      timeIndicatorView.backgroundColor = UIColor(red: 43/255.0, green: 132/255.0, blue: 255/255.0, alpha: 1.0)
      timeIndicatorView.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 1)
      return timeIndicatorView
   }()
   
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
         var originX = Const.agendaEmployeeColomnWidth * index
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
         
         let originY = index * Const.halfHourUnitHeight
         context.move(to: CGPoint(x: 0.0, y: originY))
         context.addLine(to: CGPoint(x: self.bounds.maxX, y: originY))
         context.strokePath()
      }
      
      // drawing half hours separator lines
      context.setLineDash(phase: 0, lengths: [3, 6])
      for index in 1..<self.numberOfHours {
         let originY = index * Const.hourUnitHeight
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
      self.isHoveringColomnIndex = Int(locationInView.x / Const.agendaEmployeeColomnWidth)
      
      switch sender.state {
      case .began:
         let appointmentView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Const.agendaEmployeeColomnWidth, height: Const.hourUnitHeight))
         appointmentView.center = locationInView
         appointmentView.backgroundColor = UIColor.white
         appointmentView.layer.cornerRadius = 3.0
         self.currentNewAppointmentView = appointmentView
         self.addSubview(appointmentView)
         
         self.timeIndicatorTopLineView.frame.origin.y = appointmentView.frame.origin.y
         self.timeIndicatorTopLineView.bounds.size.width = locationInView.x
         //self.addSubview(self.timeIndicatorTopLineView)
         
         self.delegate?.highlightAccessoryTimetable(at: Int((appointmentView.frame.origin.y + 15.0) / Const.quarterHourUnitHeight))
         
         break
      case .changed:
         guard self.longPressCancelledOutOfBounds == false else { return }
         
         self.delegate?.highlightAccessoryTimetable(at: Int((self.currentNewAppointmentView!.frame.origin.y + 15.0) / Const.quarterHourUnitHeight))
         
         if let agendaScrollView = self.superview as? UIScrollView {
            
            let locationInAgendaScrollView = locationInView - agendaScrollView.contentOffset
            if locationInAgendaScrollView.y < 0 || locationInAgendaScrollView.x < 0 {
               self.outOfBoundsReset()
            } else if locationInAgendaScrollView.y < Const.hourUnitHeight {
               self.startBorderLineAgendaTimer(going: .up)
            } else if locationInAgendaScrollView.y > agendaScrollView.bounds.size.height - Const.hourUnitHeight {
               self.startBorderLineAgendaTimer(going: .down)
            } else if locationInAgendaScrollView.x < Const.halfHourUnitHeight {
               self.startBorderLineAgendaTimer(going: .left)
            } else if locationInAgendaScrollView.x > agendaScrollView.bounds.size.width - Const.halfHourUnitHeight {
               self.startBorderLineAgendaTimer(going: .right)
            } else {
               self.stopBorderLineAgendaTimer()
            }
            if let currentNewAppointmentView = self.currentNewAppointmentView {
               currentNewAppointmentView.center = locationInView
               self.timeIndicatorTopLineView.frame.origin.y = currentNewAppointmentView.frame.origin.y
               self.timeIndicatorTopLineView.bounds.size.width = locationInView.x
            }
         }
         
         break
      case .ended:
         guard self.longPressCancelledOutOfBounds == false else {
            self.longPressCancelledOutOfBounds = false
            return
         }
         
         self.delegate?.resetHighlightStateOnAccessoryTimetable()
         
         if let currentNewAppointmentView = self.currentNewAppointmentView {
            if let isHoveringColomnIndex = self.isHoveringColomnIndex {
               UIView.animate(withDuration: 0.25, animations: {
                  currentNewAppointmentView.frame = CGRect(x: isHoveringColomnIndex * Const.agendaEmployeeColomnWidth, y: 0.0, width: Const.agendaEmployeeColomnWidth, height: Const.hourUnitHeight)
                  currentNewAppointmentView.center.y = locationInView.y
               }) { success in
                  if success {
                     self.removeColomnHoveringLayer()
                  }
               }
            }
         }
         
         // è OPTIONAL
         //self.stopBorderLineAgendaTimer()
         break
      default:
         break
      }
   }
   
   func outOfBoundsReset() {
      self.stopBorderLineAgendaTimer()
      self.currentNewAppointmentView?.removeFromSuperview()
      self.currentNewAppointmentView = nil
      self.removeColomnHoveringLayer()
      self.delegate?.resetHighlightStateOnAccessoryTimetable()
      self.longPressCancelledOutOfBounds = true
   }
   
   func startBorderLineAgendaTimer(going: Direction) {
      self.isBorderLineAgendaTimerRunning = true
      self.borderlineAgendaTimerIsGoing = going
      guard borderLineAgendaTimer == nil else { return }
      
      self.borderLineAgendaTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateScrollViewContentOffset), userInfo: nil, repeats: true)
   }
   
   func stopBorderLineAgendaTimer() {
      self.isBorderLineAgendaTimerRunning = false
      guard borderLineAgendaTimer != nil else { return }
      
      borderLineAgendaTimer?.invalidate()
      borderLineAgendaTimer = nil
   }
   
   @objc func updateScrollViewContentOffset(from locationInView: CGPoint) {
      if let going = self.borderlineAgendaTimerIsGoing {
         self.scrollAgenda(to: going)
      }
   }
   
   func scrollAgenda(to: Direction) {
      switch to {
      case .up:
         guard let agendaScrollView = self.agendaScrollView, agendaScrollView.contentOffset.y > 5 else {
            let contentOffset = self.agendaScrollView?.contentOffset.y ?? 0.0
            UIView.animate(withDuration: 0.05, animations: {
               self.agendaScrollView?.contentOffset.y = 0.0
               self.currentNewAppointmentView?.frame.origin.y -= contentOffset
               self.timeIndicatorTopLineView.frame.origin.y -= contentOffset
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            agendaScrollView.contentOffset.y -= 5.0
            self.currentNewAppointmentView?.frame.origin.y -= 5.0
         })
      case .down:
         guard let agendaScrollView = self.agendaScrollView, agendaScrollView.contentOffset.y < agendaScrollView.contentSize.height - 5.0 - agendaScrollView.bounds.size.height else {
            UIView.animate(withDuration: 0.05, animations: {
               if let agendaScrollView = self.agendaScrollView {
                  agendaScrollView.contentOffset.y = self.bounds.size.height - agendaScrollView.bounds.size.height
               }
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            self.agendaScrollView?.contentOffset.y += 5.0
            self.currentNewAppointmentView?.frame.origin.y += 5.0
            self.timeIndicatorTopLineView.frame.origin.y += 5
         })
      case .right:
         guard let agendaScrollView = self.agendaScrollView, agendaScrollView.contentOffset.x < agendaScrollView.contentSize.width - 5.0 - agendaScrollView.bounds.size.width else {
            UIView.animate(withDuration: 0.05, animations: {
               if let agendaScrollView = self.agendaScrollView {
                  agendaScrollView.contentOffset.x = self.bounds.size.width - agendaScrollView.bounds.size.width
               }
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            self.agendaScrollView?.contentOffset.x += 5.0
            self.currentNewAppointmentView?.frame.origin.x += 5.0
            self.timeIndicatorTopLineView.frame.origin.x += 5.0
         })
      case .left:
         guard let agendaScrollView = self.agendaScrollView, agendaScrollView.contentOffset.x > 5 else {
            let contentOffset = self.agendaScrollView?.contentOffset.x ?? 0.0
            UIView.animate(withDuration: 0.05, animations: {
               self.agendaScrollView?.contentOffset.x = 0.0
               self.currentNewAppointmentView?.frame.origin.x -= contentOffset
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            self.agendaScrollView?.contentOffset.x -= 5.0
            self.currentNewAppointmentView?.frame.origin.x -= 5.0
            self.timeIndicatorTopLineView.frame.origin.x -= 5.0
         })
      }
      
      self.delegate?.highlightAccessoryTimetable(at: Int((self.currentNewAppointmentView!.frame.origin.y + 15.0) / Const.quarterHourUnitHeight))
   }
   
}
