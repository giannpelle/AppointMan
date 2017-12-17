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
   func showAddAppointmentController()
}

class AgendaView: UIView {
   
   let topHeaderHeight: CGFloat = 92.0
   let leadingHeaderWidth: CGFloat = 80.0
   let numberOfHours: Int = 16
   let numberOfEmployees: Int = 5
   
   var borderLineAgendaTimer: Timer?
   var isBorderLineAgendaTimerRunning: Bool = false
   var borderLineAgendaTimerDirection: Direction?
   var borderLineAgendaTimerVelocity: Int?
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
            // because i draw the border with layers on top of the scroll view instead
            continue
            //originX += 1.0
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
         
         self.timeIndicatorTopLineView.frame = CGRect(x: 0.0, y: appointmentView.frame.origin.y, width: appointmentView.frame.origin.x, height: 1.0)
         self.addSubview(self.timeIndicatorTopLineView)
         
         self.delegate?.highlightAccessoryTimetable(at: Int((appointmentView.frame.origin.y + 15.0) / Const.quarterHourUnitHeight))
         
         break
      case .changed:
         guard self.longPressCancelledOutOfBounds == false else { return }
         
         self.delegate?.highlightAccessoryTimetable(at: Int((self.currentNewAppointmentView!.frame.origin.y + 15.0) / Const.quarterHourUnitHeight))
         
         if let agendaScrollView = self.agendaScrollView {
            if let currentAppointmentView = self.currentNewAppointmentView {
               let locationInAgendaScrollView = locationInView - agendaScrollView.contentOffset
               if locationInAgendaScrollView.y < 0 || locationInAgendaScrollView.x < 0 {
                  self.outOfBoundsReset()
               } else if locationInAgendaScrollView.y < currentAppointmentView.bounds.size.height / 2.0 + Const.quarterHourUnitHeight {
                  let total = currentAppointmentView.bounds.size.height / 2.0 + Const.quarterHourUnitHeight
                  let part = total - locationInAgendaScrollView.y
                  let speed = part / total
                  let speedRate = Int(speed * 10.0)
                  self.startBorderLineAgendaTimer(going: .up, with: speedRate)
               } else if locationInAgendaScrollView.y > agendaScrollView.bounds.size.height - (currentAppointmentView.bounds.size.height / 2.0 + Const.quarterHourUnitHeight) {
                  let total = currentAppointmentView.bounds.size.height / 2.0 + Const.quarterHourUnitHeight
                  let part = total - (agendaScrollView.bounds.size.height - locationInAgendaScrollView.y)
                  let speed = part / total
                  let speedRate = Int(speed * 10.0)
                  self.startBorderLineAgendaTimer(going: .down, with: speedRate)
               } else if locationInAgendaScrollView.x < currentAppointmentView.bounds.size.width / 2.0 + Const.agendaEmployeeColomnWidth / 5.0 {
                  let total = currentAppointmentView.bounds.size.width / 2.0 + Const.agendaEmployeeColomnWidth / 5.0
                  let part = locationInAgendaScrollView.x
                  let speed = part / total
                  let speedRate = Int((1 - speed) * 10.0)
                  self.startBorderLineAgendaTimer(going: .left, with: speedRate)
               } else if locationInAgendaScrollView.x > agendaScrollView.bounds.size.width - (currentAppointmentView.bounds.size.width / 2.0 + Const.agendaEmployeeColomnWidth / 5.0) {
                  let total = currentAppointmentView.bounds.size.width / 2.0 + Const.agendaEmployeeColomnWidth / 5.0
                  let part = total - (agendaScrollView.bounds.size.width - locationInAgendaScrollView.x)
                  let speed = part / total
                  let speedRate = Int(speed * 10.0)
                  self.startBorderLineAgendaTimer(going: .right, with: speedRate)
               } else {
                  self.stopBorderLineAgendaTimer()
               }
               if let currentNewAppointmentView = self.currentNewAppointmentView {
                  currentNewAppointmentView.center = locationInView
                  self.timeIndicatorTopLineView.frame = CGRect(x: 0.0, y: currentNewAppointmentView.frame.origin.y, width: currentNewAppointmentView.frame.origin.x, height: 1.0)
               }
            }
         }
         
         break
      case .ended:
         guard self.longPressCancelledOutOfBounds == false else {
            self.longPressCancelledOutOfBounds = false
            return
         }
         
         self.delegate?.resetHighlightStateOnAccessoryTimetable()
         
         self.timeIndicatorTopLineView.removeFromSuperview()
         self.timeIndicatorTopLineView.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 1.0)
         
         if let currentNewAppointmentView = self.currentNewAppointmentView {
            if let isHoveringColomnIndex = self.isHoveringColomnIndex {
               UIView.animate(withDuration: 0.25, animations: {
                  currentNewAppointmentView.frame.origin = CGPoint(x: isHoveringColomnIndex * Const.agendaEmployeeColomnWidth, y: self.nearestCorrectPositionFor(appointmentAt: currentNewAppointmentView.frame.origin))
                  self.stopBorderLineAgendaTimer()
               }) { success in
                  if success {
                     self.removeColomnHoveringLayer()
                     
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.delegate?.showAddAppointmentController()
                     })
                  }
               }
            }
         }

         break
      default:
         break
      }
   }
   
   func nearestCorrectPositionFor(appointmentAt position: CGPoint) -> CGFloat {
      let quartersBefore = Int(position.y / Const.quarterHourUnitHeight)
      let distanceBetweenBefore = abs(position.y - (quartersBefore * Const.quarterHourUnitHeight))
      let distanceBetweenAfter = abs(position.y - ((quartersBefore + 1) * Const.quarterHourUnitHeight))
      if distanceBetweenBefore < distanceBetweenAfter {
         return quartersBefore * Const.quarterHourUnitHeight
      } else {
         return (quartersBefore + 1) * Const.quarterHourUnitHeight
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
   
   func startBorderLineAgendaTimer(going: Direction, with speedRate: Int) {
      self.isBorderLineAgendaTimerRunning = true
      self.borderLineAgendaTimerDirection = going
      self.borderLineAgendaTimerVelocity = speedRate
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
      if let going = self.borderLineAgendaTimerDirection, let speedRate = self.borderLineAgendaTimerVelocity {
         self.scrollAgenda(to: going, with: speedRate)
      }
   }
   
   func scrollAgenda(to: Direction, with speedRate: Int) {
      let offsetToUpdate = 5.0 + speedRate * 3.0
      
      switch to {
      case .up:
         guard let agendaScrollView = self.agendaScrollView, agendaScrollView.contentOffset.y > offsetToUpdate else {
            let contentOffset = self.agendaScrollView?.contentOffset.y ?? 0.0
            UIView.animate(withDuration: 0.05, animations: {
               self.agendaScrollView?.contentOffset.y = 0.0
               self.currentNewAppointmentView?.frame.origin.y -= contentOffset
               self.timeIndicatorTopLineView.frame.origin.y -= contentOffset
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            agendaScrollView.contentOffset.y -= offsetToUpdate
            self.currentNewAppointmentView?.frame.origin.y -= offsetToUpdate
            self.timeIndicatorTopLineView.frame.origin.y -= offsetToUpdate
         })
      case .down:
         guard let agendaScrollView = self.agendaScrollView, agendaScrollView.contentOffset.y < agendaScrollView.contentSize.height - offsetToUpdate - agendaScrollView.bounds.size.height else {
            UIView.animate(withDuration: 0.05, animations: {
               if let agendaScrollView = self.agendaScrollView {
                  agendaScrollView.contentOffset.y = self.bounds.size.height - agendaScrollView.bounds.size.height
               }
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            agendaScrollView.contentOffset.y += offsetToUpdate
            self.currentNewAppointmentView?.frame.origin.y += offsetToUpdate
            self.timeIndicatorTopLineView.frame.origin.y += offsetToUpdate
         })
      case .right:
         guard let agendaScrollView = self.agendaScrollView, agendaScrollView.contentOffset.x < agendaScrollView.contentSize.width - offsetToUpdate - agendaScrollView.bounds.size.width else {
            UIView.animate(withDuration: 0.05, animations: {
               if let agendaScrollView = self.agendaScrollView {
                  agendaScrollView.contentOffset.x = self.bounds.size.width - agendaScrollView.bounds.size.width
               }
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            agendaScrollView.contentOffset.x += offsetToUpdate
            self.currentNewAppointmentView?.frame.origin.x += offsetToUpdate
            self.timeIndicatorTopLineView.frame.origin.x += offsetToUpdate
         })
      case .left:
         guard let agendaScrollView = self.agendaScrollView, agendaScrollView.contentOffset.x > offsetToUpdate else {
            let contentOffset = self.agendaScrollView?.contentOffset.x ?? 0.0
            UIView.animate(withDuration: 0.05, animations: {
               self.agendaScrollView?.contentOffset.x = 0.0
               self.currentNewAppointmentView?.frame.origin.x -= contentOffset
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            agendaScrollView.contentOffset.x -= offsetToUpdate
            self.currentNewAppointmentView?.frame.origin.x -= offsetToUpdate
            self.timeIndicatorTopLineView.frame.origin.x -= offsetToUpdate
         })
      }
      
      self.delegate?.highlightAccessoryTimetable(at: Int((self.currentNewAppointmentView!.frame.origin.y + 15.0) / Const.quarterHourUnitHeight))
   }
   
   /*
   func colomnIndex(for employee: Employee) -> Int {
      return employees.index(where: { $0 == employee })
   }
   */
   
//   func draw(appointment: (time: String, service: String, duration: AppointmentDuration, serviceColor: UIColor, customer: String, description: String?)) {
//      if let appointmentView = UINib(nibName: "AppointmentView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? AppointmentView {
//         appointmentView.appointment = appointment
//         let colomnIndex = 0//self.colomnIndex(for: .Francesca)
//         appointmentView.frame = CGRect(x: Const.agendaEmployeeColomnWidth * colomnIndex, y: <#T##CGFloat#>, width: Const.agendaEmployeeColomnWidth, height: appointment.duration.rawValue / 5.0 * 10.0)
//      }
//   }
}


