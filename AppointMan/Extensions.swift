//
//  Utility.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/11/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit

protocol Overlayable {
   func drawOverlay(_ rect: CGRect)
}

extension Overlayable {
   func drawOverlay(_ rect: CGRect) {
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context.saveGState()
      context.setLineWidth(3.2)
      context.setLineCap(.square)
      context.setStrokeColor(UIColor.amDarkBlue.withAlphaComponent(0.3).cgColor)
      
      if rect.size.width == rect.size.height {
         for i in 0...Int((rect.size.width - 1.6) / 6.2) {
            context.move(to: CGPoint(x: 1.6 + (6.2 * CGFloat(i)), y: 0.0))
            context.addLine(to: CGPoint(x: 0.0, y: 1.6 + (6.2 * CGFloat(i))))
            context.strokePath()
         }
         let emptySpaceLength: CGFloat = rect.size.width - (CGFloat(Int((rect.size.width - 1.6) / 6.2)) * 6.2 + 1.6)
         for i in 0..<Int(rect.size.height / 6.2) {
            context.move(to: CGPoint(x: rect.maxX, y: (6.2 - emptySpaceLength) + (6.2 * CGFloat(i))))
            context.addLine(to: CGPoint(x: (6.2 - emptySpaceLength) + (6.2 * CGFloat(i)), y: rect.maxY))
            context.strokePath()
         }
      } else if rect.size.width > rect.size.height {
         let emptySpaceHeightLength: CGFloat = rect.size.height - (CGFloat(Int((rect.size.height - 1.6) / 6.2)) * 6.2 + 1.6)
         let emptySpaceWidthLength: CGFloat = rect.size.width - (CGFloat(Int((rect.size.width - 1.6) / 6.2)) * 6.2 + 1.6)
         
         var lastXIndex: Int = 0
         var lastYIndex: Int = 0
         for i in 0...Int((rect.size.width - 1.6) / 6.2) {
            if i <= Int((rect.size.height - 1.6) / 6.2) {
               context.move(to: CGPoint(x: 1.6 + (6.2 * CGFloat(i)), y: 0.0))
               context.addLine(to: CGPoint(x: 0.0, y: 1.6 + (6.2 * CGFloat(i))))
               context.strokePath()
               lastXIndex = i
            } else {
               context.move(to: CGPoint(x: 1.6 + (6.2 * CGFloat(i)), y: 0.0))
               context.addLine(to: CGPoint(x: (6.2 - emptySpaceHeightLength) + (6.2 * CGFloat(i - (lastXIndex + 1))), y: rect.maxY))
               context.strokePath()
               lastYIndex = i - (lastXIndex + 1)
            }
         }
         for i in 0...Int(rect.size.height / 6.2) {
            context.move(to: CGPoint(x: rect.maxX, y: (6.2 - emptySpaceWidthLength) + (6.2 * CGFloat(i))))
            context.addLine(to: CGPoint(x: (6.2 - emptySpaceHeightLength) + (CGFloat(lastYIndex + 1) * 6.2) + (6.2 * CGFloat(i)), y: rect.maxY))
            context.strokePath()
         }
      } else if rect.size.height > rect.size.width {
         let emptySpaceHeightLength: CGFloat = rect.size.height - (CGFloat(Int((rect.size.height - 1.6) / 6.2)) * 6.2 + 1.6)
         let emptySpaceWidthLength: CGFloat = rect.size.width - (CGFloat(Int((rect.size.width - 1.6) / 6.2)) * 6.2 + 1.6)
         
         var lastXIndex: Int = 0
         var lastYIndex: Int = 0
         for i in 0...Int((rect.size.height - 1.6) / 6.2) {
            if i <= Int((rect.size.width - 1.6) / 6.2) {
               context.move(to: CGPoint(x: 1.6 + (6.2 * CGFloat(i)), y: 0.0))
               context.addLine(to: CGPoint(x: 0.0, y: 1.6 + (6.2 * CGFloat(i))))
               context.strokePath()
               lastYIndex = i
            } else {
               context.move(to: CGPoint(x: rect.maxX, y: (6.2 - emptySpaceWidthLength) + (6.2 * CGFloat(i - (lastYIndex + 1)))))
               context.addLine(to: CGPoint(x: 0.0, y: 1.6 + (6.2 * CGFloat(i))))
               context.strokePath()
               lastXIndex = i - (lastYIndex + 1)
            }
         }
         for i in 0...Int(rect.size.width / 6.2) {
            context.move(to: CGPoint(x: rect.maxX, y: (6.2 - emptySpaceWidthLength) + (CGFloat(lastXIndex + 1) * 6.2) + (6.2 * CGFloat(i))))
            context.addLine(to: CGPoint(x: (6.2 - emptySpaceHeightLength) + (6.2 * CGFloat(i)), y: rect.maxY))
            context.strokePath()
         }
      }
      context.restoreGState()
   }
}

extension UIStoryboard {

   class func onBoardingNVC() -> UINavigationController {
      let onBoardingNVC = UIStoryboard(name: "OnBoarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "onBoardingNVC") as! UINavigationController
      return onBoardingNVC
   }
   
   class func addServicesVC() -> AddServicesViewController {
      let addServicesVC = UIStoryboard(name: "OnBoarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "addServicesVC") as! AddServicesViewController
      return addServicesVC
   }
   
   class func newServiceVC() -> NewServiceViewController {
      let newServiceVC = UIStoryboard(name: "OnBoarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "newServiceVC") as! NewServiceViewController
      return newServiceVC
   }
   
   class func addEmployeesVC() -> AddEmployeesViewController {
      let addEmployeesVC = UIStoryboard(name: "OnBoarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "addEmployeesVC") as! AddEmployeesViewController
      return addEmployeesVC
   }
   
   class func agendaVC() -> AgendaViewController {
      let agendaVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "agendaVC") as! AgendaViewController
      return agendaVC
   }
   
   class func dipendentiVC() -> DipendentiViewController {
      let dipendentiVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dipendentiVC") as! DipendentiViewController
      return dipendentiVC
   }
   
   class func clientiVC() -> ClientiViewController {
      let clientiVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "clientiVC") as! ClientiViewController
      return clientiVC
   }
   
   class func prodottiVC() -> ProdottiViewController {
      let prodottiVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "prodottiVC") as! ProdottiViewController
      return prodottiVC
   }
   
   class func statisticheVC() -> StatisticheViewController {
      let statisticheVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "statisticheVC") as! StatisticheViewController
      return statisticheVC
   }
   
   class func bilancioVC() -> BilancioViewController {
      let bilancioVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bilancioVC") as! BilancioViewController
      return bilancioVC
   }
   
   class func impostazioniVC() -> ImpostazioniViewController {
      let impostazioniVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "impostazioniVC") as! ImpostazioniViewController
      return impostazioniVC
   }
   
   class func filterVC() -> FilterViewController {
      let filterVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "filterVC") as! FilterViewController
      return filterVC
   }
   
   class func addAppointmentVC() -> AddAppointmentViewController {
      let addAppointmentVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "addAppointmentVC") as! AddAppointmentViewController
      return addAppointmentVC
   }
   
   class func dragAndDropVC() -> DragAndDropViewController {
      let dragAndDropVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dragAndDropVC") as! DragAndDropViewController
      return dragAndDropVC
   }
   
}

extension Date {
   
   // to get ["Lun", "Mar", "Mer", "Gio", "Ven", "Sab", "Dom"]
   static func weekDays(withShortFormat: Bool = false) -> [String] {
      var days = withShortFormat ? DateFormatter().shortWeekdaySymbols! : DateFormatter().weekdaySymbols!
      days.append(days.remove(at: 0))
      return days
   }
   
   func getNumberOfDaysInMonth() -> Int {
      let calendar = Calendar.current
      let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
      let date = calendar.date(from: dateComponents)!
      let range = calendar.range(of: .day, in: .month, for: date)!
      let numDays = range.count
      return numDays
   }
   
   func startOfMonth() -> Date {
      return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
   }
   
   func endOfMonth() -> Date {
      return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
   }
   
   // Sunday is 1, then all the way up to 7
   func dayOfWeek() -> Int? {
      return Calendar.current.dateComponents([.weekday], from: self).weekday
   }
   
   func increaseMonth(by: Int) -> Date {
      return Calendar.current.date(byAdding: .month, value: by, to: self)!
   }
   
   func getMonthAndYearText() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMMM yyyy"
      formatter.locale = Locale(identifier: "it_IT")
      return formatter.string(from: self)
   }
   
   func getDay() -> Int {
      return Calendar.current.dateComponents([.day], from: self).day!
   }
   
   func getMonth() -> Int {
      return Calendar.current.dateComponents([.month], from: self).month!
   }
   
   func getYear() -> Int {
      return Calendar.current.dateComponents([.year], from: self).year!
   }
   
   func getFullDayDescription() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEEE d MMMM"
      formatter.locale = Locale(identifier: "it_IT")
      return formatter.string(from: self)
   }
   
   func convert(toDay day: Int) -> Date {
      var dateComponents = DateComponents()
      dateComponents.year = self.getYear()
      dateComponents.month = self.getMonth()
      dateComponents.day = day
      return Calendar.current.date(from: dateComponents)!
   }
   
}

extension UIView {
   static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void, group: DispatchGroup, completion: ((Bool) -> Void)?) {
      // DONE: Fill in this implementation
      group.enter()
      animate(withDuration: duration, animations: animations) { (success) in
         completion?(success)
         group.leave()
      }
   }
   
   func addLeftBar(withColor color: UIColor) {
      let barLayer = CAShapeLayer()
      let barPath = UIBezierPath()
      barPath.move(to: CGPoint(x: 0.0, y: 0.0))
      barPath.addLine(to: CGPoint(x: 3.0, y: 0.0))
      barPath.addLine(to: CGPoint(x: 3.0, y: self.bounds.size.height))
      barPath.addLine(to: CGPoint(x: 0.0, y: self.bounds.size.height))
      barLayer.path = barPath.cgPath
      barLayer.fillColor = color.cgColor
      self.layer.addSublayer(barLayer)
   }
   
   func topBubblePath() -> UIBezierPath {
      
      let radius : CGFloat = 3.0
      let triangleHeight : CGFloat = 5.0
      let path = UIBezierPath()
      path.move(to: CGPoint(x: radius, y: 0.0))
      path.addLine(to: CGPoint(x: self.bounds.size.width - radius, y: 0.0))
      path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: radius), radius: 3.0, startAngle: CGFloat(Double.pi * 3.0 / 2.0), endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
      path.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - (radius + triangleHeight)))
      path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: self.bounds.size.height - (radius + triangleHeight)), radius: 3.0, startAngle: 0.0, endAngle: CGFloat(Double.pi / 2.0), clockwise: true)
      path.addLine(to: CGPoint(x: self.bounds.size.width / 2.0 + 5.0, y: self.bounds.size.height - triangleHeight))
      
      path.addLine(to: CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height))
      path.addLine(to: CGPoint(x: self.bounds.size.width / 2.0 - 5.0, y: self.bounds.size.height - triangleHeight))
      
      path.addLine(to: CGPoint(x: radius, y: self.bounds.size.height - triangleHeight))
      path.addArc(withCenter: CGPoint(x: radius, y: self.bounds.size.height - (radius + triangleHeight)), radius: 3.0, startAngle: CGFloat(Double.pi / 2.0), endAngle: CGFloat(Double.pi), clockwise: true)
      path.addLine(to: CGPoint(x: 0.0, y: radius))
      path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: 3.0, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 3.0 / 2.0), clockwise: true)
      path.close()
      return path
   }
}

extension CALayer {
   
   func roundCorners(corners: UIRectCorner, radius: CGFloat, viewBounds: CGRect) {
      let maskPath = UIBezierPath(roundedRect: viewBounds,
                                  byRoundingCorners: corners,
                                  cornerRadii: CGSize(width: radius, height: radius))
      // FIX ME: shadow needs refactoring
      let shape = CAShapeLayer()
      shape.path = maskPath.cgPath
      shape.fillColor = UIColor.amDarkBlue.cgColor
      shape.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
      shape.shadowOpacity = 1.0
      shape.shadowOffset = CGSize(width: 0.0, height: 2.0)
      shape.shadowRadius = 4.0
      self.masksToBounds = false
      self.insertSublayer(shape, at: 0)
   }
   
}

extension UIImage {
   
   func scale(toSize newSize:CGSize) -> UIImage{
      UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
      self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
      let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      return newImage
   }
   
   func alpha(_ value:CGFloat)->UIImage
   {
      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage!
   }
   
   func takeSnapshotOfView(sourceView view: UIView) -> UIImage {
      UIGraphicsBeginImageContext(view.frame.size)
      view.drawHierarchy(in: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height), afterScreenUpdates: true)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image!
   }
}

extension UIColor {
   
   class func grayWith(value: CGFloat) -> UIColor {
      return UIColor(red: value/255.0, green: value/255.0, blue: value/255.0, alpha: 1.0)
   }
   
   class func getMiddleColor(fromColor startColor: UIColor, toColor endColor: UIColor, withPercentage percentage: CGFloat) -> UIColor {
      guard percentage != 0.0 else {
         return startColor
      }
      guard percentage != 1.0 else {
         return endColor
      }
      
      var r1: CGFloat = 0.0, g1: CGFloat = 0.0, b1: CGFloat = 0.0, a1: CGFloat = 0.0
      var r2: CGFloat = 0.0, g2: CGFloat = 0.0, b2: CGFloat = 0.0, a2: CGFloat = 0.0
      startColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
      endColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
      
      return UIColor(red: r1 + abs(r2-r1) * percentage, green: g1 + abs(g2-g1) * percentage, blue: b1 + abs(b2-b1) * percentage, alpha: 1.0)
   }
}

extension UILabel {
   
   class func attributedString(withText text: String, andTextColor textColor: UIColor, andFont font: UIFont, andCharacterSpacing characterSpacing: CGFloat?, isCentered: Bool = false) -> NSAttributedString {
      
      let attrString = NSMutableAttributedString(string: text)
      let style = NSMutableParagraphStyle()
      style.alignment = isCentered ? .center : .natural
      attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: text.characters.count))
      if let characterSpacing = characterSpacing {
         attrString.addAttribute(NSAttributedStringKey.kern, value: characterSpacing, range: NSRange(location: 0, length: text.characters.count))
      }
      attrString.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location: 0, length: text.characters.count))
      attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: NSRange(location: 0, length: text.characters.count))
      return attrString
   }
   
   class func attributes(forTextColor textColor: UIColor, andFont font: UIFont, andCharacterSpacing characterSpacing: CGFloat?, isCentered: Bool = false) -> [String: Any] {
      
      let style = NSMutableParagraphStyle()
      style.alignment = isCentered ? .center : .natural
      
      var attributes: [String: Any] = [
         NSAttributedStringKey.font.rawValue : font,
         NSAttributedStringKey.foregroundColor.rawValue : textColor,
         NSAttributedStringKey.paragraphStyle.rawValue: style
      ]
      if let characterSpacing = characterSpacing {
         attributes[NSAttributedStringKey.kern.rawValue] = characterSpacing
      }
      
      return attributes
   }
   
   class func onBoardingTitleView(withText text: String) -> UILabel {
      let onBoardingTitleLabel = UILabel()
      onBoardingTitleLabel.attributedText = UILabel.attributedString(withText: text, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
      onBoardingTitleLabel.heightAnchor.constraint(equalToConstant: 19.0).isActive = true
      return onBoardingTitleLabel
   }
}

extension UIButton {
   
   func setBackgroundColor(color: UIColor, forState: UIControlState) {
      
      UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
      
      guard let currentContext = UIGraphicsGetCurrentContext() else {
         return
      }
      
      currentContext.setFillColor(color.cgColor)
      currentContext.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
      let colorImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      self.setBackgroundImage(colorImage, for: forState)
   }
}

extension NSLayoutConstraint {
   
   func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
      NSLayoutConstraint.deactivate([self])
      let newConstraint = NSLayoutConstraint(
         item: firstItem as Any,
         attribute: firstAttribute,
         relatedBy: relation,
         toItem: secondItem,
         attribute: secondAttribute,
         multiplier: multiplier,
         constant: constant)
      newConstraint.priority = priority
      newConstraint.shouldBeArchived = self.shouldBeArchived
      newConstraint.identifier = self.identifier
      NSLayoutConstraint.activate([newConstraint])
      return newConstraint
   }
}

public extension CGPoint {
   static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
      return CGPoint(x: lhs.x+rhs.x, y: lhs.y+rhs.y)
   }
   
   static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
      return CGPoint(x: lhs.x*rhs, y: lhs.y*rhs)
   }
   
   static func *(lhs: CGFloat, rhs: CGPoint) -> CGPoint {
      return rhs*lhs
   }
   
   static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
      return lhs * (1/rhs)
   }
   
   static prefix func -(input: CGPoint) -> CGPoint {
      return CGPoint(x: -input.x, y: -input.y)
   }
   
   static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
      return lhs+(-rhs)
   }
   
   static func +=(lhs: inout CGPoint, rhs: CGPoint) {
      lhs = lhs + rhs
   }
   
   static func -=(lhs: inout CGPoint, rhs: CGPoint) {
      lhs = lhs - rhs
   }
   
   static func *=(lhs: inout CGPoint, rhs: CGFloat) {
      lhs = lhs * rhs
   }
   
   static func /=(lhs: inout CGPoint, rhs: CGFloat) {
      lhs = lhs / rhs
   }
   
   var lengthSquared: CGFloat {
      return dot(self)
   }
   
   var length: CGFloat {
      return lengthSquared.squareRoot()
   }
   
   static func *(lhs: CGPoint, rhs: CGAffineTransform) -> CGPoint {
      return lhs.applying(rhs)
   }
   
   func dot(_ other: CGPoint) -> CGFloat {
      return x*other.x + y*other.y
   }
}
