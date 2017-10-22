//
//  NewEmployeeViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/19/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class NewEmployeeViewController: UIViewController {
   
   @IBOutlet weak var newEmployeeLabel: UILabel!
   @IBOutlet weak var containerScrollView: UIScrollView!
   @IBOutlet weak var employeeImageView: UIImageView!
   @IBOutlet weak var employeeFirstNameFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeLastNameFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeCellPhoneNumberFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeEmailFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeWorkingHoursLabel: UILabel!
   @IBOutlet weak var addEmployeeWorkingHoursButton: UIButton!
   @IBOutlet weak var addEmployeeWorkingHoursButtonTrailingAnchor: NSLayoutConstraint!
   @IBOutlet weak var workingHoursStackView: UIStackView!
   @IBOutlet weak var servicesLabel: UILabel!
   @IBOutlet weak var addServicesButton: UIButton!
   @IBOutlet weak var employeeServicesCollectionView: UICollectionView!
   @IBOutlet weak var saveButton: UIButton!
   
   lazy var addEmployeeWorkingHoursButtonLeadingAnchor: NSLayoutConstraint = {
      return self.addEmployeeWorkingHoursButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0)
   }()
   lazy var inOutTransition = {
      return InOutAnimator()
   }()
   lazy var imagePicker = {
      return UIImagePickerController()
   }()
   lazy var bottomImagePickerView: BottomImagePickerView? = {
      guard let bottomImagePickerView = Bundle.main.loadNibNamed("BottomImagePickerView", owner: nil, options: nil)?.first as? BottomImagePickerView else {
         return nil
      }
      bottomImagePickerView.delegate = self
      self.imagePicker.delegate = self
      return bottomImagePickerView
   }()
   lazy var servicesInputView: ServicesInputView? = {
      guard let servicesInputView = Bundle.main.loadNibNamed("ServicesInputView", owner: nil, options: nil)?.first as? ServicesInputView else {
         return nil
      }
      servicesInputView.delegate = self
      return servicesInputView
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.newEmployeeLabel.attributedText = UILabel.attributedString(withText: "NUOVO DIPENDENTE", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
      self.employeeWorkingHoursLabel.attributedText = UILabel.attributedString(withText: "ORARIO DI LAVORO", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      if let workingHoursLabels = self.workingHoursStackView.arrangedSubviews as? [UILabel] {
         for (index, workingHoursLabel) in workingHoursLabels.enumerated() {
            workingHoursLabel.attributedText = UILabel.attributedString(withText: Date.weekDays(withShortFormat: true)[index].uppercased(), andTextColor: index % 3 == 0 ? UIColor.grayWith(value: 214) : UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
         }
      }
      self.servicesLabel.attributedText = UILabel.attributedString(withText: "SERVIZI", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.saveButton.setAttributedTitle(UILabel.attributedString(withText: "SALVA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 16.0)!, andCharacterSpacing: 1.14, isCentered: true), for: .normal)
      self.saveButton.setAttributedTitle(UILabel.attributedString(withText: "SALVA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 16.0)!, andCharacterSpacing: 1.14, isCentered: true), for: .disabled)
   }
   
   func setupUI() {
      self.employeeImageView.layer.cornerRadius = self.employeeImageView.bounds.size.width / 2.0
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showBottomImagePickerView(sender:)))
      self.employeeImageView.isUserInteractionEnabled = true
      self.employeeImageView.addGestureRecognizer(tapGesture)
      self.employeeFirstNameFloatingTextField.setPlaceholderText(placeholderText: "Nome")
      self.employeeFirstNameFloatingTextField.delegate = self
      self.employeeFirstNameFloatingTextField.tag = 0
      self.employeeLastNameFloatingTextField.setPlaceholderText(placeholderText: "Cognome")
      self.employeeLastNameFloatingTextField.delegate = self
      self.employeeLastNameFloatingTextField.tag = 1
      self.employeeCellPhoneNumberFloatingTextField.setPlaceholderText(placeholderText: "Telefono")
      self.employeeCellPhoneNumberFloatingTextField.delegate = self
      self.employeeCellPhoneNumberFloatingTextField.tag = 2
      self.employeeEmailFloatingTextField.setPlaceholderText(placeholderText: "Email")
      self.employeeEmailFloatingTextField.delegate = self
      self.employeeEmailFloatingTextField.tag = 3
      
      self.addEmployeeWorkingHoursButton.clipsToBounds = true
      self.addEmployeeWorkingHoursButton.layer.cornerRadius = 5.0
      if self.workingHoursStackView.isHidden {
         self.addEmployeeWorkingHoursButtonTrailingAnchor.isActive = false
         self.addEmployeeWorkingHoursButtonLeadingAnchor.isActive = true
         self.addEmployeeWorkingHoursButton.setImage(#imageLiteral(resourceName: "icona_aggiungi_orario"), for: .normal)
         self.addEmployeeWorkingHoursButton.setAttributedTitle(UILabel.attributedString(withText: "SELEZIONA ORARIO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
         self.addEmployeeWorkingHoursButton.setBackgroundColor(color: UIColor.amBlue, forState: .normal)
         self.addEmployeeWorkingHoursButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 13.0, 0.0, 22.0)
         self.addEmployeeWorkingHoursButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 6.0, 0.0, -6.0)
      } else {
         self.addEmployeeWorkingHoursButtonLeadingAnchor.isActive = false
         self.addEmployeeWorkingHoursButtonTrailingAnchor.isActive = true
         self.addEmployeeWorkingHoursButton.setImage(nil, for: .normal)
         self.addEmployeeWorkingHoursButton.setAttributedTitle(UILabel.attributedString(withText: "MODIFICA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
         self.addEmployeeWorkingHoursButton.setBackgroundColor(color: UIColor.grayWith(value: 182), forState: .normal)
         self.addEmployeeWorkingHoursButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)
         self.addEmployeeWorkingHoursButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
      }
      
      self.addEmployeeWorkingHoursButton.layer.cornerRadius = 5.0
      self.addServicesButton.setImage(#imageLiteral(resourceName: "on_boarding_plus"), for: .normal)
      self.addServicesButton.setImage(#imageLiteral(resourceName: "on_boarding_plus_disabled"), for: .disabled)
      self.employeeServicesCollectionView.dataSource = self
      self.employeeServicesCollectionView.delegate = self
      self.employeeServicesCollectionView.contentInset = UIEdgeInsetsMake(7.0, 20.0, 7.0, 20.0)
      (self.employeeServicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 100.0, height: 30.0)
      self.saveButton.layer.cornerRadius = 3.0
      self.saveButton.isEnabled = false
      self.saveButton.setBackgroundColor(color: UIColor.amBlue, forState: .normal)
      self.saveButton.setBackgroundColor(color: UIColor.grayWith(value: 236), forState: .disabled)
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      self.view.endEditing(true)
   }
   
   @IBAction func closeButtonPressed(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
   @objc func showBottomImagePickerView(sender: UITapGestureRecognizer) {
      if let bottomImagePickerView = self.bottomImagePickerView {
         bottomImagePickerView.alpha = 0.0
         bottomImagePickerView.bottomImagePickerViewBottomAnchor.constant = -158.0
         bottomImagePickerView.layoutIfNeeded()
         bottomImagePickerView.bottomImagePickerViewBottomAnchor.constant = 0.0
         
         self.view.addSubview(bottomImagePickerView)
         bottomImagePickerView.translatesAutoresizingMaskIntoConstraints = false
         bottomImagePickerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
         bottomImagePickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
         bottomImagePickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
         bottomImagePickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
         
         UIView.animate(withDuration: 0.7) {
            bottomImagePickerView.alpha = 1.0
            bottomImagePickerView.layoutIfNeeded()
         }
      }
   }
   
   func hideBottomImagePickerView() {
      if let bottomImagePickerView = self.bottomImagePickerView {
         bottomImagePickerView.bottomImagePickerViewBottomAnchor.constant = -158.0
         UIView.animate(withDuration: 0.7, animations: {
            bottomImagePickerView.layoutIfNeeded()
            bottomImagePickerView.alpha = 0.0
         }, completion: { (success) in
            if success {
               bottomImagePickerView.removeFromSuperview()
            }
         })
      }
   }
   
   @IBAction func addEmployeeWorkingHoursButtonPressed(sender: UIButton) {
      let workingHoursVC = UIStoryboard.workingHoursVC()
      self.inOutTransition.originFrame = sender.convert(sender.bounds, to: nil)
      self.inOutTransition.presentingVCFrame = self.view.convert(self.view.bounds, to: nil)
      workingHoursVC.transitioningDelegate = self
      self.present(workingHoursVC, animated: true, completion: nil)
   }
   
   @IBAction func addServicesButtonPressed(sender: UIButton) {
      
      if let servicesInputView = self.servicesInputView, let window = UIApplication.shared.keyWindow {
         servicesInputView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.height / 2.0) + 10.0)
         window.addSubview(servicesInputView)
         
         UIView.animate(withDuration: 0.7, animations: {
            self.containerScrollView.contentOffset.y = 310.0
            servicesInputView.frame.origin.y = (UIScreen.main.bounds.size.height / 2.0) - 10.0
         }, completion: { (success) in
            
         })
      }
   }
   
   @IBAction func saveButtonPressed(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
}

extension NewEmployeeViewController: BottomImagePickerViewDelegate {
   
   func takePhotoHandler() {
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
         self.imagePicker.allowsEditing = false
         self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
         self.imagePicker.cameraCaptureMode = .photo
         self.imagePicker.modalPresentationStyle = .fullScreen
         present(self.imagePicker,animated: true,completion: nil)
      }
   }
   
   func choosePhotoFromLibraryHandler() {
      self.imagePicker.allowsEditing = false
      self.imagePicker.sourceType = .photoLibrary
      self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
      present(self.imagePicker, animated: true, completion: nil)
   }
   
   func removePhotoHandler() {
      self.hideBottomImagePickerView()
   }
}

extension NewEmployeeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
         self.employeeImageView.image = chosenImage
      }
      self.hideBottomImagePickerView()
      self.dismiss(animated:true, completion: nil)
   }
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      self.hideBottomImagePickerView()
      self.dismiss(animated: true, completion: nil)
   }
}

extension UIImagePickerController {
   
   override open var shouldAutorotate: Bool {
      return true
   }
   override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
      return .landscape
   }
}

extension NewEmployeeViewController: ServicesInputViewDelegate {
   
   func resetContentOffset() {
      UIView.animate(withDuration: 0.7) {
         self.containerScrollView.contentOffset.y = 0.0
      }
   }
}

extension NewEmployeeViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 6
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "employeeServiceCellId", for: indexPath) as? EmployeeServiceCollectionViewCell else {
         return UICollectionViewCell()
      }
      
      return cell
   }
}

extension NewEmployeeViewController: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 10.0
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 14.0
   }
}

extension NewEmployeeViewController: UICollectionViewDelegate {
   
}

extension NewEmployeeViewController: UITextFieldDelegate {
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      switch textField.tag {
      case 0:
         self.employeeLastNameFloatingTextField.becomeFirstResponder()
      case 1:
         self.employeeCellPhoneNumberFloatingTextField.becomeFirstResponder()
      case 2:
         self.employeeEmailFloatingTextField.becomeFirstResponder()
      case 3:
         textField.resignFirstResponder()
      default:
         break
      }
      return false
   }
}

extension NewEmployeeViewController: UIViewControllerTransitioningDelegate {
   
   func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      self.inOutTransition.isPresenting = true
      self.inOutTransition.duration = 0.9
      return inOutTransition
   }
   
   func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      self.inOutTransition.isPresenting = false
      self.inOutTransition.duration = 0.7
      return inOutTransition
   }
}
