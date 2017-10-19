//
//  AddServicesViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 9/28/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class AddServicesViewController: UIViewController {
   
   @IBOutlet weak var servicesLabel: UILabel!
   @IBOutlet weak var sortLabel: UILabel!
   @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
   @IBOutlet weak var servicesCollectionView: UICollectionView!
   
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
      
      self.navigationController?.navigationBar.sizeToFit()
      
      self.applyTypography()
      self.setupCurrentNavigationItem()
      
      self.sortSegmentedControl.onBoardingSetUp(withOptions: ["DURATA", "A-Z"])
      
      self.servicesCollectionView.delegate = self
      self.servicesCollectionView.dataSource = self
      (self.servicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
      
   }
   
   func applyTypography() {
      self.servicesLabel.attributedText = UILabel.attributedString(withText: "Servizi", andTextColor: UIColor.amOnBoardingHeaderTextGrey, andFont: UIFont.init(name: "SFUIText-Regular", size: 22.0)!, andCharacterSpacing: 0.0)
      self.servicesLabel.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
      self.sortLabel.attributedText = UILabel.attributedString(withText: "Ordina", andTextColor: UIColor.amOnBoardingHeaderTextLightGrey, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.sortLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
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
   
   @objc func nextBarButtonItemPressed(sender: UIBarButtonItem) {
      let nextVC = UIStoryboard.addEmployeesVC()
      self.navigationController?.pushViewController(nextVC, animated: true)
   }
   
   @IBAction func newServiceButtonPressed(sender: UIButton) {
      let newServiceVC = UIStoryboard.newServiceVC()
      newServiceVC.modalPresentationStyle = .formSheet
      newServiceVC.preferredContentSize = CGSize(width: 540.0, height: 540.0)
      self.present(newServiceVC, animated: true, completion: nil)
   }
   
}

extension AddServicesViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 3
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 8
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCellId", for: indexPath) as? ServiceCollectionViewCell else {
         return UICollectionViewCell()
      }
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "onBoardingSectionHeaderId", for: indexPath) as? ServicesHeaderCollectionReusableView else {
         return UICollectionReusableView()
      }
      
      header.sectionType = SectionType(rawValue: indexPath.section)
      return header
   }
}

extension AddServicesViewController: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 160.0, height: 78.0)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSize(width: UIScreen.main.bounds.size.width, height: 64.0)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 8.0, left: 14.0, bottom: 8.0, right: 14.0)
   }
}

extension AddServicesViewController: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if let currentCell = collectionView.cellForItem(at: indexPath) as? ServiceCollectionViewCell {
         currentCell.showOverlayMenu()
      }
   }
   
}

extension AddServicesViewController: UIGestureRecognizerDelegate {
   
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
   }
}
