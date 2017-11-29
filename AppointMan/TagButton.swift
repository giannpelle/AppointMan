//
//  TagButton.swift
//  TagTextField
//
//  Created by Gianluigi Pelle on 6/15/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

enum TagButtonStyle {
   case plain, bordered
}

protocol TagButtonDataSource {
   func tagStyle() -> TagButtonStyle
   func tagDefaultBackgroundColor() -> UIColor
   func tagSelectedBackgroundColor() -> UIColor
   func tagSelectedBorderColor() -> UIColor
   func tagSelectedBorderWidth() -> CGFloat
   func tagCornerRadius() -> CGFloat
   func tagContentEdgeInsets() -> UIEdgeInsets
}

class TagButton: UIButton {
   
   // To manage the appearance of the button whether it is selected or not
   override var isSelected: Bool {
      didSet {
         switch self.dataSource?.tagStyle() ?? .plain {
         case .plain:
            self.backgroundColor = self.isSelected ? self.dataSource?.tagSelectedBackgroundColor() ?? UIColor.black : self.dataSource?.tagDefaultBackgroundColor() ?? UIColor.blue
         case .bordered:
            self.backgroundColor = self.dataSource?.tagDefaultBackgroundColor() ?? UIColor.blue
            self.layer.borderColor = self.isSelected ? self.dataSource?.tagSelectedBorderColor().cgColor : nil
            self.layer.borderWidth = self.isSelected ? self.dataSource?.tagSelectedBorderWidth() ?? 2.0 : 0.0
         }
      }
   }
   
   var dataSource: TagButtonDataSource? {
      didSet {
         if let dataSource = self.dataSource {
            self.isSelected = false
            self.backgroundColor = dataSource.tagDefaultBackgroundColor()
            self.layer.cornerRadius = dataSource.tagCornerRadius()
            self.contentEdgeInsets = dataSource.tagContentEdgeInsets()
         }
      }
   }
   
   init() {
      super.init(frame: CGRect.zero)
      
      self.setup()
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
      self.isHidden = true
      self.clipsToBounds = true
      self.setContentCompressionResistancePriority(1000, for: .horizontal)
   }   
   
}
