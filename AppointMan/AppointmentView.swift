//
//  AppointmentView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/25/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

enum AppointmentDuration {
   case quarter, twenty, twentyFive, thirty, thirtyFive, fourty, fourtyFive, large(Int)
   
   init(withValue value: Int) {
      switch value {
      case 0...15:
         self = .quarter
      case 16...20:
         self = .twenty
      case 21...25:
         self = .twentyFive
      case 26...30:
         self = .thirty
      case 31...35:
         self = .thirtyFive
      case 36...40:
         self = .fourty
      case 41...45:
         self = .fourtyFive
      case 46...:
         self = .large(value)
      default:
         self = .quarter
      }
   }
   
   func getValue() -> Int {
      switch self {
      case .quarter:
         return 15
      case .twenty:
         return 20
      case .twentyFive:
         return 25
      case .thirty:
         return 30
      case .thirtyFive:
         return 35
      case .fourty:
         return 40
      case .fourtyFive:
         return 45
      case .large(let value):
         return value
      }
   }
}

class AppointmentView: UIView {
   
   weak var accessoryColorLayer: CALayer?
   weak var timeLabel: UILabel?
   weak var serviceLabel: UILabel?
   weak var customerLabel: UILabel?
   weak var appointmentDescriptionLabel: UILabel?
   
   var appointment: (time: String, service: String, duration: AppointmentDuration, serviceColor: UIColor, customer: String, description: String?) = (time: "10:30 - 11:30", service: "Tinta", duration: AppointmentDuration(withValue: 50), serviceColor: UIColor(red: 255/255.0, green: 135/255.0, blue: 47/255.0, alpha: 1.0), customer: "Marco Benedetto", description: "Il cliente di solito arriva 10 minuti prima")
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      let accessoryColorLayer = CALayer()
      accessoryColorLayer.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: rect.size.height)
      accessoryColorLayer.backgroundColor = self.appointment.serviceColor.cgColor
      self.layer.insertSublayer(accessoryColorLayer, at: 0)
      self.accessoryColorLayer = accessoryColorLayer
      
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      //self.configure(for: self.appointment)
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      
   }
   
   init(withAppointment appointment: (time: String, service: String, duration: AppointmentDuration, serviceColor: UIColor, customer: String, description: String?)) {
      super.init(frame: CGRect.zero)
      self.backgroundColor = UIColor.white
      
      switch appointment.duration {
      case .quarter:
         let timeLabel = UILabel()
         timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 8.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(timeLabel)
         timeLabel.translatesAutoresizingMaskIntoConstraints = false
         timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2.0).isActive = true
         timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let serviceLabel = UILabel()
         serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 13.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(serviceLabel)
         serviceLabel.translatesAutoresizingMaskIntoConstraints = false
         serviceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0.0).isActive = true
         serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         serviceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0).isActive = true
         
      case .twenty:
         let timeLabel = UILabel()
         timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(timeLabel)
         timeLabel.translatesAutoresizingMaskIntoConstraints = false
         timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
         timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let serviceLabel = UILabel()
         serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(serviceLabel)
         serviceLabel.translatesAutoresizingMaskIntoConstraints = false
         serviceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 2.0).isActive = true
         serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         serviceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
         
      case .twentyFive:
         let timeLabel = UILabel()
         timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(timeLabel)
         timeLabel.translatesAutoresizingMaskIntoConstraints = false
         timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
         timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let serviceLabel = UILabel()
         serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(serviceLabel)
         serviceLabel.translatesAutoresizingMaskIntoConstraints = false
         serviceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 2.0).isActive = true
         serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         serviceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15.0).isActive = true
         
      case .thirty:
         let timeLabel = UILabel()
         timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(timeLabel)
         timeLabel.translatesAutoresizingMaskIntoConstraints = false
         timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
         timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let serviceLabel = UILabel()
         serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(serviceLabel)
         serviceLabel.translatesAutoresizingMaskIntoConstraints = false
         serviceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 1.0).isActive = true
         serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let customerLabel = UILabel()
         customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(customerLabel)
         customerLabel.translatesAutoresizingMaskIntoConstraints = false
         customerLabel.topAnchor.constraint(equalTo: serviceLabel.bottomAnchor, constant: 7.5).isActive = true
         customerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         customerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
         
      case .thirtyFive:
         let timeLabel = UILabel()
         timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(timeLabel)
         timeLabel.translatesAutoresizingMaskIntoConstraints = false
         timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
         timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let serviceLabel = UILabel()
         serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(serviceLabel)
         serviceLabel.translatesAutoresizingMaskIntoConstraints = false
         serviceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 1.0).isActive = true
         serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let customerLabel = UILabel()
         customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(customerLabel)
         customerLabel.translatesAutoresizingMaskIntoConstraints = false
         customerLabel.topAnchor.constraint(equalTo: serviceLabel.bottomAnchor, constant: 7.5).isActive = true
         customerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         customerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15.0).isActive = true
         
      case .fourty:
         let timeLabel = UILabel()
         timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(timeLabel)
         timeLabel.translatesAutoresizingMaskIntoConstraints = false
         timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
         timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let serviceLabel = UILabel()
         serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(serviceLabel)
         serviceLabel.translatesAutoresizingMaskIntoConstraints = false
         serviceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 1.0).isActive = true
         serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let customerLabel = UILabel()
         customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(customerLabel)
         customerLabel.translatesAutoresizingMaskIntoConstraints = false
         customerLabel.topAnchor.constraint(equalTo: serviceLabel.bottomAnchor, constant: 7.5).isActive = true
         customerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         customerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25.0).isActive = true
         
      case .fourtyFive:
         let timeLabel = UILabel()
         timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(timeLabel)
         timeLabel.translatesAutoresizingMaskIntoConstraints = false
         timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
         timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let serviceLabel = UILabel()
         serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(serviceLabel)
         serviceLabel.translatesAutoresizingMaskIntoConstraints = false
         serviceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 1.0).isActive = true
         serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let customerLabel = UILabel()
         customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(customerLabel)
         customerLabel.translatesAutoresizingMaskIntoConstraints = false
         customerLabel.topAnchor.constraint(equalTo: serviceLabel.bottomAnchor, constant: 7.5).isActive = true
         customerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         if let description = appointment.description {
            let appointmentDescriptionLabel = UILabel()
            appointmentDescriptionLabel.attributedText = UILabel.attributedString(withText: description, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
            
            self.addSubview(appointmentDescriptionLabel)
            appointmentDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            appointmentDescriptionLabel.topAnchor.constraint(equalTo: customerLabel.bottomAnchor, constant: 13.0).isActive = true
            appointmentDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
            appointmentDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.5).isActive = true
         } else {
            customerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -35.0).isActive = true
         }
         
      case .large:
         let timeLabel = UILabel()
         timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(timeLabel)
         timeLabel.translatesAutoresizingMaskIntoConstraints = false
         timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
         timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let serviceLabel = UILabel()
         serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(serviceLabel)
         serviceLabel.translatesAutoresizingMaskIntoConstraints = false
         serviceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 1.0).isActive = true
         serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         let customerLabel = UILabel()
         customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         
         self.addSubview(customerLabel)
         customerLabel.translatesAutoresizingMaskIntoConstraints = false
         customerLabel.topAnchor.constraint(equalTo: serviceLabel.bottomAnchor, constant: 7.5).isActive = true
         customerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
         
         if let description = appointment.description {
            let appointmentDescriptionLabel = UILabel()
            appointmentDescriptionLabel.attributedText = UILabel.attributedString(withText: description, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
            
            self.addSubview(appointmentDescriptionLabel)
            appointmentDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            appointmentDescriptionLabel.topAnchor.constraint(equalTo: customerLabel.bottomAnchor, constant: 13.0).isActive = true
            appointmentDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13.0).isActive = true
            appointmentDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0).isActive = true
            
            customerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(appointment.duration.getValue() / 5.0 * 10.0 - 55.0)).isActive = true
         } else {
            customerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(appointment.duration.getValue() / 5.0 * 10.0 - 55.0)).isActive = true
         }
         
      }
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      self.widthAnchor.constraint(equalToConstant: Const.agendaEmployeeColomnWidth).isActive = true
   }
   
}
