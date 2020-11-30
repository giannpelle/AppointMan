//
//  ClosingCalendarCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/12/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ClosingCalendarCollectionViewCell: UICollectionViewCell, Overlayable {
   
   @IBOutlet weak var dayLabel: UILabel!
   @IBOutlet weak var dayAccessoryLabel: UILabel!
   
   lazy var overlayLayer: CALayer? = {
      return self.makeOverlay(for: self.bounds)
   }()
   
   var isClosed: Bool = false {
      didSet {
         if let sublayers = self.layer.sublayers {
            for layer in sublayers {
               if layer == self.overlayLayer {
                  layer.removeFromSuperlayer()
               }
            }
         }
         
         if self.isClosed {
            if let overlayLayer = self.overlayLayer {
               self.layer.addSublayer(overlayLayer)
            }
         }
      }
   }
   
   var day: (day: Int, dayColor: UIColor)? {
      didSet {
         if let day = day {
            self.dayLabel.isHidden = false
            self.dayLabel.attributedText = UILabel.attributedString(withText: "\(day.day)", andTextColor: day.dayColor, andFont: UIFont.init(name: "SFUIText-Bold", size: 16.0)!, andCharacterSpacing: -0.89)
         } else {
            self.dayLabel.isHidden = true
         }
      }
   }
   
   var dayAccessoryText: String? {
      didSet {
         if let dayAccessoryText = self.dayAccessoryText, !dayAccessoryText.isEmpty {
            self.dayAccessoryLabel.isHidden = false
            self.dayAccessoryLabel.attributedText = UILabel.attributedString(withText: dayAccessoryText, andTextColor: UIColor.white.withAlphaComponent(0.6), andFont: UIFont.init(name: "SFUIText-Bold", size: 10.0)!, andCharacterSpacing: 0.72)
         } else {
            self.dayAccessoryLabel.isHidden = true
         }
      }
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
   }
   
   
   
}
