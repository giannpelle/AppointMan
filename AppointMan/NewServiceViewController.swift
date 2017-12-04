//
//  NewServiceViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/10/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit
import CoreData

protocol NewServiceViewControllerDelegate: class {
   func didUpdateServices()
}

class NewServiceViewController: UIViewController {
   
   @IBOutlet weak var newServiceLabel: UILabel!
   @IBOutlet weak var serviceColorButton: UIButton!
   @IBOutlet weak var serviceNameTextField: GPFloatingTextField!
   @IBOutlet weak var durationLabel: UILabel!
   @IBOutlet weak var manBoxView: UIView!
   @IBOutlet weak var manLabel: UILabel!
   @IBOutlet weak var manCheckboxButton: UIButton!
   @IBOutlet weak var manDurationPickerView: UIPickerView!
   @IBOutlet weak var womanBoxView: UIView!
   @IBOutlet weak var womanLabel: UILabel!
   @IBOutlet weak var womanCheckboxButton: UIButton!
   @IBOutlet weak var womanDurationPickerView: UIPickerView!
   @IBOutlet weak var saveButton: UIButton!
   
   var coreDataStack: CoreDataStack!
   var serviceColor: ServiceColor = ServiceColor()
   weak var delegate: NewServiceViewControllerDelegate?
   
   var isOverridingManService: Bool = false
   var isOverridingWomanService: Bool = false
   
   lazy var colorPickerView: ColorPickerView? = {
      guard let colorPickerView = Bundle.main.loadNibNamed("ColorPickerView", owner: nil, options: nil)?.first as? ColorPickerView else {
         return nil
      }
      
      return colorPickerView
   }()
   
   var services: [Service]?
   
   var isManBoxEnabled: Bool = false {
      didSet {
         self.manCheckboxButton.isSelected = self.isManBoxEnabled
         self.manLabel.attributedText = UILabel.attributedString(withText: "UOMO", andTextColor: self.isManBoxEnabled ? UIColor.amBlue : UIColor.grayWith(value: 214), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
         self.manLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
         self.manDurationPickerView.isUserInteractionEnabled = self.isManBoxEnabled
         self.manDurationPickerView.reloadAllComponents()
      }
   }
   
   var isWomanBoxEnabled: Bool = false {
      didSet {
         self.womanCheckboxButton.isSelected = self.isWomanBoxEnabled
         self.womanLabel.attributedText = UILabel.attributedString(withText: "DONNA", andTextColor: self.isWomanBoxEnabled ? UIColor.amBlue : UIColor.grayWith(value: 214), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
         self.womanLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
         self.womanDurationPickerView.isUserInteractionEnabled = self.isWomanBoxEnabled
         self.womanDurationPickerView.reloadAllComponents()
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
      self.loadServicesData()
   }
   
   func applyTypography() {
      self.newServiceLabel.attributedText = UILabel.attributedString(withText: "NUOVO SERVIZIO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.newServiceLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
      
      self.durationLabel.attributedText = UILabel.attributedString(withText: "DURATA", andTextColor: UIColor.amOpaqueBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.durationLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
      
      self.manLabel.attributedText = UILabel.attributedString(withText: "UOMO", andTextColor: UIColor.grayWith(value: 214), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.manLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
      
      self.womanLabel.attributedText = UILabel.attributedString(withText: "DONNA", andTextColor: UIColor.grayWith(value: 214), andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.86)
      self.womanLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
      
      self.saveButton.setAttributedTitle(UILabel.attributedString(withText: "SALVA", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 16.0)!, andCharacterSpacing: 1.14, isCentered: true), for: .normal)
   }
   
   func setupUI() {
      self.serviceColorButton.backgroundColor = self.serviceColor.getColor()
      self.serviceColorButton.layer.cornerRadius = self.serviceColorButton.bounds.size.height / 2.0
      self.serviceColorButton.addTarget(self, action: #selector(self.openColorPicker(sender:)), for: .touchUpInside)

      self.serviceNameTextField.setPlaceholderText(placeholderText: "Nome servizio")
      self.serviceNameTextField.delegate = self
      
      let manTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.manBoxViewTapped(sender:)))
      self.manBoxView.addGestureRecognizer(manTapGesture)
      
      let womanTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.womanBoxViewTapped(sender:)))
      self.womanBoxView.addGestureRecognizer(womanTapGesture)
      
      self.manBoxView.layer.cornerRadius = 5.0
      self.manBoxView.layer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      self.manBoxView.layer.shadowOpacity = 0.25
      self.manBoxView.layer.shadowRadius = 6.0
      self.manBoxView.layer.shadowOffset = .zero
      
      self.womanBoxView.layer.cornerRadius = 5.0
      self.womanBoxView.layer.shadowColor = UIColor(red: 116/255.0, green: 141/255.0, blue: 176/255.0, alpha: 1.0).cgColor
      self.womanBoxView.layer.shadowOpacity = 0.25
      self.womanBoxView.layer.shadowRadius = 6.0
      self.womanBoxView.layer.shadowOffset = .zero
      
      self.manCheckboxButton.layer.cornerRadius = self.manCheckboxButton.bounds.size.width / 2.0
      self.manCheckboxButton.setImage(#imageLiteral(resourceName: "uncheck_24"), for: .normal)
      self.manCheckboxButton.setImage(#imageLiteral(resourceName: "check_24"), for: .selected)
      
      self.womanCheckboxButton.layer.cornerRadius = self.womanCheckboxButton.bounds.size.width / 2.0
      self.womanCheckboxButton.setImage(#imageLiteral(resourceName: "uncheck_24"), for: .normal)
      self.womanCheckboxButton.setImage(#imageLiteral(resourceName: "check_24"), for: .selected)
      
      let manSeparatorLineLayer = CALayer()
      manSeparatorLineLayer.frame = CGRect(x: 0.0, y: 40.0, width: self.manBoxView.bounds.size.width, height: 1.0)
      manSeparatorLineLayer.backgroundColor = UIColor.grayWith(value: 188).cgColor
      self.manBoxView.layer.insertSublayer(manSeparatorLineLayer, at: 0)
      
      let womanSeparatorLineLayer = CALayer()
      womanSeparatorLineLayer.frame = CGRect(x: 0.0, y: 40.0, width: self.womanBoxView.bounds.size.width, height: 1.0)
      womanSeparatorLineLayer.backgroundColor = UIColor.grayWith(value: 188).cgColor
      self.womanBoxView.layer.insertSublayer(womanSeparatorLineLayer, at: 0)
      
      self.manDurationPickerView.tag = 0
      self.manDurationPickerView.isUserInteractionEnabled = false
      self.manDurationPickerView.dataSource = self
      self.manDurationPickerView.delegate = self
      self.manDurationPickerView.selectRow(6, inComponent: 2, animated: false)
      
      self.womanDurationPickerView.tag = 1
      self.womanDurationPickerView.isUserInteractionEnabled = false
      self.womanDurationPickerView.dataSource = self
      self.womanDurationPickerView.delegate = self
      self.womanDurationPickerView.selectRow(6, inComponent: 2, animated: false)
      
      self.saveButton.layer.cornerRadius = 3.0
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      self.closeColorPickerView()
      self.view.endEditing(true)
   }
   
   func loadServicesData() {
      if let firstService = services?.first, let serviceName = firstService.name, let serviceColor = ServiceColor(rawValue: Int(firstService.color)) {
         self.serviceColorButton.backgroundColor = serviceColor.getColor()
         self.serviceColor = serviceColor
         self.serviceNameTextField.text = serviceName
         if firstService.gender == Int16(Gender.male.rawValue) {
            self.isManBoxEnabled = true
            let duration = Int(firstService.duration)
            let hourIndex = duration / 60
            let minIndex = (duration - (hourIndex * 60)) / 5
            self.manDurationPickerView.selectRow(hourIndex, inComponent: 0, animated: false)
            self.manDurationPickerView.selectRow(minIndex, inComponent: 2, animated: false)
         } else {
            self.isWomanBoxEnabled = true
            let duration = Int(firstService.duration)
            let hourIndex = duration / 60
            let minIndex = (duration - (hourIndex * 60)) / 5
            self.womanDurationPickerView.selectRow(hourIndex, inComponent: 0, animated: false)
            self.womanDurationPickerView.selectRow(minIndex, inComponent: 2, animated: false)
         }
      }
      if let secondService = services?.last {
         if secondService.gender == Int16(Gender.male.rawValue) {
            self.isManBoxEnabled = true
            let duration = Int(secondService.duration)
            let hourIndex = duration / 60
            let minIndex = (duration - (hourIndex * 60)) / 5
            self.manDurationPickerView.selectRow(hourIndex, inComponent: 0, animated: false)
            self.manDurationPickerView.selectRow(minIndex, inComponent: 2, animated: false)
         } else {
            self.isWomanBoxEnabled = true
            let duration = Int(secondService.duration)
            let hourIndex = duration / 60
            let minIndex = (duration - (hourIndex * 60)) / 5
            self.womanDurationPickerView.selectRow(hourIndex, inComponent: 0, animated: false)
            self.womanDurationPickerView.selectRow(minIndex, inComponent: 2, animated: false)
         }
      }
   }
   
   @IBAction func closeButtonPressed(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
   @objc func openColorPicker(sender: UIButton) {
      if let colorPickerView = self.colorPickerView {
         colorPickerView.delegate = self
         colorPickerView.alpha = 0.0
         
         self.view.addSubview(colorPickerView)
         colorPickerView.translatesAutoresizingMaskIntoConstraints = false
         colorPickerView.topAnchor.constraint(equalTo: self.serviceColorButton.bottomAnchor, constant: 6.0).isActive = true
         colorPickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0).isActive = true
         colorPickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
         
         UIView.animate(withDuration: 0.5) {
            colorPickerView.alpha = 1.0
         }
      }
   }
   
   func closeColorPickerView() {
      for view in self.view.subviews {
         if let colorPickerView = view as? ColorPickerView {
            UIView.animate(withDuration: 0.5, animations: {
               colorPickerView.alpha = 0.0
            }, completion: { (success) in
               if success {
                  colorPickerView.removeFromSuperview()
               }
            })
         }
      }
   }
   
   @objc func manBoxViewTapped(sender: UITapGestureRecognizer) {
      guard self.isManBoxEnabled == false else {
         return
      }
      
      self.isManBoxEnabled = true
   }
   
   @objc func womanBoxViewTapped(sender: UITapGestureRecognizer) {
      guard self.isWomanBoxEnabled == false else {
         return
      }
      
      self.isWomanBoxEnabled = true
   }
   
   @IBAction func manCheckboxButtonPressed(sender: UIButton) {
      self.isManBoxEnabled = !self.isManBoxEnabled
   }
   
   @IBAction func womanCheckboxButtonPressed(sender: UIButton) {
      self.isWomanBoxEnabled = !self.isWomanBoxEnabled
   }
   
   @IBAction func saveButtonPressed(sender: UIButton) {
      if let serviceName = self.serviceNameTextField.text, !serviceName.isEmpty {
         if self.isManBoxEnabled || self.isWomanBoxEnabled {
            
            let fetchRequest = NSFetchRequest<Service>(entityName: "Service")
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Service.name), serviceName)
            var currentServices: [Service] = []
            if let services = try? self.coreDataStack.managedContext.fetch(fetchRequest), services.count > 0 {
               currentServices = services
            }
            
            if (currentServices.filter { $0.gender == Int16(Gender.male.rawValue) }).count > 0 && self.isManBoxEnabled || (currentServices.filter { $0.gender == Int16(Gender.female.rawValue) }).count > 0 && self.isWomanBoxEnabled {
               self.isOverridingManService = (currentServices.filter { $0.gender == Int16(Gender.male.rawValue) }).count > 0 && self.isManBoxEnabled
               self.isOverridingWomanService = (currentServices.filter { $0.gender == Int16(Gender.female.rawValue) }).count > 0 && self.isWomanBoxEnabled
               
               if let areYouSurePopupView = UINib(nibName: "AreYouSurePopupView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? AreYouSurePopupView {
                  areYouSurePopupView.alpha = 0.0
                  areYouSurePopupView.setupPopupMessage(withTitle: "ATTENZIONE", andMessage: "Hai già inserito un servizio con questo nome, vuoi sovrascrivere i dati del serivizio?", andConfirmText: "CONFERMA")
                  areYouSurePopupView.onConfirmButtonPressed = self.overrideService
                  self.view.addSubview(areYouSurePopupView)
                  areYouSurePopupView.translatesAutoresizingMaskIntoConstraints = false
                  areYouSurePopupView.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
                  areYouSurePopupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                  areYouSurePopupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                  
                  UIView.animate(withDuration: 0.4, animations: {
                     areYouSurePopupView.alpha = 1.0
                  })
               }
            } else {
               self.saveNewService()
            }
            
         } else {
            //POPUP -> "Devi specificare a chi è rivolto questo servizio"
            if let okPopupView = UINib(nibName: "OkPopupView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? OkPopupView {
               okPopupView.alpha = 0.0
               okPopupView.setupPopupMessage(withTitle: "ATTENZIONE", andMessage: "Devi specificare a chi è rivolto il servizio per poterlo inserire")
               self.view.addSubview(okPopupView)
               okPopupView.translatesAutoresizingMaskIntoConstraints = false
               okPopupView.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
               okPopupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
               okPopupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
               UIView.animate(withDuration: 0.4, animations: {
                  okPopupView.alpha = 1.0
               })
            }
         }
      } else {
         //POPUP custom -> "Devi inserire il nome del servizio per poterlo salvare"
         if let okPopupView = UINib(nibName: "OkPopupView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? OkPopupView {
            okPopupView.alpha = 0.0
            okPopupView.setupPopupMessage(withTitle: "ATTENZIONE", andMessage: "Devi specificare il nome del servizio per poterlo aggiungere")
            self.view.addSubview(okPopupView)
            okPopupView.translatesAutoresizingMaskIntoConstraints = false
            okPopupView.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
            okPopupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            okPopupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            UIView.animate(withDuration: 0.4, animations: {
               okPopupView.alpha = 1.0
            })
         }
      }
   }
   
   func saveNewService() {
      if let serviceName = self.serviceNameTextField.text, !serviceName.isEmpty {
         if self.isManBoxEnabled {
            
            let manService = NSEntityDescription.insertNewObject(forEntityName: "Service", into: self.coreDataStack.managedContext) as! Service
            manService.name = serviceName
            manService.color = Int16(self.serviceColor.rawValue)
            manService.gender = Int16(Gender.male.rawValue)
            manService.duration = Int16(self.getDuration(fromFirstComponent: self.manDurationPickerView.selectedRow(inComponent: 0), andSecondComponent: self.manDurationPickerView.selectedRow(inComponent: 2)))
            
            do {
               try self.coreDataStack.saveContext()
            } catch let error as NSError {
               print(error.localizedDescription)
               //POPUP "Si è verificato un errore durante il salvataggio del servizio, riprovare"
               return
            }
            
            let batchUpdate = NSBatchUpdateRequest(entityName: "Service")
            batchUpdate.predicate = NSPredicate(format: "%K == %@", #keyPath(Service.name), serviceName)
            batchUpdate.propertiesToUpdate = [#keyPath(Service.color): Int16(self.serviceColor.rawValue)]
            batchUpdate.affectedStores = self.coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores
            batchUpdate.resultType = .updatedObjectIDsResultType
            if let batchResult = try? self.coreDataStack.managedContext.execute(batchUpdate), let result = (batchResult as? NSBatchUpdateResult)?.result as? [NSManagedObjectID] {
               let changes = [NSUpdatedObjectsKey : result]
               NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.coreDataStack.managedContext])
               print("\(result) records updated")
            }
            
            self.delegate?.didUpdateServices()
            self.dismiss(animated: true, completion: nil)
         }
         
         if self.isWomanBoxEnabled {
            
            let womanService = NSEntityDescription.insertNewObject(forEntityName: "Service", into: self.coreDataStack.managedContext) as! Service
            womanService.name = serviceName
            womanService.color = Int16(self.serviceColor.rawValue)
            womanService.gender = Int16(Gender.female.rawValue)
            womanService.duration = Int16(self.getDuration(fromFirstComponent: self.womanDurationPickerView.selectedRow(inComponent: 0), andSecondComponent: self.womanDurationPickerView.selectedRow(inComponent: 2)))
            
            do {
               try self.coreDataStack.saveContext()
            } catch let error as NSError {
               print(error.localizedDescription)
               //POPUP "Si è verificato un errore durante il salvataggio del servizio, riprovare"
               return
            }
            
            let batchUpdate = NSBatchUpdateRequest(entityName: "Service")
            batchUpdate.predicate = NSPredicate(format: "%K == %@", #keyPath(Service.name), serviceName)
            batchUpdate.propertiesToUpdate = [#keyPath(Service.color): Int16(self.serviceColor.rawValue)]
            batchUpdate.affectedStores = self.coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores
            batchUpdate.resultType = .updatedObjectIDsResultType
            if let batchResult = try? self.coreDataStack.managedContext.execute(batchUpdate), let result = (batchResult as? NSBatchUpdateResult)?.result as? [NSManagedObjectID] {
               let changes = [NSUpdatedObjectsKey : result]
               NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.coreDataStack.managedContext])
               print("\(result) records updated")
            }
            
            self.delegate?.didUpdateServices()
            self.dismiss(animated: true, completion: nil)
         }
      }
   }
   
   func overrideService() {
      if let serviceName = self.serviceNameTextField.text, !serviceName.isEmpty {
         if self.isManBoxEnabled {
            if self.isOverridingManService {
               let batchUpdate = NSBatchUpdateRequest(entityName: "Service")
               batchUpdate.predicate = NSPredicate(format: "%K == %@", #keyPath(Service.name), serviceName)
               batchUpdate.propertiesToUpdate = [#keyPath(Service.color): Int16(self.serviceColor.rawValue), #keyPath(Service.duration): Int16(self.getDuration(fromFirstComponent: self.manDurationPickerView.selectedRow(inComponent: 0), andSecondComponent: self.manDurationPickerView.selectedRow(inComponent: 2)))]
               batchUpdate.affectedStores = self.coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores
               batchUpdate.resultType = .updatedObjectIDsResultType
               if let batchResult = try? self.coreDataStack.managedContext.execute(batchUpdate), let result = (batchResult as? NSBatchUpdateResult)?.result as? [NSManagedObjectID] {
                  let changes = [NSUpdatedObjectsKey : result]
                  NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.coreDataStack.managedContext])
                  print("\(result) records updated")
               }
            } else {
               let manService = NSEntityDescription.insertNewObject(forEntityName: "Service", into: self.coreDataStack.managedContext) as! Service
               manService.name = serviceName
               manService.color = Int16(self.serviceColor.rawValue)
               manService.gender = Int16(Gender.male.rawValue)
               manService.duration = Int16(self.getDuration(fromFirstComponent: self.manDurationPickerView.selectedRow(inComponent: 0), andSecondComponent: self.manDurationPickerView.selectedRow(inComponent: 2)))
               
               do {
                  try self.coreDataStack.saveContext()
               } catch let error as NSError {
                  print(error.localizedDescription)
                  //POPUP "Si è verificato un errore durante il salvataggio del servizio, riprovare"
                  return
               }
            }
            
            self.delegate?.didUpdateServices()
            self.dismiss(animated: true, completion: nil)
         }
         
         if self.isWomanBoxEnabled {
            if self.isOverridingWomanService {
               let batchUpdate = NSBatchUpdateRequest(entityName: "Service")
               batchUpdate.predicate = NSPredicate(format: "%K == %@", #keyPath(Service.name), serviceName)
               batchUpdate.propertiesToUpdate = [#keyPath(Service.color): Int16(self.serviceColor.rawValue), #keyPath(Service.duration): Int16(self.getDuration(fromFirstComponent: self.manDurationPickerView.selectedRow(inComponent: 0), andSecondComponent: self.manDurationPickerView.selectedRow(inComponent: 2)))]
               batchUpdate.affectedStores = self.coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores
               batchUpdate.resultType = .updatedObjectIDsResultType
               if let batchResult = try? self.coreDataStack.managedContext.execute(batchUpdate), let result = (batchResult as? NSBatchUpdateResult)?.result as? [NSManagedObjectID] {
                  let changes = [NSUpdatedObjectsKey : result]
                  NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.coreDataStack.managedContext])
                  print("\(result) records updated")
               }
             } else {
               let womanService = NSEntityDescription.insertNewObject(forEntityName: "Service", into: self.coreDataStack.managedContext) as! Service
               womanService.name = serviceName
               womanService.color = Int16(self.serviceColor.rawValue)
               womanService.gender = Int16(Gender.female.rawValue)
               womanService.duration = Int16(self.getDuration(fromFirstComponent: self.womanDurationPickerView.selectedRow(inComponent: 0), andSecondComponent: self.womanDurationPickerView.selectedRow(inComponent: 2)))
               
               do {
                  try self.coreDataStack.saveContext()
               } catch let error as NSError {
                  print(error.localizedDescription)
                  //POPUP "Si è verificato un errore durante il salvataggio del servizio, riprovare"
                  return
               }
            }
            self.delegate?.didUpdateServices()
            self.dismiss(animated: true, completion: nil)
         }
      }
   }
   
   func getDuration(fromFirstComponent firstComponent: Int, andSecondComponent secondComponent: Int) -> Int {
      return firstComponent * 60 + secondComponent * 5
   }
   
}

extension NewServiceViewController: ColorPickerViewDelegate {
   
   func didSelect(serviceColor: ServiceColor) {
      self.serviceColor = serviceColor
      self.serviceColorButton.backgroundColor = serviceColor.getColor()
   }
}

extension NewServiceViewController: UIGestureRecognizerDelegate {
   
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
   }
}

extension NewServiceViewController: UIPickerViewDataSource {
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 4
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch component {
      case 0:
         return 15
      case 1:
         return 1
      case 2:
         return 12
      case 3:
         return 1
      default:
         return 0
      }
   }
   
   func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return 30.0
   }
   
   func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
      switch component {
      case 1, 3:
         return 48.0
      default:
         return 40.0
      }
   }
   
   func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
      if pickerView.tag == 0 {
         if component == 1 { return NSAttributedString(string: "h", attributes: [NSAttributedStringKey.foregroundColor : self.isManBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)]) }
         if component == 3 { return NSAttributedString(string: "min", attributes: [NSAttributedStringKey.foregroundColor : self.isManBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)]) }
         return NSAttributedString(string: "\(component == 0 ? row : row * 5)", attributes: [NSAttributedStringKey.foregroundColor : self.isManBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)])
      } else {
         if component == 1 { return NSAttributedString(string: "h", attributes: [NSAttributedStringKey.foregroundColor : self.isWomanBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)]) }
         if component == 3 { return NSAttributedString(string: "min", attributes: [NSAttributedStringKey.foregroundColor : self.isWomanBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)]) }
         return NSAttributedString(string: "\(component == 0 ? row : row * 5)", attributes: [NSAttributedStringKey.foregroundColor : self.isWomanBoxEnabled ? UIColor.black : UIColor.grayWith(value: 182)])
      }
   }

}

extension NewServiceViewController: UIPickerViewDelegate {
   
}

extension NewServiceViewController: UITextFieldDelegate {
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return false
   }
}
