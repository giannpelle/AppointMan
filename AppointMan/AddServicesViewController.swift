//
//  AddServicesViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 9/28/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class AddServicesViewController: UIViewController {
   
   var tapOverlayGesture: UITapGestureRecognizer!
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      self.tapOverlayGesture = UITapGestureRecognizer(target: self, action: #selector(self.overlayTapped(sender:)))
      self.tapOverlayGesture.delegate = self
      self.tapOverlayGesture.numberOfTapsRequired = 1
      self.tapOverlayGesture.cancelsTouchesInView = false
      self.view.window?.addGestureRecognizer(self.tapOverlayGesture)
   }
   
   func overlayTapped(sender: UITapGestureRecognizer) {
      if sender.state == .ended {
         guard let presentedView = presentedViewController?.view else {
            return
         }
         if !presentedView.bounds.contains(sender.location(in: presentedView)) {
            self.dismiss(animated: true, completion: nil)
         }
      }
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      self.view.window?.removeGestureRecognizer(tapOverlayGesture)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.setupCurrentNavigationItem()
   }
   
   func setupCurrentNavigationItem() {
      // navigation bar title
      self.navigationItem.titleView = UILabel.onBoardingTitleView(withText: "Aggiungi servizi")
      
      // Avanti bar button item
      let nextBarButton = UIButton()
      nextBarButton.addTarget(self, action: #selector(self.nextBarButtonItemPressed(sender:)), for: .touchUpInside)
      nextBarButton.setAttributedTitle(UILabel.attributedString(withText: "Avanti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
      let nextBarButtonItem = UIBarButtonItem(customView: nextBarButton)
      self.navigationItem.rightBarButtonItem = nextBarButtonItem
      
   }
   
   func nextBarButtonItemPressed(sender: UIBarButtonItem) {
      let nextVC = UIStoryboard.addEmployeesVC()
      self.navigationController?.pushViewController(nextVC, animated: true)
   }
   
   @IBAction func centeredButtonPressed(sender: UIButton) {
      if let newServiceVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "newServiceVC") as? NewServiceViewController {
         newServiceVC.modalPresentationStyle = .formSheet
         newServiceVC.preferredContentSize = CGSize(width: 540.0, height: 540.0)
         self.present(newServiceVC, animated: true, completion: nil)
      }
   }
   
}

extension AddServicesViewController: UIGestureRecognizerDelegate {
   
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
   }
}
