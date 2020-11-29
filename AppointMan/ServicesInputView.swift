//
//  ServicesInputView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/21/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol ServicesInputViewDelegate: class {
   func resetContentOffset()
   func didUpdateServices(services: [Service])
}

class ServicesInputView: UIView {

   @IBOutlet weak var topAccessoryView: UIView!
   @IBOutlet weak var employeeFullNameLabel: UILabel!
   @IBOutlet weak var cancelButton: UIButton!
   @IBOutlet weak var doneButton: UIButton!
   @IBOutlet weak var servicesCollectionView: UICollectionView!
   
   weak var delegate: ServicesInputViewDelegate?
   
   var services: [Service] = []
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
      self.setupUI()
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      
   }
   
   func applyTypography() {
      self.employeeFullNameLabel.attributedText = UILabel.attributedString(withText: "FRANCESCA LOPELLI", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
      self.cancelButton.setAttributedTitle(UILabel.attributedString(withText: "Annulla", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
      self.doneButton.setAttributedTitle(UILabel.attributedString(withText: "Salva", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
   }
   
   func setupUI() {
      let maskLayer = CAShapeLayer()
      maskLayer.path = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.height / 2.0) + 10.0), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
      self.layer.mask = maskLayer
      
      self.servicesCollectionView.dataSource = self
      self.servicesCollectionView.delegate = self
      self.servicesCollectionView.contentInset = UIEdgeInsetsMake(15.0, 18.0, 15.0, 18.0)
      self.servicesCollectionView.register(UINib(nibName: "ServiceInputViewCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "serviceInputViewCellId")
   }
   
   @IBAction func cancelButtonPressed(sender: UIButton) {
      self.dismissInputView()
   }
   
   @IBAction func doneButtonPressed(sender: UIButton) {
      self.dismissInputView()
   }
   
   func dismissInputView() {
      self.delegate?.resetContentOffset()
      
      UIView.animate(withDuration: 0.7, animations: {
         self.frame.origin.y = UIScreen.main.bounds.size.height
      }) { (success) in
         if success {
            self.removeFromSuperview()
         }
      }
   }

}

extension ServicesInputView: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return ServiceManager.shared.getNumberOfServices()
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceInputViewCellId", for: indexPath) as? ServiceInputViewCollectionViewCell  else {
         return UICollectionViewCell()
      }
      
      if let currentService = ServiceManager.shared.getInputViewService(forItemAt: indexPath) {
         cell.isSelected = self.services.contains(currentService)
         cell.service = currentService
      }
      return cell
   }
}

extension ServicesInputView: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 160.0, height: 78.0)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 32.0
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 12.0
   }
   
}

extension ServicesInputView: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if let currentCell = collectionView.cellForItem(at: indexPath) as? ServiceInputViewCollectionViewCell {
         if currentCell.isServiceSelected {
            currentCell.removeSelectionBorderLayer()
            if let serviceIndex = self.services.index(where: { (service) -> Bool in
               return service.name == currentCell.service.name && service.gender == currentCell.service.gender
            }) {
               self.services.remove(at: serviceIndex)
            }
            self.delegate?.didUpdateServices(services: self.services)
         } else {
            currentCell.showSelectionBorderLayer()
            self.services.append(currentCell.service)
            self.delegate?.didUpdateServices(services: self.services)
         }
      }
   }
}

