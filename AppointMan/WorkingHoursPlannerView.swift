//
//  WorkingHoursPlannerView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/31/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class WorkingHoursPlannerView: UIView {
   
   let hourUnitHeight: CGFloat = 80.0
   let numberOfHours: CGFloat = 17.0
   
   var weekDayRects: [CGRect] = []
   var halfHourRects: [CGRect] = []
   var boxViews: [[BoxView]] = [[], [], [], [], [], [], []]
   var currentBoxView: BoxView?
   var topPlaceholderView: PlaceholderOverlayableView!
   var bottomPlaceholderView: PlaceholderOverlayableView!
   
   var currentColomnIndex: Int = 0
   var initialHalfHourViewIndex: Int = 0
   var isEditMode: Bool = false {
      didSet {
         for boxViews in self.boxViews {
            for boxView in boxViews {
               boxView.isEditMode = self.isEditMode
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
      
      for i in 1..<Int((self.numberOfHours * 2) - 1) {
         self.halfHourRects.append(CGRect(x: 0.0, y: CGFloat(i) * (self.hourUnitHeight / 2.0), width: (self.bounds.size.width / 7.0).rounded(.down), height: self.hourUnitHeight / 2.0))
      }
      for index in 0...6 {
         self.weekDayRects.append(CGRect(x: (self.bounds.size.width / 7.0) * CGFloat(index), y: 0.0, width: self.bounds.size.width / 7.0, height: self.bounds.size.height))
      }
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
      guard !self.topPlaceholderView.frame.contains(sender.location(in: self)) && !self.bottomPlaceholderView.frame.contains(sender.location(in: self)) else {
         return
      }
      guard !self.isEditMode else {
         return
      }
      
      switch sender.state {
      case .began:
         let fingerPosition = sender.location(in: self)
         for (index, weekDayRect) in self.weekDayRects.enumerated() {
            if weekDayRect.contains(fingerPosition) {
               for boxView in self.boxViews[index] {
                  if boxView.frame.contains(fingerPosition) {
                     self.isEditMode = true
                     return
                  }
               }
               
               self.currentColomnIndex = index
               for (i, halfHourRect) in self.halfHourRects.enumerated() {
                  if halfHourRect.contains(CGPoint(x: halfHourRect.midX, y: fingerPosition.y)) {
                     self.initialHalfHourViewIndex = i
                     let boxView = BoxView(frame: CGRect(x: (self.bounds.size.width / 7.0) * CGFloat(self.currentColomnIndex), y: self.halfHourRects[self.initialHalfHourViewIndex].origin.y, width: self.bounds.size.width / 7.0, height: self.hourUnitHeight / 2.0))
                     boxView.colomnIndex = self.currentColomnIndex
                     boxView.delegate = self
                     self.currentBoxView = boxView
                     self.currentBoxView?.setupAccessoryLabels(withTopString: self.getStartTime(fromIndex: self.initialHalfHourViewIndex), andBottomString: self.getEndTime(fromIndex: self.initialHalfHourViewIndex))
                     self.addSubview(self.currentBoxView!)
                     break
                  }
               }
               break
            }
         }
      case .changed:
         let indexes = self.getHalfHourViewIndexesToBeHighlighted(forCurrentLocation: sender.location(in: self))
         //print(sender.location(in: self))
         if let currentBoxView = self.currentBoxView {
            print(indexes)
            currentBoxView.frame = CGRect(x: (self.bounds.size.width / 7.0) * CGFloat(self.currentColomnIndex), y: self.halfHourRects[indexes.first!].origin.y, width: self.bounds.size.width / 7.0, height: CGFloat(indexes.count) * (self.hourUnitHeight / 2.0))
            currentBoxView.setupAccessoryLabels(withTopString: self.getStartTime(fromIndex: indexes.first!), andBottomString: self.getEndTime(fromIndex: indexes.last!))
         }
         break
      case .ended:
         if let currentBoxView = self.currentBoxView {
            self.boxViews[self.currentColomnIndex].append(currentBoxView)
         }
         self.initialHalfHourViewIndex = 0
         self.currentColomnIndex = 0
         self.currentBoxView = nil
         break
      default:
         break
      }
   }
   
   func getHalfHourViewIndexesToBeHighlighted(forCurrentLocation currentLocation: CGPoint) -> [Int] {
      
      guard let superview = self.superview else {
         return [self.initialHalfHourViewIndex]
      }
      let visibleRect = self.frame.intersection(superview.bounds)
      
      if currentLocation.y < (self.hourUnitHeight / 2.0) {
         return [Int](0...self.initialHalfHourViewIndex)
      } else if currentLocation.y > (self.bounds.size.height - (self.hourUnitHeight / 2.0)) {
         return [Int](self.initialHalfHourViewIndex...self.halfHourRects.count - 1)
      } else if currentLocation.y < visibleRect.minY {
         let topMostIndex = Int(visibleRect.minY / (self.hourUnitHeight / 2.0)) - 1
         return [Int](topMostIndex...self.initialHalfHourViewIndex)
      } else if currentLocation.y > visibleRect.maxY {
         let bottomMostIndex = Int(visibleRect.maxY / (self.hourUnitHeight / 2.0)) - 1
         return [Int](self.initialHalfHourViewIndex...bottomMostIndex)
      } else {
         for (index, halfHourRect) in self.halfHourRects.enumerated() {
            if halfHourRect.contains(CGPoint(x: halfHourRect.midX, y: currentLocation.y)) {
               if index > self.initialHalfHourViewIndex {
                  return [Int](self.initialHalfHourViewIndex...index)
               } else {
                  return [Int](index...self.initialHalfHourViewIndex)
               }
            }
         }
      }
      return []
   }
   
   func getStartTime(fromIndex index: Int) -> String {
      if index % 2 == 0 {
         return "\(Int(CGFloat(index) * 0.5 + 6.0)):00"
      } else {
         return "\(Int(CGFloat(index) * 0.5 + 6.0)):30"
      }
   }
   
   func getEndTime(fromIndex index: Int) -> String {
      if index % 2 == 0 {
         return "\(Int(CGFloat(index + 1) * 0.5 + 6.0)):30"
      } else {
         return "\(Int(CGFloat(index + 1) * 0.5 + 6.0)):00"
      }
   }
      
}

extension WorkingHoursPlannerView: BoxViewDelegate {
   
   func didRemove(view: BoxView, atColomnIndex colomnIndex: Int) {
      for (index, boxView) in self.boxViews[colomnIndex].enumerated() {
         if boxView == view {
            self.boxViews[colomnIndex].remove(at: index)
            for boxes in self.boxViews {
               if !boxes.isEmpty {
                  return
               }
            }
            self.isEditMode = false
            break
         }
      }
   }
}
