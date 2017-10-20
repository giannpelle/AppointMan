//
//  NewEmployeeViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/19/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol NewEmployeeViewControllerDelegate: class {
   func takePhotoHandler()
   func choosePhotoFromLibraryHandler()
   func removePhotoHandler()
}

class NewEmployeeViewController: UIViewController {
   
   @IBOutlet weak var newEmployeeLabel: UILabel!
   @IBOutlet weak var employeeImageView: UIImageView!
   @IBOutlet weak var employeeFirstNameFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeLastNameFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeCellPhoneNumberFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeEmailFloatingTextField: GPFloatingTextField!
   @IBOutlet weak var employeeWorkingHoursLabel: UILabel!
   @IBOutlet weak var addEmployeeWorkingHoursButton: UIButton!
   @IBOutlet weak var servicesLabel: UILabel!
   @IBOutlet weak var saveButton: UIButton!
   
   let inOutTransition = InOutAnimator()
   let imagePicker = UIImagePickerController()
   lazy var bottomImagePickerView: BottomImagePickerView? = {
      guard let bottomImagePickerView = Bundle.main.loadNibNamed("BottomImagePickerView", owner: nil, options: nil)?.first as? BottomImagePickerView else {
         return nil
      }
      bottomImagePickerView.imagePickerDelegate = self
      bottomImagePickerView.alpha = 0.0
      bottomImagePickerView.bottomImagePickerViewBottomAnchor.constant = -158.0
      bottomImagePickerView.layoutIfNeeded()
      bottomImagePickerView.bottomImagePickerViewBottomAnchor.constant = 0.0
      self.imagePicker.delegate = self
      return bottomImagePickerView
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.newEmployeeLabel.attributedText = UILabel.attributedString(withText: "NUOVO DIPENDENTE", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86, isCentered: true)
      self.employeeWorkingHoursLabel.attributedText = UILabel.attributedString(withText: "ORARIO DI LAVORO", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.addEmployeeWorkingHoursButton.setAttributedTitle(UILabel.attributedString(withText: "SELEZIONA ORARIO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
      self.servicesLabel.attributedText = UILabel.attributedString(withText: "SERVIZI", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.saveButton.setAttributedTitle(UILabel.attributedString(withText: "SALVA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 16.0)!, andCharacterSpacing: 1.14, isCentered: true), for: .normal)
   }
   
   func setupUI() {
      self.employeeImageView.layer.cornerRadius = self.employeeImageView.bounds.size.width / 2.0
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showBottomImagePickerView(sender:)))
      self.employeeImageView.isUserInteractionEnabled = true
      self.employeeImageView.addGestureRecognizer(tapGesture)
      self.employeeFirstNameFloatingTextField.setPlaceholderText(placeholderText: "Nome")
      self.employeeLastNameFloatingTextField.setPlaceholderText(placeholderText: "Cognome")
      self.employeeCellPhoneNumberFloatingTextField.setPlaceholderText(placeholderText: "Telefono")
      self.employeeEmailFloatingTextField.setPlaceholderText(placeholderText: "Email")
      self.addEmployeeWorkingHoursButton.layer.cornerRadius = 5.0
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
      
   }
   
   @IBAction func saveButtonPressed(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
}

extension NewEmployeeViewController: NewEmployeeViewControllerDelegate {
   
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
