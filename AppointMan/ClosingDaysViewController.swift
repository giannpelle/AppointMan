//
//  ClosingDaysViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/14/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ClosingDaysViewController: UIViewController {
   
   @IBOutlet weak var navigationTitleViewLabel: UILabel!
   @IBOutlet weak var navigationRightBarButton: UIButton!
   @IBOutlet weak var navigationBackButton: UIButton!
   @IBOutlet weak var closingDaysLabel: UILabel!
   @IBOutlet weak var closureLabel: UILabel!
   @IBOutlet weak var weekDaysStackView: UIStackView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.navigationTitleViewLabel.attributedText = UILabel.attributedString(withText: "Seleziona giorni di chiusura", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
      self.navigationRightBarButton.setAttributedTitle(UILabel.attributedString(withText: "Fine", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
      self.closingDaysLabel.attributedText = UILabel.attributedString(withText: "Giorni di chiusura", andTextColor: UIColor.grayWith(value: 85), andFont: UIFont.init(name: "SFUIText-Regular", size: 22.0)!, andCharacterSpacing: nil)
      self.closureLabel.attributedText = UILabel.attributedString(withText: "TURNO DI CHIUSURA", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      if let weekDayButtons = self.weekDaysStackView.arrangedSubviews as? [UIButton] {
         for (index, weekDayButton) in weekDayButtons.enumerated() {
            weekDayButton.setAttributedTitle(UILabel.attributedString(withText: Date.weekDays(withShortFormat: true)[index].uppercased(), andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
            weekDayButton.setAttributedTitle(UILabel.attributedString(withText: Date.weekDays(withShortFormat: true)[index].uppercased(), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true), for: .selected)
            weekDayButton.setAttributedTitle(UILabel.attributedString(withText: Date.weekDays(withShortFormat: true)[index].uppercased(), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 14.0)!, andCharacterSpacing: nil, isCentered: true), for: .highlighted)
         }
      }
   }
   
   func setupUI() {
      self.navigationRightBarButton.addTarget(self, action: #selector(self.nextBarButtonItemPressed(sender:)), for: .touchUpInside)
      self.navigationBackButton.addTarget(self, action: #selector(self.backBarButtonItemPressed(sender:)), for: .touchUpInside)
      
      if let weekDayButtons = self.weekDaysStackView.arrangedSubviews as? [UIButton] {
         for weekDayButton in weekDayButtons {
            weekDayButton.clipsToBounds = true
            weekDayButton.layer.cornerRadius = 3.0
            weekDayButton.setBackgroundColor(color: UIColor(red: 227/255.0, green: 227/255.0, blue: 234/255.0, alpha: 1.0), forState: .normal)
            weekDayButton.setBackgroundColor(color: UIColor.amBlue, forState: .selected)
            weekDayButton.setBackgroundColor(color: UIColor.amBlue, forState: .highlighted)
            weekDayButton.addTarget(self, action: #selector(self.weekDayButtonPressed(sender:)), for: .touchUpInside)
         }
      }
   }
   
   @objc func weekDayButtonPressed(sender: UIButton) {
      sender.isSelected = !sender.isSelected
   }
   
   @objc func nextBarButtonItemPressed(sender: UIBarButtonItem) {
      let homeVC = UIStoryboard.revealMenuVC()
      self.present(homeVC, animated: true, completion: nil)
      //nextVC.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "on_boarding_back_button"), style: .plain, target: self, action: nil)
   }
   
   @objc func backBarButtonItemPressed(sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
   }
   
}
