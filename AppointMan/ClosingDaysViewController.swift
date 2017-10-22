//
//  ClosingDaysViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/14/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ClosingDaysViewController: UIViewController {
   
   @IBOutlet weak var closingDaysLabel: UILabel!
   @IBOutlet weak var closureLabel: UILabel!
   @IBOutlet weak var weekDaysStackView: UIStackView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
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
   
   func setupCurrentNavigationItem() {
      // navigation bar title
      self.navigationItem.titleView = UILabel.onBoardingTitleView(withText: "Seleziona giorni di chiusura")
      
      // Avanti bar button item
      let nextBarButton = UIButton()
      nextBarButton.addTarget(self, action: #selector(self.nextBarButtonItemPressed(sender:)), for: .touchUpInside)
      nextBarButton.setAttributedTitle(UILabel.attributedString(withText: "Avanti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
      let nextBarButtonItem = UIBarButtonItem(customView: nextBarButton)
      self.navigationItem.rightBarButtonItem = nextBarButtonItem
      
      // Back button item
      let backButton = UIButton()
      backButton.addTarget(self, action: #selector(self.backBarButtonItemPressed(sender:)), for: .touchUpInside)
      backButton.setImage(#imageLiteral(resourceName: "on_boarding_back_button"), for: .normal)
      backButton.sizeToFit()
      let backBarButtonItem = UIBarButtonItem(customView: backButton)
      self.navigationItem.leftBarButtonItem = backBarButtonItem
   }
   
   @objc func nextBarButtonItemPressed(sender: UIBarButtonItem) {
      //let nextVC = UIStoryboard.addEmployeesVC()
      //self.navigationController?.pushViewController(nextVC, animated: true)
      //nextVC.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "on_boarding_back_button"), style: .plain, target: self, action: nil)
   }
   
   @objc func backBarButtonItemPressed(sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
   }
   
}
