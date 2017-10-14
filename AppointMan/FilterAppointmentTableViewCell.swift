//
//  FilterAppointmentTableViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/25/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class FilterAppointmentTableViewCell: UITableViewCell {
   
   @IBOutlet weak var appointmentCardView: UIView!
   @IBOutlet weak var timeLabel: UILabel!
   @IBOutlet weak var serviceLabel: UILabel!
   @IBOutlet weak var customerLabel: UILabel!
   @IBOutlet weak var employeeImageView: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      let accessoryLayer = CAShapeLayer()
      let path = UIBezierPath()
      path.move(to: CGPoint(x: 24.0, y: 0.0))
      path.addLine(to: CGPoint(x: 26.0, y: 0.0))
      path.addLine(to: CGPoint(x: 26.0, y: self.bounds.size.height))
      path.addLine(to: CGPoint(x: 24.0, y: self.bounds.size.height))
      path.close()
      accessoryLayer.path = path.cgPath
      accessoryLayer.fillColor = UIColor.amBlue.cgColor
      self.layer.addSublayer(accessoryLayer)
      
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
   }
   
   func setup(withService service: (serviceName: String, serviceTime: String, serviceColor: UIColor, customer: String, employeeImage: UIImage)) {
      let dotLayer = CAShapeLayer()
      let dotPath = UIBezierPath(ovalIn: CGRect(x: 20.0, y: self.bounds.midY - 5.0, width: 10.0, height: 10.0))
      dotLayer.path = dotPath.cgPath
      dotLayer.fillColor = service.serviceColor.cgColor
      self.layer.addSublayer(dotLayer)
      self.appointmentCardView.addLeftBar(withColor: service.serviceColor)
      
      self.timeLabel.attributedText = UILabel.attributedString(withText: service.serviceTime, andTextColor: service.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: nil)
      self.timeLabel.setLineHeightInset(2.0)
      self.serviceLabel.attributedText = UILabel.attributedString(withText: service.serviceName, andTextColor: service.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil)
      self.serviceLabel.setLineHeightInset(2.0)
      self.customerLabel.attributedText = UILabel.attributedString(withText: service.customer, andTextColor: service.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: nil)
      self.customerLabel.setLineHeightInset(2.0)
      self.employeeImageView.clipsToBounds = true
      self.employeeImageView.layer.cornerRadius = self.employeeImageView.bounds.size.width / 2.0
      self.employeeImageView.image = service.employeeImage
   }
   
}
