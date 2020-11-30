//
//  NotificationDatePickerView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/19/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol NotificationDatePickerViewDelegate: class {
   func didDeleteNotification()
   func didUpdateNotification(with date: Date)
}

class NotificationDatePickerView: UIView {
   
   @IBOutlet weak var titleBackgroundView: UIView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var datePicker: UIDatePicker!
   @IBOutlet weak var deleteNotificationButton: UIButton!
   @IBOutlet weak var updateNotificationButton: UIButton!
   
   weak var delegate: NotificationDatePickerViewDelegate?
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.titleLabel.attributedText = UILabel.attributedString(withText: "IMPOSTA NOTIFICA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true)
      self.deleteNotificationButton.setAttributedTitle(UILabel.attributedString(withText: "ELIMINA NOTIFICA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0), for: .normal)
      self.updateNotificationButton.setAttributedTitle(UILabel.attributedString(withText: "CONFERMA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0), for: .normal)
   }
   
   func setupUI() {
      self.datePicker.setDate(Date(), animated: false)
      self.datePicker.minimumDate = Date()
      self.datePicker.minuteInterval = 5
      
      self.deleteNotificationButton.layer.cornerRadius = 5.0
      self.updateNotificationButton.layer.cornerRadius = 5.0
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      let maskPath = UIBezierPath(roundedRect: self.bounds,
                                  byRoundingCorners: [.allCorners],
                                  cornerRadii: CGSize(width: 5.0, height: 5.0))
      // FIX ME: shadow needs refactoring
      let shape = CAShapeLayer()
      shape.path = maskPath.cgPath
      shape.fillColor = UIColor.white.cgColor
      shape.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
      shape.shadowOpacity = 0.75
      shape.shadowOffset = CGSize(width: 0.0, height: 2.0)
      shape.shadowRadius = 8.0
      self.layer.masksToBounds = false
      self.layer.insertSublayer(shape, at: 0)
      
      self.titleBackgroundView.layer.roundCorners(corners: [.topLeft, .topRight], radius: 5.0, viewBounds: self.bounds)
   }
   
   @objc func deleteNotificationButtonPressed(sender: UIButton) {
      self.delegate?.didDeleteNotification()
      self.dismissView()
   }
   
   @objc func updateNotificationButtonPressed(sender: UIButton) {
      self.delegate?.didUpdateNotification(with: self.datePicker.date)
      self.dismissView()
   }
   
   @IBAction func closeButtonPressed(sender: UIButton) {
      self.dismissView()
   }
   
   func dismissView() {
      UIView.animate(withDuration: 0.4, animations: {
         self.alpha = 0.0
      }) { (success) in
         if success {
            self.removeFromSuperview()
         }
      }
   }
   
}
