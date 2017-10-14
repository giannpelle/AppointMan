//
//  ClosingDaysViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/14/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ClosingDaysViewController: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
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
   
   func nextBarButtonItemPressed(sender: UIBarButtonItem) {
      //let nextVC = UIStoryboard.addEmployeesVC()
      //self.navigationController?.pushViewController(nextVC, animated: true)
      //nextVC.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "on_boarding_back_button"), style: .plain, target: self, action: nil)
   }
   
   func backBarButtonItemPressed(sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
   }
   
}
