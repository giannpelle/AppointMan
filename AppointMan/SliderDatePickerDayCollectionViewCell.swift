//
//  SliderDatePickerDayCollectionViewCell.swift
//  GPSliderDatePicker
//
//  Created by Gianluigi Pelle on 8/29/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class SliderDatePickerDayCollectionViewCell: UICollectionViewCell {
   
   var dayLabel: UILabel!
   var dotLayer: CAShapeLayer!
   
   var isDaySelected: Bool = false {
      didSet {
         if self.isDaySelected {
            self.dayLabel.attributedText = UILabel.attributedString(withText: self.dayLabel.attributedText?.string ?? "", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 21.0) ?? UIFont.systemFont(ofSize: 21.0), andCharacterSpacing: nil, isCentered: true)
         } else {
            self.dayLabel.attributedText = UILabel.attributedString(withText: self.dayLabel.attributedText?.string ?? "", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0), andCharacterSpacing: nil, isCentered: true)
            self.dayLabel.setLineHeightInset(2.0)
         }
      }
   }
   var isToday: Bool = false {
      didSet {
         if self.isToday {
            self.dotLayer.isHidden = false
         } else {
            self.dotLayer.isHidden = true
         }
      }
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      self.backgroundColor = UIColor.clear
      self.dayLabel = UILabel()
      self.contentView.addSubview(self.dayLabel)
      self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
      self.dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      self.dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      self.dayLabel.lastBaselineAnchor.constraint(equalTo: self.bottomAnchor, constant: -18.0).isActive = true
      
      self.dotLayer = CAShapeLayer()
      let path = UIBezierPath(ovalIn: CGRect(x: self.bounds.size.width / 2.0 - (6.0 / 2.0), y: 38.0, width: 6.0, height: 6.0))
      dotLayer.path = path.cgPath
      dotLayer.fillColor = UIColor.amOpaqueBlue.cgColor
      self.layer.insertSublayer(dotLayer, at: 0)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func awakeFromNib() {
      fatalError("awakeFromNib() has not been implemented")
   }
   
   override func prepareForReuse() {
      super.prepareForReuse()
      
      self.isToday = false
   }
   
   func setup(withDay day: String) {
      self.dayLabel.attributedText = UILabel.attributedString(withText: day, andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0), andCharacterSpacing: nil, isCentered: true)
      self.dayLabel.setLineHeightInset(2.0)
   }
}

