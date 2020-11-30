//
//  WorkingHoursPlannerView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/31/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class CardView: UIView {
   
   var topHourIndicatorLabel: UILabel!
   var bottomHourIndicatorLabel: UILabel!
   var binButton: UIButton!
   
   var isEditMode: Bool = false {
      didSet {
         self.binButton.isHidden = !self.isEditMode
      }
   }
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      self.clipsToBounds = true
      self.layer.cornerRadius = 3.0
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
      self.topHourIndicatorLabel = UILabel()
      self.topHourIndicatorLabel.attributedText = UILabel.attributedString(withText: "9:00", andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
      self.addSubview(self.topHourIndicatorLabel)
      self.topHourIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
      self.topHourIndicatorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
      self.topHourIndicatorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0).isActive = true
      
      self.bottomHourIndicatorLabel = UILabel()
      self.bottomHourIndicatorLabel.attributedText = UILabel.attributedString(withText: "9:30", andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
      self.addSubview(self.bottomHourIndicatorLabel)
      self.bottomHourIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
      self.bottomHourIndicatorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
      self.bottomHourIndicatorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0).isActive = true
      
      self.binButton = UIButton()
      self.binButton.setImage(#imageLiteral(resourceName: "icona_cestino"), for: .normal)
      self.binButton.isHidden = true
      self.addSubview(self.binButton)
      self.binButton.translatesAutoresizingMaskIntoConstraints = false
      self.binButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 11.0).isActive = true
      self.binButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
   }
   
}

class WorkingHoursPlannerView: UIView {
   
   let hourUnitHeight: CGFloat = 80.0
   let halfHourUnitHeight: CGFloat = 40.0
   let numberOfHours: CGFloat = 17.0
   var colomnWidth: CGFloat!
   
   var topPlaceholderView: PlaceholderOverlayableView!
   var bottomPlaceholderView: PlaceholderOverlayableView!
   var currentStartFrame: CGRect?
   var currentCardView: CardView?
   var currentCardViewColomn: Int?
   var borderLineWorkingHoursTimer: Timer?
   var isBorderLineWorkingHoursTimerRunning: Bool = false
   var borderLineWorkingHoursTimerDirection: Direction?
   var borderLineWorkingHoursTimerVelocity: Int?
   var borderLineWorkingHoursTimerLocationInView: CGPoint?
   
   var isLongPressOutOfBounds: Bool = false
   
   var workingHoursScrollView: UIScrollView? {
      return self.superview as? UIScrollView
   }
   
//   var isEditMode: Bool = false {
//      didSet {
//         for boxViews in self.boxViews {
//            for boxView in boxViews {
//               boxView.isEditMode = self.isEditMode
//            }
//         }
//      }
//   }
   
   override func draw(_ rect: CGRect) {
      
      //1
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context.saveGState()
      //2
      context.setStrokeColor(UIColor.amDarkBlue.withAlphaComponent(0.3).cgColor)
      context.setLineCap(.square)
      context.setLineWidth(2.0)
      
      // drawing vertical separator lines
      for index in 0...7 {
         if index == 0 {
            context.move(to: CGPoint(x: 1.0, y: 0.0))
            context.addLine(to: CGPoint(x: 1.0, y: self.bounds.maxY))
            context.strokePath()
            continue
         }
         if index == 7 {
            context.move(to: CGPoint(x: self.bounds.maxX - 1, y: 0.0))
            context.addLine(to: CGPoint(x: self.bounds.maxX - 1, y: self.bounds.maxY))
            context.strokePath()
            continue
         }
         
         let originX = self.bounds.size.width * (CGFloat(index) / 7.0)
         context.move(to: CGPoint(x: originX, y: 0.0))
         context.addLine(to: CGPoint(x: originX, y: self.bounds.maxY))
         context.strokePath()
      }
      
      // drawing hours separator lines
      for index in 1..<Int(self.numberOfHours * 2) {
         if index % 2 == 0 { continue }
         
         let originY = self.bounds.size.height * (CGFloat(index) / (self.numberOfHours * 2.0))
         context.move(to: CGPoint(x: 0.0, y: originY))
         context.addLine(to: CGPoint(x: self.bounds.maxX, y: originY))
         context.strokePath()
      }
      
      // drawing half hours separator lines
      context.setLineDash(phase: 0, lengths: [3, 6])
      for index in 1..<Int(self.numberOfHours) {
         let originY = self.bounds.size.height * (CGFloat(index) / self.numberOfHours)
         context.move(to: CGPoint(x: 0.0, y: originY))
         context.addLine(to: CGPoint(x: self.bounds.maxX, y: originY))
         context.strokePath()
      }
      
      //3
      context.restoreGState()
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.setupGrid()
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      self.colomnWidth = self.bounds.size.width / 7.0
   }
   
   func setupGrid() {
      let longPressGest = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized(sender:)))
      longPressGest.minimumPressDuration = 0.7
      self.addGestureRecognizer(longPressGest)
      
      self.topPlaceholderView = PlaceholderOverlayableView()
      self.topPlaceholderView.backgroundColor = UIColor.clear
      self.addSubview(self.topPlaceholderView)
      self.topPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
      self.topPlaceholderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      self.topPlaceholderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      self.topPlaceholderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      self.topPlaceholderView.heightAnchor.constraint(equalToConstant: self.hourUnitHeight / 2.0).isActive = true
      self.bottomPlaceholderView = PlaceholderOverlayableView()
      self.bottomPlaceholderView.backgroundColor = UIColor.clear
      self.addSubview(self.bottomPlaceholderView)
      self.bottomPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
      self.bottomPlaceholderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
      self.bottomPlaceholderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      self.bottomPlaceholderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      self.bottomPlaceholderView.heightAnchor.constraint(equalToConstant: self.hourUnitHeight / 2.0).isActive = true
   }
   
   @objc func longPressGestureRecognized(sender: UILongPressGestureRecognizer) {
      let locationInView = sender.location(in: self)
      print(locationInView)
      
      switch sender.state {
      case .began:
         guard locationInView.y > self.halfHourUnitHeight && locationInView.y < self.bounds.size.height - self.halfHourUnitHeight else {
            self.isLongPressOutOfBounds = true
            return
         }
         
         if self.halfHourViewAlreadyExist(atPoint: locationInView) {
            
         } else {
            let cardView = CardView(frame: self.getHalfHourFrame(from: locationInView))
            cardView.backgroundColor = UIColor.white
            cardView.topHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getStartTime(forIndex: self.getRowIndex(forLocation: locationInView)), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
            cardView.bottomHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getEndTime(forIndex: self.getRowIndex(forLocation: locationInView)), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
            self.addSubview(cardView)
            self.currentStartFrame = self.getHalfHourFrame(from: locationInView)
            self.currentCardView = cardView
            self.currentCardViewColomn = Int(locationInView.x / self.colomnWidth)
         }
         
      case .changed:
         guard !self.isLongPressOutOfBounds else { return }
         
         if let currentCardView = self.currentCardView, let colomn = self.currentCardViewColomn {
            let endFrame = self.getHalfHourFrame(from: locationInView, forColomn: colomn)
            
            if let workingHoursScrollView = self.workingHoursScrollView {
               let locationInWorkingHoursScrollView = locationInView - workingHoursScrollView.contentOffset
               if locationInWorkingHoursScrollView.y < 0 || locationInWorkingHoursScrollView.x < 0 {
                  //self.outOfBoundsReset()
               } else if locationInWorkingHoursScrollView.y < self.hourUnitHeight {
                  let total = self.hourUnitHeight
                  let part = total - locationInWorkingHoursScrollView.y
                  let speed = part / total
                  let speedRate = Int(speed * 10.0)
                  self.startBorderLineWorkingHoursTimer(going: .up, with: speedRate, from: locationInView)
               } else if locationInWorkingHoursScrollView.y > workingHoursScrollView.bounds.size.height - self.hourUnitHeight {
                  let total = self.hourUnitHeight
                  let part = total - (workingHoursScrollView.bounds.size.height - locationInWorkingHoursScrollView.y)
                  let speed = part / total
                  let speedRate = Int(speed * 10.0)
                  self.startBorderLineWorkingHoursTimer(going: .down, with: speedRate, from: locationInView)
               } else {
                  self.stopBorderLineWorkingHoursTimer()
               }
               
               if let startFrame = self.currentStartFrame {
                  currentCardView.frame = startFrame.union(endFrame)
                  if endFrame.origin.y > startFrame.origin.y {
                     currentCardView.topHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getStartTime(forIndex: self.getRowIndex(forLocation: CGPoint(x: startFrame.midX, y: startFrame.midY))), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
                     currentCardView.bottomHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getEndTime(forIndex: self.getRowIndex(forLocation: CGPoint(x: endFrame.midX, y: endFrame.midY))), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
                  } else {
                     currentCardView.topHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getStartTime(forIndex: self.getRowIndex(forLocation: CGPoint(x: endFrame.midX, y: endFrame.midY)) ), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
                     currentCardView.bottomHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getEndTime(forIndex: self.getRowIndex(forLocation: CGPoint(x: startFrame.midX, y: startFrame.midY))), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
                  }
               }
            }
         }
         
         break
      case .ended:
         guard !self.isLongPressOutOfBounds else {
            self.isLongPressOutOfBounds = false
            return
         }
         
         self.currentCardView = nil
         self.currentCardViewColomn = nil
         self.currentStartFrame = nil
         
         break
      default:
         break
      }
      
//      guard !self.topPlaceholderView.frame.contains(sender.location(in: self)) && !self.bottomPlaceholderView.frame.contains(sender.location(in: self)) else {
//         return
//      }
//      guard !self.isEditMode else {
//         return
//      }
//
//      switch sender.state {
//      case .began:
//         let fingerPosition = sender.location(in: self)
//         for (index, weekDayRect) in self.weekDayRects.enumerated() {
//            if weekDayRect.contains(fingerPosition) {
//               for boxView in self.boxViews[index] {
//                  if boxView.frame.contains(fingerPosition) {
//                     self.isEditMode = true
//                     return
//                  }
//               }
//
//               self.currentColomnIndex = index
//               for (i, halfHourRect) in self.halfHourRects.enumerated() {
//                  if halfHourRect.contains(CGPoint(x: halfHourRect.midX, y: fingerPosition.y)) {
//                     self.initialHalfHourViewIndex = i
//                     let boxView = BoxView(frame: CGRect(x: (self.bounds.size.width / 7.0) * CGFloat(self.currentColomnIndex), y: self.halfHourRects[self.initialHalfHourViewIndex].origin.y, width: self.bounds.size.width / 7.0, height: self.hourUnitHeight / 2.0))
//                     boxView.colomnIndex = self.currentColomnIndex
//                     boxView.delegate = self
//                     self.currentBoxView = boxView
//                     self.currentBoxView?.setupAccessoryLabels(withTopString: self.getStartTime(fromIndex: self.initialHalfHourViewIndex), andBottomString: self.getEndTime(fromIndex: self.initialHalfHourViewIndex))
//                     self.addSubview(self.currentBoxView!)
//                     break
//                  }
//               }
//               break
//            }
//         }
//      case .changed:
//         let indexes = self.getHalfHourViewIndexesToBeHighlighted(forCurrentLocation: sender.location(in: self))
//         //print(sender.location(in: self))
//         if let currentBoxView = self.currentBoxView {
//            print(indexes)
//            currentBoxView.frame = CGRect(x: (self.bounds.size.width / 7.0) * CGFloat(self.currentColomnIndex), y: self.halfHourRects[indexes.first!].origin.y, width: self.bounds.size.width / 7.0, height: CGFloat(indexes.count) * (self.hourUnitHeight / 2.0))
//            currentBoxView.setupAccessoryLabels(withTopString: self.getStartTime(fromIndex: indexes.first!), andBottomString: self.getEndTime(fromIndex: indexes.last!))
//         }
//         break
//      case .ended:
//         if let currentBoxView = self.currentBoxView {
//            self.boxViews[self.currentColomnIndex].append(currentBoxView)
//         }
//         self.initialHalfHourViewIndex = 0
//         self.currentColomnIndex = 0
//         self.currentBoxView = nil
//         break
//      default:
//         break
//      }
   }
   
   func getHalfHourFrame(from currentLocation: CGPoint, forColomn colomn: Int? = nil) -> CGRect {
      guard currentLocation.y > self.halfHourUnitHeight else {
         if let colomn = colomn {
            return CGRect(x: self.colomnWidth * colomn, y: self.halfHourUnitHeight * 1, width: self.colomnWidth, height: self.halfHourUnitHeight)
         } else {
            let colomnIndex = Int(currentLocation.x / self.colomnWidth)
            return CGRect(x: self.colomnWidth * colomnIndex, y: self.halfHourUnitHeight * 1, width: self.colomnWidth, height: self.halfHourUnitHeight)
         }
      }
      
      guard currentLocation.y < self.bounds.size.height - self.halfHourUnitHeight else {
         if let colomn = colomn {
            return CGRect(x: self.colomnWidth * colomn, y: self.halfHourUnitHeight * ((self.numberOfHours - 1) * 2), width: self.colomnWidth, height: self.halfHourUnitHeight)
         } else {
            let colomnIndex = Int(currentLocation.x / self.colomnWidth)
            return CGRect(x: self.colomnWidth * colomnIndex, y: self.halfHourUnitHeight * ((self.numberOfHours - 1) * 2), width: self.colomnWidth, height: self.halfHourUnitHeight)
         }
      }
      
      if let colomn = colomn {
         let rowIndex = Int(currentLocation.y / self.halfHourUnitHeight)
         return CGRect(x: self.colomnWidth * colomn, y: self.halfHourUnitHeight * rowIndex, width: self.colomnWidth, height: self.halfHourUnitHeight)
      } else {
         let colomnIndex = Int(currentLocation.x / self.colomnWidth)
         let rowIndex = Int(currentLocation.y / self.halfHourUnitHeight)
         return CGRect(x: self.colomnWidth * colomnIndex, y: self.halfHourUnitHeight * rowIndex, width: self.colomnWidth, height: self.halfHourUnitHeight)
      }
   }
   
   func getRowIndex(forLocation location: CGPoint) -> Int {
      guard location.y > 0 else {
         return 0
      }
      guard location.y < self.bounds.size.height else {
         return Int((self.bounds.size.height - 4.0) / self.halfHourUnitHeight)
      }
      
      return Int(location.y / self.halfHourUnitHeight)
   }
   
   func halfHourViewAlreadyExist(atPoint point: CGPoint) -> Bool {
      for subview in self.subviews {
         if let cardView = subview as? CardView {
            if cardView.frame.contains(point) {
               return true
            }
         }
      }
      return false
   }
   
   func startBorderLineWorkingHoursTimer(going: Direction, with speedRate: Int, from locationInView: CGPoint) {
      self.isBorderLineWorkingHoursTimerRunning = true
      self.borderLineWorkingHoursTimerDirection = going
      self.borderLineWorkingHoursTimerVelocity = speedRate
      self.borderLineWorkingHoursTimerLocationInView = locationInView
      guard borderLineWorkingHoursTimer == nil else { return }
      
      self.borderLineWorkingHoursTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateScrollViewContentOffset), userInfo: nil, repeats: true)
   }
   
   func stopBorderLineWorkingHoursTimer() {
      self.isBorderLineWorkingHoursTimerRunning = false
      guard borderLineWorkingHoursTimer != nil else { return }
      
      self.borderLineWorkingHoursTimer?.invalidate()
      self.borderLineWorkingHoursTimer = nil
      self.borderLineWorkingHoursTimerLocationInView = nil
      self.borderLineWorkingHoursTimerVelocity = nil
      self.borderLineWorkingHoursTimerDirection = nil
      
   }
   
   @objc func updateScrollViewContentOffset(from locationInView: CGPoint) {
      if let going = self.borderLineWorkingHoursTimerDirection, let speedRate = self.borderLineWorkingHoursTimerVelocity, let locationInView = self.borderLineWorkingHoursTimerLocationInView {
         self.scrollWorkingHours(to: going, with: speedRate, from: locationInView)
      }
   }
   
   func scrollWorkingHours(to: Direction, with speedRate: Int, from locationInView: CGPoint) {
      let offsetToUpdate = 5.0 + speedRate * 3.0
      
      switch to {
      case .up:
         guard let workingHoursScrollView = self.workingHoursScrollView, workingHoursScrollView.contentOffset.y > offsetToUpdate else {
            let contentOffset = self.workingHoursScrollView?.contentOffset.y ?? 0.0
            UIView.animate(withDuration: 0.05, animations: {
               self.workingHoursScrollView?.contentOffset.y = 0.0
               //self.borderLineWorkingHoursTimerLocationInView.y -= contentOffset
               //self.currentCardView?.bounds.size.height += contentOffset
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            workingHoursScrollView.contentOffset.y -= offsetToUpdate
            self.borderLineWorkingHoursTimerLocationInView?.y -= offsetToUpdate
            //self.currentCardView?.bounds.size.height += offsetToUpdate
         })
      case .down:
         guard let workingHoursScrollView = self.workingHoursScrollView, workingHoursScrollView.contentOffset.y < workingHoursScrollView.contentSize.height - offsetToUpdate - workingHoursScrollView.bounds.size.height else {
            UIView.animate(withDuration: 0.05, animations: {
               if let workingHoursScrollView = self.workingHoursScrollView {
                  workingHoursScrollView.contentOffset.y = self.bounds.size.height - workingHoursScrollView.bounds.size.height
               }
            })
            return
         }
         UIView.animate(withDuration: 0.05, animations: {
            workingHoursScrollView.contentOffset.y += offsetToUpdate
            self.borderLineWorkingHoursTimerLocationInView?.y += offsetToUpdate
            //self.currentCardView?.bounds.size.height += offsetToUpdate
         })
      default:
         break
      }
      
      if let currentCardView = self.currentCardView, let colomn = self.currentCardViewColomn {
         let endFrame = self.getHalfHourFrame(from: locationInView, forColomn: colomn)
         
         if let startFrame = self.currentStartFrame {
            currentCardView.frame = startFrame.union(endFrame)
            if endFrame.origin.y > startFrame.origin.y {
               currentCardView.topHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getStartTime(forIndex: self.getRowIndex(forLocation: CGPoint(x: startFrame.midX, y: startFrame.midY))), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
               currentCardView.bottomHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getEndTime(forIndex: self.getRowIndex(forLocation: CGPoint(x: endFrame.midX, y: endFrame.midY))), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
            } else {
               currentCardView.topHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getStartTime(forIndex: self.getRowIndex(forLocation: CGPoint(x: endFrame.midX, y: endFrame.midY)) ), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
               currentCardView.bottomHourIndicatorLabel.attributedText = UILabel.attributedString(withText: self.getEndTime(forIndex: self.getRowIndex(forLocation: CGPoint(x: startFrame.midX, y: startFrame.midY))), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 10.0)!, andCharacterSpacing: 0.0)
            }
         }
      }
   }
   
   
   
//   func getHalfHourViewIndexesToBeHighlighted(forCurrentLocation currentLocation: CGPoint) -> [Int] {
//
//      guard let superview = self.superview else {
//         return [self.initialHalfHourViewIndex]
//      }
//      let visibleRect = self.frame.intersection(superview.bounds)
//
//      if currentLocation.y < (self.hourUnitHeight / 2.0) {
//         return [Int](0...self.initialHalfHourViewIndex)
//      } else if currentLocation.y > (self.bounds.size.height - (self.hourUnitHeight / 2.0)) {
//         return [Int](self.initialHalfHourViewIndex...self.halfHourRects.count - 1)
//      } else if currentLocation.y < visibleRect.minY {
//         let topMostIndex = Int(visibleRect.minY / (self.hourUnitHeight / 2.0)) - 1
//         return [Int](topMostIndex...self.initialHalfHourViewIndex)
//      } else if currentLocation.y > visibleRect.maxY {
//         let bottomMostIndex = Int(visibleRect.maxY / (self.hourUnitHeight / 2.0)) - 1
//         return [Int](self.initialHalfHourViewIndex...bottomMostIndex)
//      } else {
//         for (index, halfHourRect) in self.halfHourRects.enumerated() {
//            if halfHourRect.contains(CGPoint(x: halfHourRect.midX, y: currentLocation.y)) {
//               if index > self.initialHalfHourViewIndex {
//                  return [Int](self.initialHalfHourViewIndex...index)
//               } else {
//                  return [Int](index...self.initialHalfHourViewIndex)
//               }
//            }
//         }
//      }
//      return []
//   }
   
   func getStartTime(forIndex index: Int) -> String {
      if index % 2 == 0 {
         return "\(Int(CGFloat(index) * 0.5 + 5.5)):30"
      } else {
         return "\(Int(CGFloat(index) * 0.5 + 5.5)):00"
      }
   }
   
   func getEndTime(forIndex index: Int) -> String {
      if index % 2 == 0 {
         return "\(Int(CGFloat(index + 1) * 0.5 + 5.5)):00"
      } else {
         return "\(Int(CGFloat(index + 1) * 0.5 + 5.5)):30"
      }
   }
      
}

extension WorkingHoursPlannerView: BoxViewDelegate {
   
   func didRemove(view: BoxView, atColomnIndex colomnIndex: Int) {
//      for (index, boxView) in self.boxViews[colomnIndex].enumerated() {
//         if boxView == view {
//            self.boxViews[colomnIndex].remove(at: index)
//            for boxes in self.boxViews {
//               if !boxes.isEmpty {
//                  return
//               }
//            }
//            self.isEditMode = false
//            break
//         }
//      }
   }
}
