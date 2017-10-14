//
//  OnBoardingNavigationBar.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/14/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class OnBoardingNavigationBar: UINavigationBar {
   
   let navigationBarHeight: CGFloat = 60.0
   
   override func sizeThatFits(_ size: CGSize) -> CGSize {
      return CGSize(width: UIScreen.main.bounds.width, height: self.navigationBarHeight)
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
      self.barTintColor = UIColor.amBlue
      self.tintColor = UIColor.white
      self.isTranslucent = false
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      if let titleView = topItem?.titleView {
         titleView.center = CGPoint(x: (UIScreen.main.bounds.size.width / 2.0).rounded(), y: (self.navigationBarHeight / 2.0).rounded())
      }
      
      if let rightBarButtonItem = topItem?.rightBarButtonItem {
         if let customView = rightBarButtonItem.customView {
            customView.frame.origin.x = (UIScreen.main.bounds.size.width - (customView.intrinsicContentSize.width + 20.0)).rounded()
            customView.center.y = (self.navigationBarHeight / 2.0).rounded()
            customView.frame.size = customView.intrinsicContentSize
            
            // Could work on iOS 11 (as they moved to a constrained based layout)
            /*for constr in customView.constraints {
             if constr.firstAttribute == .trailing || constr.secondAttribute == .leading {
             //constr.constant = 0.0
             } else if constr.firstAttribute == .trailing || constr.secondAttribute == .trailing {
             //constr.constant = 0.0
             }
             }*/
         }
      }
      
      if let backBarButtonItem = topItem?.leftBarButtonItem {
         if let customView = backBarButtonItem.customView {
            customView.frame.origin.x = 20.0
            customView.center.y = (self.navigationBarHeight / 2.0).rounded()
            customView.frame.size = customView.intrinsicContentSize
         }
      }
   }
   
}

