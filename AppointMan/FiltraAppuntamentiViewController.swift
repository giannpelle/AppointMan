//
//  FiltraAppuntamentiViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/14/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class FiltraAppuntamentiViewController: UIViewController {
   
   let employees = [(name: "Luca", image: #imageLiteral(resourceName: "thumbnail_1")), (name: "Francesca", image: #imageLiteral(resourceName: "thumbnail_2")), (name: "Alberto", image: #imageLiteral(resourceName: "thumbnail_3")), (name: "Carlotta", image: #imageLiteral(resourceName: "thumbnail_4")), (name: "Barbara", image: #imageLiteral(resourceName: "thumbnail_5")), (name: "Carlo", image: #imageLiteral(resourceName: "thumbnail_6")), (name: "Giovanni", image: #imageLiteral(resourceName: "thumbnail_7"))]
   let services = [(name: "Taglio Capelli", color: UIColor.orange), (name: "Colore", color: UIColor.purple), (name: "Acconciatura", color: UIColor.brown), (name: "Permanente", color: UIColor.red)]
   
   let bannerViewHeight: CGFloat = 390.0
   
   @IBOutlet weak var filterAppointmentsScrollView: UIScrollView!
   
   // BANNER
   @IBOutlet weak var filterBannerView: UIView!
   @IBOutlet weak var filterAppointmentsLabel: UILabel!
   @IBOutlet weak var employeeLabel: UILabel!
   @IBOutlet weak var employeePickerCollectionView: UICollectionView!
   @IBOutlet weak var disclosureIndicatorImageView: UIImageView!
   
   @IBOutlet weak var filterAppointmentsTableView: UITableView!
   
   var isBannerViewOpen: Bool = true {
      didSet {
         if self.isBannerViewOpen {
            self.filterBannerView.alpha = 1.0
            self.disclosureIndicatorImageView.alpha = 0.0
            if self.filterAppointmentsTableView.contentOffset.y > 0 {
               UIView.animate(withDuration: 0.7, animations: { 
                  self.filterAppointmentsTableView.contentOffset.y = 0.0
               }, completion: nil)
            }
         } else {
            self.filterBannerView.alpha = 0.0
            self.disclosureIndicatorImageView.alpha = 1.0
         }
      }
   }
   var currentPanGestureTranslationY: CGFloat = 0.0
   var isOpeningFilterBannerViewFromTable: Bool = false
   var isClosingFilterBannerViewFromTable: Bool = false
   var isTableViewDecelerating: Bool = false
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.filterAppointmentsScrollView.tag = 1
      self.filterAppointmentsScrollView.delegate = self
      
      self.filterAppointmentsLabel.attributedText = UILabel.attributedString(withText: "FILTRA APPUNTAMENTI", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
      self.employeeLabel.attributedText = UILabel.attributedString(withText: "DIPENDENTE/I", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      
      self.employeePickerCollectionView.tag = 2
      self.employeePickerCollectionView.delegate = self
      self.employeePickerCollectionView.dataSource = self
      
      self.filterAppointmentsTableView.tag = 3
      self.filterAppointmentsTableView.delegate = self
      self.filterAppointmentsTableView.dataSource = self
      self.filterAppointmentsTableView.estimatedRowHeight = 64.0
      self.filterAppointmentsTableView.backgroundColor = UIColor.clear
      self.filterAppointmentsTableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.filterAppointmentsTableView.bounds.size.width, height: 20.0))
      
   }
   
}

extension FiltraAppuntamentiViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 7
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as! ThumbnailCollectionViewCell
      cell.setup(withImage: self.employees[indexPath.row].image, andText: self.employees[indexPath.row].name)
      cell.thumbnailButton.isUserInteractionEnabled = false
      return cell
   }
   
}

extension FiltraAppuntamentiViewController: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if let cell = collectionView.cellForItem(at: indexPath) as? ThumbnailCollectionViewCell {
         cell.thumbnailButton.isSelected = !cell.thumbnailButton.isSelected
      }
   }
   
}

extension FiltraAppuntamentiViewController: UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return 6
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 10
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "filterAppointmentCellId") as! FilterAppointmentTableViewCell
      cell.backgroundColor = UIColor.clear
      cell.setup(withService: (serviceName: self.services[indexPath.row % 4].name, serviceTime: "10:30 - 11:30", serviceColor: self.services[indexPath.row % 4].color, customer: "Giorgia Pelucchi", employeeImage: self.employees[indexPath.row % 7].image))
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: 48.0))
      let titleLabel = UILabel()
      titleLabel.attributedText = UILabel.attributedString(withText: "1\(section) maggio 2017", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: 0.0)
      titleLabel.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
      headerView.addSubview(titleLabel)
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20.0).isActive = true
      titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -5.0).isActive = true
      
      let accessoryLayer = CAShapeLayer()
      let path = UIBezierPath()
      path.move(to: CGPoint(x: 24.0, y: 38.0))
      path.addLine(to: CGPoint(x: 26.0, y: 38.0))
      path.addLine(to: CGPoint(x: 26.0, y: 48.0))
      path.addLine(to: CGPoint(x: 24.0, y: 48.0))
      path.close()
      accessoryLayer.path = path.cgPath
      accessoryLayer.fillColor = UIColor.amBlue.cgColor
      headerView.layer.addSublayer(accessoryLayer)
      
      return headerView
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 48.0
   }
   
   func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
      let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: 10.0))
      
      let accessoryLayer = CAShapeLayer()
      let path = UIBezierPath()
      path.move(to: CGPoint(x: 24.0, y: 0.0))
      path.addLine(to: CGPoint(x: 26.0, y: 0.0))
      path.addLine(to: CGPoint(x: 26.0, y: 10.0))
      path.addLine(to: CGPoint(x: 24.0, y: 10.0))
      path.close()
      accessoryLayer.path = path.cgPath
      accessoryLayer.fillColor = UIColor.amBlue.cgColor
      footerView.layer.addSublayer(accessoryLayer)
      
      return footerView
   }
   
   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return 10.0
   }
}

extension FiltraAppuntamentiViewController: UITableViewDelegate {
   
}

extension FiltraAppuntamentiViewController: UIScrollViewDelegate {
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
      if scrollView.tag == 1 {
         print("scroll view didScroll")
         if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
         } else {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
               scrollView.contentOffset.y = 340.0
               return
            }
            if scrollView.contentOffset.y <= self.bannerViewHeight {
               self.filterBannerView.alpha = 1 - (scrollView.contentOffset.y / 340.0)
               self.disclosureIndicatorImageView.alpha = scrollView.contentOffset.y / 340.0
            } else {
               self.filterBannerView.alpha = 0.0
               self.disclosureIndicatorImageView.alpha = 1.0
               self.filterAppointmentsScrollView.contentOffset = CGPoint(x: 0.0, y: self.bannerViewHeight)
            }
         }
      } else if scrollView.tag == 3 {
         print("table view didScroll")
         self.currentPanGestureTranslationY += scrollView.panGestureRecognizer.translation(in: self.view).y
         
         if scrollView.contentOffset.y < 0 || self.isOpeningFilterBannerViewFromTable {
            if self.isBannerViewOpen {
               scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
            } else {
               if self.isTableViewDecelerating {
                  UIView.animate(withDuration: 1.4, animations: {
                     self.filterAppointmentsScrollView.contentOffset.y = 0.0
                  }, completion: { (success) in
                     self.isBannerViewOpen = true
                     self.isTableViewDecelerating = false
                  })
                  return
               }
               if !self.isOpeningFilterBannerViewFromTable {
                  scrollView.panGestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
                  self.isOpeningFilterBannerViewFromTable = true
                  self.currentPanGestureTranslationY = scrollView.panGestureRecognizer.translation(in: self.view).y
                  filterAppointmentsScrollView.contentOffset.y -= scrollView.panGestureRecognizer.translation(in: self.view).y
                  print(scrollView.panGestureRecognizer.translation(in: self.view).y)
                  filterAppointmentsTableView.contentOffset.y = 0.0
               } else {
                  self.currentPanGestureTranslationY += scrollView.panGestureRecognizer.translation(in: self.view).y
                  filterAppointmentsScrollView.contentOffset.y -= scrollView.panGestureRecognizer.translation(in: self.view).y
                  print(scrollView.panGestureRecognizer.translation(in: self.view).y)
                  filterAppointmentsTableView.contentOffset.y = 0.0
                  scrollView.panGestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
               }
            }
         } else {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
               scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.size.height
               return
            }
            if self.isBannerViewOpen {
               scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
               
               if !self.isClosingFilterBannerViewFromTable {
                  self.isClosingFilterBannerViewFromTable = true
                  self.currentPanGestureTranslationY = scrollView.panGestureRecognizer.translation(in: self.view).y
                  if filterAppointmentsScrollView.contentOffset.y - scrollView.panGestureRecognizer.translation(in: self.view).y < 0 {
                     filterAppointmentsScrollView.contentOffset.y = 0.0
                  } else {
                     filterAppointmentsScrollView.contentOffset.y -= scrollView.panGestureRecognizer.translation(in: self.view).y
                  }
                  scrollView.panGestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
               } else {
                  self.currentPanGestureTranslationY += scrollView.panGestureRecognizer.translation(in: self.view).y
                  if filterAppointmentsScrollView.contentOffset.y - scrollView.panGestureRecognizer.translation(in: self.view).y < 0 {
                     filterAppointmentsScrollView.contentOffset.y = 0.0
                  } else {
                     filterAppointmentsScrollView.contentOffset.y -= scrollView.panGestureRecognizer.translation(in: self.view).y
                  }
                  scrollView.panGestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
               }
            } else {
               // do nothing
            }
         }
      }
   }
   
   func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      guard !decelerate else {
         if scrollView.tag == 3 && scrollView.panGestureRecognizer.velocity(in: self.view).y > 0 {
            self.isTableViewDecelerating = true
         }
         if self.isBannerViewOpen {
            self.handleDidEndInteracting()
         }
         return
      }
      
      if scrollView.tag == 1 {
         self.handleDidEndInteracting()
      } else if scrollView.tag == 3 {
         if self.isOpeningFilterBannerViewFromTable {
            self.isOpeningFilterBannerViewFromTable = false
            
            self.handleDidEndInteracting()
         }
         if self.isClosingFilterBannerViewFromTable {
            self.isClosingFilterBannerViewFromTable = false
            
            self.handleDidEndInteracting()
         }
         scrollView.panGestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
      }
      
      self.currentPanGestureTranslationY = 0.0
   }
   
   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      
      if scrollView.tag == 1 {
         self.handleDidEndInteracting()
      } else if scrollView.tag == 3 {
         if self.isOpeningFilterBannerViewFromTable {
            self.isOpeningFilterBannerViewFromTable = false
            
            self.handleDidEndInteracting()
         }
         if self.isClosingFilterBannerViewFromTable {
            self.isClosingFilterBannerViewFromTable = false
            
            self.handleDidEndInteracting()
         }
         scrollView.panGestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
      }
      
      self.currentPanGestureTranslationY = 0.0
      self.isTableViewDecelerating = false
   }
   
   func handleDidEndInteracting() {
      if self.isBannerViewOpen {
         if self.filterAppointmentsScrollView.contentOffset.y > self.bannerViewHeight * 0.3 && self.filterAppointmentsScrollView.contentOffset.y <= self.bannerViewHeight {
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 12.0, options: [], animations: {
               self.filterAppointmentsScrollView.contentOffset = CGPoint(x: 0.0, y: 340.0)
               self.isBannerViewOpen = false
            }) { (success) in
               
            }
         } else if self.filterAppointmentsScrollView.contentOffset.y > self.bannerViewHeight {
            
         } else {
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 12.0, options: [], animations: {
               self.filterAppointmentsScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
               self.isBannerViewOpen = true
            }) { (success) in
               
            }
         }
      } else {
         if self.filterAppointmentsScrollView.contentOffset.y < self.bannerViewHeight * 0.7 && self.filterAppointmentsScrollView.contentOffset.y >= 0.0 {
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 12.0, options: [], animations: {
               self.filterAppointmentsScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
               self.isBannerViewOpen = true
            }) { (success) in
               
            }
         } else if self.filterAppointmentsScrollView.contentOffset.y < 0.0 {
            
         } else {
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 12.0, options: [], animations: {
               self.filterAppointmentsScrollView.contentOffset = CGPoint(x: 0.0, y: 340.0)
               self.isBannerViewOpen = false
            }) { (success) in
               
            }
         }
      }
   }
}
