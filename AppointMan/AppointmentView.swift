//
//  AppointmentView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/25/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

enum AppointmentDuration: Int {
   case quarter = 15, twenty = 20, twentyFive = 25, thirty = 30, thirtyFive = 35, fourty = 40, fourtyFive = 45, large = 50
   
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
         self = .large
      default:
         self = .quarter
      }
   }
   
   var isCustomerLabelHidden: Bool {
      switch self {
      case .quarter, .twenty, .twentyFive:
         return true
      default:
         return false
      }
   }
   
   var isAppointmentDescriptionHidden: Bool {
      switch self {
      case .fourtyFive, .large:
         return false
      default:
         return true
      }
   }
   
   func timeLabelTopValue() -> CGFloat {
      switch self {
      case .quarter:
         return 2.0
      default:
         return 5.0
      }
   }
   
   func serviceLabelTopValue() -> CGFloat {
      switch self {
      case .quarter:
         return 0.0
      case .twenty, .twentyFive:
         return 2.0
      default:
         return 1.0
      }
   }
   
   func customerLabelTopValue() -> CGFloat {
      switch self {
      case .quarter, .twenty, .twentyFive:
         return 0.0
      default:
         return 7.5
      }
   }
   
   func appointmentDescriptionLabelTopValue() -> CGFloat {
      switch self {
      case .fourtyFive, .large:
         return 13.0
      default:
         return 0.0
      }
   }
   
   func appointmentDescritionBottomValue() -> CGFloat {
      switch self {
      case .quarter:
         return 2.0
      case .twenty, .thirty:
         return 5.0
      case .twentyFive, .thirtyFive:
         return 15.0
      case .fourty:
         return 20.0
      case .fourtyFive:
         return 8.5
      default:
         return 10.0
      }
   }
   
}

class AppointmentView: UIView {
   
   @IBOutlet weak var timeLabelTopAnchor: NSLayoutConstraint!
   @IBOutlet weak var timeLabel: UILabel!
   @IBOutlet weak var serviceLabelTopAnchor: NSLayoutConstraint!
   @IBOutlet weak var serviceLabel: UILabel!
   @IBOutlet weak var customerLabelTopAnchor: NSLayoutConstraint!
   @IBOutlet weak var customerLabel: UILabel!
   @IBOutlet weak var appointmentDescriptionLabelTopAnchor: NSLayoutConstraint!
   @IBOutlet weak var appointmentDescriptionLabel: UILabel!
   @IBOutlet weak var appointmentDescriptionLabelBottomAnchor: NSLayoutConstraint!
   
   weak var accessoryColorLayer: CALayer?
   
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
      
      self.configure(for: self.appointment)
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      
   }
   
   func configure(for appointment: (time: String, service: String, duration: AppointmentDuration, serviceColor: UIColor, customer: String, description: String?)) {
      self.widthAnchor.constraint(equalToConstant: Const.agendaEmployeeColomnWidth).isActive = true
      
      switch appointment.duration {
      case .quarter:
         self.timeLabelTopAnchor.constant = 2.0
         self.timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 8.0)!, andCharacterSpacing: 0.0)
         self.serviceLabelTopAnchor.constant = 0.0
         self.serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 13.0)!, andCharacterSpacing: 0.0)
         self.customerLabelTopAnchor.constant = 0.0
         self.customerLabel.isHidden = true
         self.appointmentDescriptionLabelTopAnchor.constant = 0.0
         self.appointmentDescriptionLabel.isHidden = true
         self.appointmentDescriptionLabelBottomAnchor.constant = 2.0
      case .twenty:
         self.timeLabelTopAnchor.constant = 5.0
         self.timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         self.serviceLabelTopAnchor.constant = 2.0
         self.serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         self.customerLabelTopAnchor.constant = 0.0
         self.customerLabel.isHidden = true
         self.appointmentDescriptionLabelTopAnchor.constant = 0.0
         self.appointmentDescriptionLabel.isHidden = true
         self.appointmentDescriptionLabelBottomAnchor.constant = 5.0
      case .twentyFive:
         self.timeLabelTopAnchor.constant = 5.0
         self.timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         self.serviceLabelTopAnchor.constant = 2.0
         self.serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         self.customerLabelTopAnchor.constant = 0.0
         self.customerLabel.isHidden = true
         self.appointmentDescriptionLabelTopAnchor.constant = 0.0
         self.appointmentDescriptionLabel.isHidden = true
         self.appointmentDescriptionLabelBottomAnchor.constant = 15.0
      case .thirty:
         self.timeLabelTopAnchor.constant = 5.0
         self.timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         self.serviceLabelTopAnchor.constant = 1.0
         self.serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         self.customerLabelTopAnchor.constant = 7.5
         self.customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         self.customerLabel.isHidden = false
         self.appointmentDescriptionLabelTopAnchor.constant = 0.0
         self.appointmentDescriptionLabel.isHidden = true
         self.appointmentDescriptionLabelBottomAnchor.constant = 5.0
      case .thirtyFive:
         self.timeLabelTopAnchor.constant = 5.0
         self.timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         self.serviceLabelTopAnchor.constant = 1.0
         self.serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         self.customerLabelTopAnchor.constant = 7.5
         self.customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         self.customerLabel.isHidden = false
         self.appointmentDescriptionLabelTopAnchor.constant = 0.0
         self.appointmentDescriptionLabel.isHidden = true
         self.appointmentDescriptionLabelBottomAnchor.constant = 15.0
      case .fourty:
         self.timeLabelTopAnchor.constant = 5.0
         self.timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         self.serviceLabelTopAnchor.constant = 1.0
         self.serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         self.customerLabelTopAnchor.constant = 7.5
         self.customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         self.customerLabel.isHidden = false
         self.appointmentDescriptionLabelTopAnchor.constant = 0.0
         self.appointmentDescriptionLabel.isHidden = true
         self.appointmentDescriptionLabelBottomAnchor.constant = 20.0
      case .fourtyFive:
         self.timeLabelTopAnchor.constant = 5.0
         self.timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         self.serviceLabelTopAnchor.constant = 1.0
         self.serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         self.customerLabelTopAnchor.constant = 7.5
         self.customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         self.customerLabel.isHidden = false
         if let description = self.appointment.description {
            self.appointmentDescriptionLabelTopAnchor.constant = 13.0
            self.appointmentDescriptionLabel.attributedText = UILabel.attributedString(withText: description, andTextColor: UIColor.grayWith(value: 103.0), andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
            self.appointmentDescriptionLabel.isHidden = false
            self.appointmentDescriptionLabelBottomAnchor.constant = 8.5
         } else {
            self.appointmentDescriptionLabelTopAnchor.constant = 0.0
            self.appointmentDescriptionLabel.isHidden = true
            self.appointmentDescriptionLabelBottomAnchor.constant = self.appointment.duration.rawValue / 5.0 * 10.0 - 55.0
         }
      case .large:
         self.timeLabelTopAnchor.constant = 5.0
         self.timeLabel.attributedText = UILabel.attributedString(withText: appointment.time, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 9.0)!, andCharacterSpacing: 0.0)
         self.serviceLabelTopAnchor.constant = 1.0
         self.serviceLabel.attributedText = UILabel.attributedString(withText: appointment.service, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
         self.customerLabelTopAnchor.constant = 7.5
         self.customerLabel.attributedText = UILabel.attributedString(withText: appointment.customer, andTextColor: appointment.serviceColor, andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
         self.customerLabel.isHidden = false
         if let description = self.appointment.description {
            self.appointmentDescriptionLabelTopAnchor.constant = 13.0
            self.appointmentDescriptionLabel.attributedText = UILabel.attributedString(withText: description, andTextColor: UIColor.grayWith(value: 103.0), andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
            self.appointmentDescriptionLabel.isHidden = false
            self.appointmentDescriptionLabelBottomAnchor.constant = 10.0
         } else {
            self.appointmentDescriptionLabelTopAnchor.constant = 0.0
            self.appointmentDescriptionLabel.isHidden = true
            self.appointmentDescriptionLabelBottomAnchor.constant = self.appointment.duration.rawValue / 5.0 * 10.0 - 55.0
         }
      }
   }
   
}
