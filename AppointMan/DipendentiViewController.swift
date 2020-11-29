//
//  DipendentiViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/13/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class DipendentiViewController: UIViewController {
   
   @IBOutlet weak var employeesLabel: UILabel!
   @IBOutlet weak var employeeTableView: UITableView!
   @IBOutlet weak var employeeDetailCollectionView: UICollectionView!
   
   weak var revealMenuDelegate: RevealMenuDelegate?
   
   let timetable: [[(from: String, to: String)]] = [[(from: "9:00", to: "11:30"), (from: "9:00", to: "11:30")], [(from: "9:00", to: "11:30")], [], [(from: "9:00", to: "11:30"), (from: "9:00", to: "11:30"), (from: "9:00", to: "11:30")], [], [], [(from: "9:00", to: "11:30")]]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.employeesLabel.attributedText = UILabel.attributedString(withText: "Dipendenti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
   }
   
   func setupUI() {
      self.employeeDetailCollectionView.delegate = self
      self.employeeDetailCollectionView.dataSource = self
      (self.employeeDetailCollectionView.collectionViewLayout as? PinterestLayout)?.delegate = self
      self.employeeDetailCollectionView.register(UINib(nibName: "EmployeeGeneralInfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "employeeGeneralInfoCellId")
      self.employeeDetailCollectionView.register(UINib(nibName: "EmployeeWorkingHoursCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "employeeWorkingHoursCellId")
   }
   
   @IBAction func hamburgerMenuButtonPressed(sender: UIButton) {
      self.revealMenuDelegate?.openRevealMenu()
   }
   
   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      
      print(self.employeeDetailCollectionView.bounds)
   }
   
}

extension DipendentiViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 2
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      switch indexPath.row {
      case 0:
         if let generalInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "employeeGeneralInfoCellId", for: indexPath) as? EmployeeGeneralInfoCollectionViewCell {
            return generalInfoCell
         }
      case 1:
         if let employeeWorkingHoursCell = collectionView.dequeueReusableCell(withReuseIdentifier: "employeeWorkingHoursCellId", for: indexPath) as? EmployeeWorkingHoursCollectionViewCell {
            employeeWorkingHoursCell.timetable = self.timetable
            return employeeWorkingHoursCell
         }
      default:
         return UICollectionViewCell()
      }
      
      return UICollectionViewCell()
   }
}

extension DipendentiViewController: UICollectionViewDelegate {
   
}

extension DipendentiViewController: PinterestLayoutDelegate {
   
   func collectionView(_ collectionView: UICollectionView, heightForCardViewAt indexPath: IndexPath) -> CGFloat {
      
      switch indexPath.row {
      case 0:
         return (146.0 + UIFont.init(name: "SFUIText-Semibold", size: 16.0)!.lineHeight + UIFont.init(name: "SFUIText-Regular", size: 13.0)!.lineHeight + UIFont.init(name: "SFUIText-Regular", size: 13.0)!.lineHeight).rounded(.up)
      case 1:
         if let maxNumberOfIntervals = (self.timetable.sorted { $0.count > $1.count }.first?.count), maxNumberOfIntervals > 0 {
            return (151.0 + UIFont.init(name: "SFUIText-Bold", size: 12.0)!.lineHeight + UIFont.init(name: "SFUIText-Bold", size: 12.0)!.lineHeight + UIFont.init(name: "SFUIText-Bold", size: 12.0)!.lineHeight + (maxNumberOfIntervals - 1) * 15.0 + maxNumberOfIntervals * 35.0).rounded(.up)
         } else {
            return (151.0 + UIFont.init(name: "SFUIText-Bold", size: 12.0)!.lineHeight + UIFont.init(name: "SFUIText-Bold", size: 12.0)!.lineHeight + UIFont.init(name: "SFUIText-Bold", size: 12.0)!.lineHeight).rounded(.up)
         }
      default:
         return 80.0
      }
   }

}
