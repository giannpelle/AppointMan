//
//  BottomImagePickerView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/20/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class BottomImagePickerView: UIView {
   
   @IBOutlet weak var imagePickerActionsStackView: UIStackView!
   @IBOutlet weak var bottomImagePickerViewBottomAnchor: NSLayoutConstraint!
   
   weak var imagePickerDelegate: NewEmployeeViewControllerDelegate?
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.setupUI()
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      if let touch = touches.first {
         if touch.view == self {
            self.bottomImagePickerViewBottomAnchor.constant = -158.0
            UIView.animate(withDuration: 0.7, animations: {
               self.layoutIfNeeded()
               self.alpha = 0.0
            }, completion: { (success) in
               if success {
                  self.removeFromSuperview()
               }
            })
         }
      }
   }
   
   func setupUI() {
      self.backgroundColor = UIColor.black.withAlphaComponent(0.54)
      
      if let actions = self.imagePickerActionsStackView.arrangedSubviews as? [UIButton] {
         actions[0].setAttributedTitle(UILabel.attributedString(withText: "SCATTA FOTO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
         actions[0].addTarget(self, action: #selector(self.takePhotoHandler(sender:)), for: .touchUpInside)
         
         actions[1].setAttributedTitle(UILabel.attributedString(withText: "SCEGLI UNA FOTO ESISTENTE", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
         actions[1].addTarget(self, action: #selector(self.choosePhotoFromLibraryHandler(sender:)), for: .touchUpInside)
         
         actions[2].setAttributedTitle(UILabel.attributedString(withText: "RIMUOVI IMMAGINE", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
         actions[2].addTarget(self, action: #selector(self.removeImageHandler(sender:)), for: .touchUpInside)
         actions[2].isEnabled = false
         
         actions.forEach { $0.contentEdgeInsets = UIEdgeInsetsMake(0.0, 32.0, 0.0, 32.0) }
      }
   }
   
   @objc func takePhotoHandler(sender: UIButton) {
      self.imagePickerDelegate?.takePhotoHandler()
   }
   
   @objc func choosePhotoFromLibraryHandler(sender: UIButton) {
      self.imagePickerDelegate?.choosePhotoFromLibraryHandler()
   }
   
   @objc func removeImageHandler(sender: UIButton) {
      self.imagePickerDelegate?.removePhotoHandler()
   }
   
}
