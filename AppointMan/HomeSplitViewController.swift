//
//  HomeSplitViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/11/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class HomeSplitViewController: UIViewController {
   
   @IBOutlet weak var horizontalMasterDetailStackView: UIStackView!
   @IBOutlet weak var masterWidthConstraint: NSLayoutConstraint!
   
   var magicKeyboardBackgroundViewHeightAnchor: NSLayoutConstraint!
   var overlayView: UIView!
   
   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.overlayView = UIView()
      self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
      
      self.horizontalMasterDetailStackView.arrangedSubviews[0].isHidden = true
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: .UIKeyboardWillHide, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
      
      let magicKeyboardBackgroundView = UIView()
      magicKeyboardBackgroundView.backgroundColor = UIColor.black
      self.view.addSubview(magicKeyboardBackgroundView)
      magicKeyboardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
      magicKeyboardBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
      magicKeyboardBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
      magicKeyboardBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
      self.magicKeyboardBackgroundViewHeightAnchor = magicKeyboardBackgroundView.heightAnchor.constraint(equalToConstant: 0.0)
      self.magicKeyboardBackgroundViewHeightAnchor.isActive = true
      
   }
   
   @objc func keyboardNotification(notification: NSNotification) {
      
      let isShowing = notification.name == .UIKeyboardWillShow
      
      if let userInfo = notification.userInfo {
         let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
         let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
         let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
         let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
         let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
         self.magicKeyboardBackgroundViewHeightAnchor.constant = isShowing ? (endFrame!.size.height) : 0.0
         UIView.animate(withDuration: duration,
                        delay: TimeInterval(0),
                        options: animationCurve,
                        animations: { self.view.layoutIfNeeded() },
                        completion: nil)
      }
   }
   
   deinit {
      NotificationCenter.default.removeObserver(self)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "loadingDetailContainerVC" {
         if let destVC = segue.destination as? UINavigationController, let homeVC = destVC.topViewController as? HomeViewController {
            homeVC.delegate = self
         }
      }
   }
   
}

extension HomeSplitViewController: HomeViewControllerDelegate, AddAppointmentViewControllerDelegate {
   
   func showOverlayView() {
      
      self.view.addSubview(self.overlayView)
      self.overlayView.translatesAutoresizingMaskIntoConstraints = false
      self.overlayView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
      self.overlayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
      self.overlayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
      self.overlayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
      self.overlayView.alpha = 0.0
      self.view.layoutIfNeeded()
      
      UIView.animate(withDuration: 0.2) {
         self.overlayView.alpha = 1.0
      }
      
   }
   
   func hideOverlayView() {
      
      self.overlayView.alpha = 1.0
      
      UIView.animate(withDuration: 0.2, animations: {
         self.overlayView.alpha = 0.0
      }, completion: { (completed) in
         self.overlayView.removeFromSuperview()
      })
      
   }
   
   //Clips percentage to 0:1 range
   func clipPercentCompletion(percentCompletion: inout CGFloat){
      if percentCompletion > 1.0 {percentCompletion = 1.0}
      else if percentCompletion < 0.0 {percentCompletion = 0}
   }
   
   func masterWidth() -> CGFloat{
      return self.horizontalMasterDetailStackView.arrangedSubviews[0].bounds.size.width
   }
   
   func openCloseMasterAnimated(shouldOpenView: Bool, time: Double?) {
      
      
      
      let duration = time == nil ? Const.defaultOpenCloseAnimationDuration : time
      
      if shouldOpenView{
         self.horizontalMasterDetailStackView.arrangedSubviews[0].isHidden = false
         self.masterWidthConstraint = self.masterWidthConstraint.setMultiplier(multiplier: 1.0)
      } else {
         self.masterWidthConstraint = self.masterWidthConstraint.setMultiplier(multiplier: Const.masterToAllWidthPercentage * 0.0001)
      }
      
      self.view.isUserInteractionEnabled = false
      
      UIView.animate(withDuration: duration!, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
         self.view.layoutIfNeeded()
      }) {
         (finished) in
         if finished && !shouldOpenView{
            self.horizontalMasterDetailStackView.arrangedSubviews[0].isHidden = true
         }
         if finished {
            self.view.isUserInteractionEnabled = true
         }
      }
   }
   
   func updateMasterWidth(withPercentCompletion percentCompletion: CGFloat) {
      self.horizontalMasterDetailStackView.arrangedSubviews[0].isHidden = false
      
      var percentCompletion = percentCompletion
      clipPercentCompletion(percentCompletion: &percentCompletion)
      
      switch percentCompletion {
      case 0:
         self.masterWidthConstraint = self.masterWidthConstraint.setMultiplier(multiplier: Const.masterToAllWidthPercentage * 0.1)
      case 1:
         self.masterWidthConstraint = self.masterWidthConstraint.setMultiplier(multiplier: 1.0)
      default:
         self.masterWidthConstraint = self.masterWidthConstraint.setMultiplier(multiplier: Const.masterToAllWidthPercentage * percentCompletion)
      }
   }
   
   func showAddAppointmentPopoverVC() {
      
      let addAppointmentVC = UIStoryboard.addAppointmentVC()
      addAppointmentVC.delegate = self
      let navController = UINavigationController(rootViewController: addAppointmentVC)
      navController.modalPresentationStyle = UIModalPresentationStyle.popover
      navController.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width / 2.0, height: UIScreen.main.bounds.size.height * (4.0 / 5.0))
      
      self.present(navController, animated: true)
      
      if let popPC = navController.popoverPresentationController {
         popPC.delegate = self
         popPC.sourceView = self.view
         popPC.sourceRect = self.view.bounds.offsetBy(dx: 0.0, dy: -30)
         popPC.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
      }
   }
   
}

extension HomeSplitViewController: UIPopoverPresentationControllerDelegate {
   
   func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
      self.hideOverlayView()
      let dragAndDropVC = UIStoryboard.dragAndDropVC()
      self.present(dragAndDropVC, animated: true, completion: nil)
   }
   
   func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
      return true
   }
}
