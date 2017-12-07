//
//  AddServicesViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 9/28/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class AddServicesViewController: UIViewController {
   
   @IBOutlet weak var navigationTitleViewLabel: UILabel!
   @IBOutlet weak var navigationRightBarButton: UIButton!
   @IBOutlet weak var servicesLabel: UILabel!
   @IBOutlet weak var addServiceButton: UIButton!
   @IBOutlet weak var sortLabel: UILabel!
   @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
   @IBOutlet weak var servicesCollectionView: UICollectionView!
   
   var coreDataStack: CoreDataStack!
   
   var isSortingDuration: Bool = true
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.navigationTitleViewLabel.attributedText = UILabel.attributedString(withText: "Aggiungi servizi", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
      self.navigationRightBarButton.setAttributedTitle(UILabel.attributedString(withText: "Avanti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
      self.servicesLabel.attributedText = UILabel.attributedString(withText: "Servizi", andTextColor: UIColor.amOnBoardingHeaderTextGrey, andFont: UIFont.init(name: "SFUIText-Regular", size: 22.0)!, andCharacterSpacing: 0.0)
      self.servicesLabel.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
      self.sortLabel.attributedText = UILabel.attributedString(withText: "Ordina", andTextColor: UIColor.amOnBoardingHeaderTextLightGrey, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.sortLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
   }
   
   func setupUI() {
      self.navigationRightBarButton.addTarget(self, action: #selector(self.nextBarButtonItemPressed(sender:)), for: .touchUpInside)
      self.addServiceButton.setImage(#imageLiteral(resourceName: "on_boarding_plus"), for: .normal)
      self.addServiceButton.setImage(#imageLiteral(resourceName: "on_boarding_plus_disabled"), for: .disabled)
      
      self.sortSegmentedControl.setup(withOptions: ["DURATA", "A-Z"], isBlueBackground: false)
      ServiceManager.shared.sorter = Sorter(withSortingProperty: "name", isAscending: true)
      
      self.servicesCollectionView.delegate = self
      self.servicesCollectionView.dataSource = self
      (self.servicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
   }
   
   @objc func nextBarButtonItemPressed(sender: UIBarButtonItem) {
      let nextVC = UIStoryboard.addEmployeesVC()
      self.navigationController?.pushViewController(nextVC, animated: true)
   }
   
   @IBAction func newServiceButtonPressed(sender: UIButton) {
      let newServiceVC = UIStoryboard.newServiceVC()
      newServiceVC.delegate = self
      newServiceVC.coreDataStack = self.coreDataStack
      newServiceVC.modalPresentationStyle = .formSheet
      newServiceVC.preferredContentSize = CGSize(width: 540.0, height: 540.0)
      self.present(newServiceVC, animated: true, completion: nil)
   }
   
   @IBAction func sortSegmentedControlValueChanged(_ sender: UISegmentedControl) {
      if self.isSortingDuration != (sender.selectedSegmentIndex == 0) {
         self.isSortingDuration = sender.selectedSegmentIndex == 0
         ServiceManager.shared.sorter = Sorter(withSortingProperty: self.isSortingDuration ? "duration" : "name", isAscending: true)
         self.servicesCollectionView.reloadData()
      }
   }
   
}

extension AddServicesViewController: NewServiceViewControllerDelegate {
   
   func didUpdateServices() {
      self.servicesCollectionView.reloadData()
   }
}

extension AddServicesViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return ServiceManager.shared.getAddServicesNumberOfSections()
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return ServiceManager.shared.getAddServicesNumberOfRows(for: section)
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCellId", for: indexPath) as? ServiceCollectionViewCell else {
         return UICollectionViewCell()
      }
      cell.services = ServiceManager.shared.addServicesServices(forItemAt: indexPath)
      cell.delegate = self
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "onBoardingSectionHeaderId", for: indexPath) as? ServicesHeaderCollectionReusableView else {
         return UICollectionReusableView()
      }
      
      header.sectionType = SectionType(rawValue: ServiceManager.shared.addServicesSectionHeaderIndex(for: indexPath))
      header.setNeedsDisplay()
      return header
   }
}

extension AddServicesViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 160.0, height: 78.0)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSize(width: UIScreen.main.bounds.size.width, height: 44.0)
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

extension AddServicesViewController: ServiceCollectionViewCellDelegate {
   func editServices(services: [Service]) {
      let newServiceVC = UIStoryboard.newServiceVC()
      newServiceVC.delegate = self
      newServiceVC.coreDataStack = self.coreDataStack
      newServiceVC.services = services
      newServiceVC.modalPresentationStyle = .formSheet
      newServiceVC.preferredContentSize = CGSize(width: 540.0, height: 540.0)
      self.present(newServiceVC, animated: true, completion: nil)
   }
   
   func deleteServices(services: [Service]) {
      ServiceManager.shared.deleteServices(services: services)
      self.servicesCollectionView.reloadData()
   }
}
