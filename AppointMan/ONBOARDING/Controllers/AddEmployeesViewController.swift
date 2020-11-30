//
//  AddEmployeesViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 9/28/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class AddEmployeesViewController: UIViewController {
   
   @IBOutlet weak var navigationTitleViewLabel: UILabel!
   @IBOutlet weak var navigationRightBarButton: UIButton!
   @IBOutlet weak var navigationBackButton: UIButton!
   @IBOutlet weak var employeesLabel: UILabel!
   @IBOutlet weak var addEmployeeButton: UIButton!
   @IBOutlet weak var employeesCollectionView: UICollectionView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.navigationTitleViewLabel.attributedText = UILabel.attributedString(withText: "Aggiungi dipendenti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
      self.navigationRightBarButton.setAttributedTitle(UILabel.attributedString(withText: "Avanti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
      self.employeesLabel.attributedText = UILabel.attributedString(withText: "Dipendenti", andTextColor: UIColor.amOnBoardingHeaderTextGrey, andFont: UIFont.init(name: "SFUIText-Regular", size: 22.0)!, andCharacterSpacing: 0.0)
      self.employeesLabel.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
   }
   
   func setupUI() {
      self.navigationRightBarButton.addTarget(self, action: #selector(self.nextBarButtonItemPressed(sender:)), for: .touchUpInside)
      self.navigationBackButton.addTarget(self, action: #selector(self.backBarButtonItemPressed(sender:)), for: .touchUpInside)
      
      self.addEmployeeButton.setImage(#imageLiteral(resourceName: "on_boarding_plus"), for: .normal)
      self.addEmployeeButton.setImage(#imageLiteral(resourceName: "on_boarding_plus"), for: .highlighted)
      self.addEmployeeButton.setImage(#imageLiteral(resourceName: "on_boarding_plus_disabled"), for: .disabled)
      
      self.employeesCollectionView.dataSource = self
      self.employeesCollectionView.delegate = self
      self.employeesCollectionView.contentInset = UIEdgeInsetsMake(12.0, 26.0, 12.0, 26.0)
   }
   
   @objc func nextBarButtonItemPressed(sender: UIBarButtonItem) {
      let nextVC = UIStoryboard.closingDaysVC()
      self.navigationController?.pushViewController(nextVC, animated: true)
   }
   
   @objc func backBarButtonItemPressed(sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
   }
   
   @IBAction func newEmployeeButtonPressed(sender: UIButton) {
      let newEmployeeVC = UIStoryboard.newEmployeeVC()
      newEmployeeVC.delegate = self
      newEmployeeVC.modalPresentationStyle = .formSheet
      newEmployeeVC.preferredContentSize = CGSize(width: 540.0, height: 645.0)
      self.present(newEmployeeVC, animated: true, completion: nil)
   }
   
}

extension AddEmployeesViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return EmployeeManager.shared.getNumberOfRows()
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "employeeCellId", for: indexPath) as? EmployeeCollectionViewCell else {
         return UICollectionViewCell()
      }
      
      cell.delegate = self
      cell.employee = EmployeeManager.shared.employee(forItemAt: indexPath)
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

extension AddEmployeesViewController: NewEmployeeViewControllerDelegate {
   
   func didUpdateEmployees() {
      self.employeesCollectionView.reloadData()
   }
}

extension AddEmployeesViewController: EmployeeCollectionViewCellDelegate {
  
   func editEmployee(employee: Employee) {
      let newEmployeeVC = UIStoryboard.newEmployeeVC()
      newEmployeeVC.delegate = self
      newEmployeeVC.employee = employee
      newEmployeeVC.modalPresentationStyle = .formSheet
      newEmployeeVC.preferredContentSize = CGSize(width: 540.0, height: 645.0)
      self.present(newEmployeeVC, animated: true, completion: nil)
   }
}
