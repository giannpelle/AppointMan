//
//  AddEmployeesViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 9/28/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class AddEmployeesViewController: UIViewController {
   
   @IBOutlet weak var employeesLabel: UILabel!
   @IBOutlet weak var employeesCollectionView: UICollectionView!
   
   var tapOverlayGesture: UITapGestureRecognizer!
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      self.tapOverlayGesture = UITapGestureRecognizer(target: self, action: #selector(self.overlayTapped(sender:)))
      self.tapOverlayGesture.delegate = self
      self.tapOverlayGesture.numberOfTapsRequired = 1
      self.tapOverlayGesture.cancelsTouchesInView = false
      self.view.window?.addGestureRecognizer(self.tapOverlayGesture)
   }
   
   @objc func overlayTapped(sender: UITapGestureRecognizer) {
      if sender.state == .ended {
         guard let presentedView = presentedViewController?.view else {
            return
         }
         if let inputView = UIApplication.shared.keyWindow?.subviews.last as? ServicesInputView, sender.location(in: inputView).y > 0 {
            return
         }
         if !presentedView.bounds.contains(sender.location(in: presentedView)) {
            if let inputView = UIApplication.shared.keyWindow?.subviews.last as? ServicesInputView, let presentedVC = self.presentedViewController as? NewEmployeeViewController {
               UIView.animate(withDuration: 0.7, animations: {
                  presentedVC.containerScrollView.contentOffset.y = 0.0
                  inputView.frame.origin.y = UIScreen.main.bounds.size.height
               }, completion: { (success) in
                  if success {
                     inputView.removeFromSuperview()
                  }
               })
            } else {
               self.dismiss(animated: true, completion: nil)
            }
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
      self.applyTypography()
      self.setupUI()
      
   }
   
   func applyTypography() {
      
      self.employeesLabel.attributedText = UILabel.attributedString(withText: "Dipendenti", andTextColor: UIColor.amOnBoardingHeaderTextGrey, andFont: UIFont.init(name: "SFUIText-Regular", size: 22.0)!, andCharacterSpacing: 0.0)
      self.employeesLabel.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
   }
   
   func setupUI() {
      
      self.employeesCollectionView.dataSource = self
      self.employeesCollectionView.delegate = self
      self.employeesCollectionView.contentInset = UIEdgeInsetsMake(6.0, 26.0, 6.0, 26.0)
      
   }
   
   func setupCurrentNavigationItem() {
      // navigation bar title
      self.navigationItem.titleView = UILabel.onBoardingTitleView(withText: "Aggiungi dipendenti")
      
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
   
   @IBAction func newEmployeeButtonPressed(sender: UIButton) {
      let newServiceVC = UIStoryboard.newEmployeeVC()
      newServiceVC.modalPresentationStyle = .formSheet
      newServiceVC.preferredContentSize = CGSize(width: 540.0, height: 645.0)
      self.present(newServiceVC, animated: true, completion: nil)
   }
   
}

extension AddEmployeesViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 5
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "employeeCellId", for: indexPath) as? EmployeeCollectionViewCell else {
         return UICollectionViewCell()
      }
      
      let images = [#imageLiteral(resourceName: "thumbnail_1"), #imageLiteral(resourceName: "thumbnail_2"), #imageLiteral(resourceName: "thumbnail_3"), #imageLiteral(resourceName: "thumbnail_4"), #imageLiteral(resourceName: "thumbnail_5")]
      cell.employeeImageView.image = images[indexPath.row]
      
      return cell
   }
}

extension AddEmployeesViewController: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 314.0, height: 320.0)
   }
}

extension AddEmployeesViewController: UICollectionViewDelegate {
   
}

extension AddEmployeesViewController: UIGestureRecognizerDelegate {
   
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
   }
}
