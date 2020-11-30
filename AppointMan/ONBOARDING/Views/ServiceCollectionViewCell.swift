//
//  ServiceCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/14/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol ServiceCollectionViewCellDelegate: class {
   func deleteServices(services: [Service])
   func editServices(services: [Service])
}

class ServiceCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var serviceNameLabel: UILabel!
   @IBOutlet weak var serviceDurationLabel: UILabel!
   @IBOutlet weak var gendersStackView: UIStackView!
   
   weak var delegate: ServiceCollectionViewCellDelegate?
   
   var services: [Service] = [] {
      didSet {
         for view in self.gendersStackView.arrangedSubviews {
            self.gendersStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
         }
         
         if self.services.count == 2 {

            if let firstService = self.services.first, let serviceName = firstService.name, let serviceColor = ServiceColor(withInt16: firstService.color) {
               self.serviceNameLabel.attributedText = UILabel.attributedString(withText: serviceName, andTextColor: serviceColor.getColor(dark: true), andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
               self.leadingAccessoryRectLayer.fillColor = serviceColor.getColor().cgColor
               
               if let firstServiceDuration = self.services.first?.duration, let secondServiceDuration = self.services.last?.duration, firstServiceDuration > secondServiceDuration {
                  self.serviceDurationLabel.attributedText = UILabel.attributedString(withText: "\(secondServiceDuration) - \(firstServiceDuration) minuti", andTextColor:
                     serviceColor.getColor(), andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
               } else if let firstServiceDuration = self.services.first?.duration, let secondServiceDuration = self.services.last?.duration, firstServiceDuration < secondServiceDuration {
                  self.serviceDurationLabel.attributedText = UILabel.attributedString(withText: "\(firstServiceDuration) - \(secondServiceDuration) minuti", andTextColor:
                     serviceColor.getColor(), andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
               }
            }
            
            let maleImageView = UIImageView(image: Gender.male.getGenderMiniature())
            self.gendersStackView.addArrangedSubview(maleImageView)
            let femaleImageView = UIImageView(image: Gender.female.getGenderMiniature())
            self.gendersStackView.addArrangedSubview(femaleImageView)
            
         } else {
            if let service = self.services.first, let serviceName = service.name, let serviceColor = ServiceColor(withInt16: service.color) {
               self.leadingAccessoryRectLayer.fillColor = serviceColor.getColor().cgColor
               self.serviceNameLabel.attributedText = UILabel.attributedString(withText: serviceName, andTextColor: serviceColor.getColor(dark: true), andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: 0.0)
               self.serviceDurationLabel.attributedText = UILabel.attributedString(withText: "\(service.duration) minuti", andTextColor:
                  serviceColor.getColor(), andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: 0.0)
               let genderImageView = UIImageView(image: Gender(rawValue: Int(service.gender))?.getGenderMiniature())
               self.gendersStackView.addArrangedSubview(genderImageView)
            }
         }
      }
   }
   
   var leadingAccessoryRectLayer: CAShapeLayer!
   weak var overlayLayer: CALayer?
   weak var actionsStackView: UIStackView?
   var isActionsMenuOpen: Bool = false
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      self.contentView.layer.masksToBounds = false
      self.layer.masksToBounds = false
      
      // drawing the shadow
      let shadowLayer = CAShapeLayer()
      shadowLayer.fillColor = UIColor.white.cgColor
      let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
      shadowLayer.path = path
      shadowLayer.frame = self.bounds
      shadowLayer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      shadowLayer.shadowOpacity = 0.25
      shadowLayer.shadowRadius = 6.0
      shadowLayer.shadowOffset = .zero
      self.layer.insertSublayer(shadowLayer, at: 0)
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()

      self.hideOverlayMenu()
      self.applyTypography()
      self.drawLeadingAccessoryLayer()
   }
   
   func drawLeadingAccessoryLayer() {
      self.leadingAccessoryRectLayer = CAShapeLayer()
      let leadingAccessoryRectPath = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: 3.0, height: self.bounds.size.height))
      self.leadingAccessoryRectLayer.path = leadingAccessoryRectPath.cgPath
      self.leadingAccessoryRectLayer.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: self.bounds.size.height)
      self.layer.addSublayer(self.leadingAccessoryRectLayer)
   }
   
   func applyTypography() {
      self.serviceNameLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
      self.serviceDurationLabel.heightAnchor.constraint(equalToConstant: 13.0).isActive = true
   }
   
   func showOverlayMenu() {
      guard self.isActionsMenuOpen == false else {
         return
      }
      self.isActionsMenuOpen = true
      
      if let overlay = self.overlayLayer {
         self.layer.addSublayer(overlay)
      } else {
         let overlayLayer = CALayer()
         overlayLayer.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor
         overlayLayer.frame = self.bounds
         self.overlayLayer = overlayLayer
         self.layer.addSublayer(overlayLayer)
      }
      
      if let actionsMenu = self.actionsStackView {
         self.addSubview(actionsMenu)
         actionsMenu.translatesAutoresizingMaskIntoConstraints = false
         actionsMenu.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
         actionsMenu.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
         actionsMenu.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
      } else {
         let deleteButton = UIButton()
         deleteButton.setImage(#imageLiteral(resourceName: "iconcina_cestino"), for: .normal)
         deleteButton.addTarget(self, action: #selector(self.deleteServiceButtonPressed(sender:)), for: .touchUpInside)
         let editButton = UIButton()
         editButton.setImage(#imageLiteral(resourceName: "iconcina_action_matita"), for: .normal)
         editButton.addTarget(self, action: #selector(self.editServiceButtonPressed(sender:)), for: .touchUpInside)
         let stack = UIStackView(arrangedSubviews: [deleteButton, editButton])
         stack.axis = .horizontal
         stack.distribution = .fillEqually
         stack.alignment = .center
         stack.spacing = 24.0
         self.actionsStackView = stack
         self.addSubview(stack)
         stack.translatesAutoresizingMaskIntoConstraints = false
         stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
         stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
         stack.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
      }
   }
   
   func hideOverlayMenu() {
      guard self.isActionsMenuOpen else {
         return
      }
      self.isActionsMenuOpen = false
      
      if let overlay = self.overlayLayer {
         overlay.removeFromSuperlayer()
      }
      
      if let actionsMenu = self.actionsStackView {
         actionsMenu.removeFromSuperview()
      }
   }
   
   @objc func deleteServiceButtonPressed(sender: UIButton) {
      self.hideOverlayMenu()
      self.delegate?.deleteServices(services: self.services)
   }
   
   @objc func editServiceButtonPressed(sender: UIButton) {
      self.hideOverlayMenu()
      self.delegate?.editServices(services: self.services)
   }
   
}
