//
//  CalendarDayCollectionViewCell.swift
//  GPCalendar
//
//  Created by Gianluigi Pelle on 8/26/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class CalendarDayCollectionViewCell: UICollectionViewCell {
   
   var dayButton: CalendarDayButton!
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      self.backgroundColor = UIColor.clear
      self.dayButton = CalendarDayButton()
      self.dayButton.isUserInteractionEnabled = false
      self.contentView.addSubview(self.dayButton)
      self.dayButton.translatesAutoresizingMaskIntoConstraints = false
      self.dayButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
      self.dayButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
      self.dayButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
      self.dayButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func awakeFromNib() {
      fatalError("awakeFromNib() has not been implemented")
   }
   
   func setup(withDay day: String, andDayColor dayColor: UIColor) {
      self.dayButton.setAttributedTitle(UILabel.attributedString(withText: day, andTextColor: dayColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
      self.dayButton.setAttributedTitle(UILabel.attributedString(withText: day, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true), for: .selected)
      self.dayButton.titleLabel?.setLineHeightInset(2.0)
   }
}
