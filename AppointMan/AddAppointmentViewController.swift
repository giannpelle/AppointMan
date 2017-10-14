//
//  AddAppointmentViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/16/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol AddAppointmentViewControllerDelegate {
   func hideOverlayView() -> Void
}

enum Employee: String {
   case Sara, Chiara, Francesca, Giovanni, Filippo, Ettore
}

class AddAppointmentViewController: UIViewController {
   
   var selectedData = (client: "", services: (serviceName: "", employees: [Employee](), duration: 0), notes: "")
   
   let clients = ["Alberto Rossi", "Carlo Verdde", "Francesco Rossi", "Giovanni Donato", "Giuseppe Verdde", "Luigi Rossi", "Antonio Donato", "Alessandro Rossi", "Monica Donato", "Emanuele Rossi", "Walter", "Lorenzo", "Constanza Verdde", "Gloria Donato", "Giulia Verdde", "Ottavio Donato", "Stefania Rossi", "Fabio Verdde", "Michelangelo Donato", "Edoardo Gruaro", "Ermenegildo Aureo", "Sara Nenson", "Lauro Costa", "Filippo Selvaggio", "Carmen Ferito", "Luisa Donati", "Carlotta Demeso", "Dora Prino", "Rosita Fessano", "Federica Manita"]
   let services = [(serviceName: "Shampoo", duration: 10, employees: Set<Employee>([.Sara, .Francesca, .Chiara])), (serviceName: "Taglio", duration: 45, employees: Set<Employee>([.Sara, .Francesca, .Chiara, .Filippo, .Ettore, .Giovanni])), (serviceName: "Barba", duration: 20, employees: Set<Employee>([.Giovanni, .Filippo, .Ettore]))]
   var suggestedTags: [String] = []
   
   @IBOutlet weak var backgroundView: UIView!
   @IBOutlet weak var verticalFieldsStackView: UIStackView!
   @IBOutlet weak var clientTagsTextField: TagsTextField!
   @IBOutlet weak var clientHorizontalStackView: UIStackView!
   @IBOutlet weak var clientTextField: SmartDeleteTextField!
   @IBOutlet weak var servicesTagsTextField: TagsTextField!
   @IBOutlet weak var servicesHorizontalStackView: UIStackView!
   @IBOutlet weak var servicesTextField: SmartDeleteTextField!
   @IBOutlet weak var notesUnderlinedTextField: UnderlinedTextField!
   
   
   var servicesDurationHorizontalStackView: UIStackView!
   var suggestionsCollectionView: UICollectionView!
   var delegate: AddAppointmentViewControllerDelegate?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
      self.clientTextField.onDeleteKeyPressed = self.onDeleteClosure(stackView: self.clientHorizontalStackView)
      self.servicesTextField.onDeleteKeyPressed = self.onDeleteClosure(stackView: self.servicesHorizontalStackView)
      
      
      self.servicesDurationHorizontalStackView = UIStackView(arrangedSubviews: [UIView()])
      self.servicesDurationHorizontalStackView.axis = .horizontal
      self.servicesDurationHorizontalStackView.distribution = .fill
      self.servicesDurationHorizontalStackView.alignment = .center
      self.servicesDurationHorizontalStackView.spacing = 8.0
      self.servicesDurationHorizontalStackView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
      self.servicesDurationHorizontalStackView.isHidden = true
      self.verticalFieldsStackView.insertArrangedSubview(self.servicesDurationHorizontalStackView, at: 2)
      
      
      let cancelAction = UIBarButtonItem(title: "Annulla", style: .plain, target: self, action: #selector(self.cancelBarButtonItemPressed(sender:)))
      self.navigationItem.leftBarButtonItem = cancelAction
      
      let doneAction = UIBarButtonItem(title: "Salva", style: .done, target: self, action: #selector(self.doneBarButtonItemPressed(sender:)))
      self.navigationItem.rightBarButtonItem = doneAction
      
      self.navigationItem.title = "Nuovo Appuntamento"
      self.navigationController?.navigationBar.barTintColor = UIColor.white
      self.navigationController?.navigationBar.isTranslucent = false
      
      self.backgroundView.layer.cornerRadius = 7.0
      self.backgroundView.layer.borderWidth = 0.5
      self.backgroundView.layer.borderColor = UIColor.orange.cgColor
      
      self.clientTextField.tag = 1
      self.clientTextField.delegate = self
      self.clientTextField.inputAssistantItem.leadingBarButtonGroups = []
      self.clientTextField.inputAssistantItem.trailingBarButtonGroups = []
      
      let suggestionsInputAccessoryView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 58.0))
      suggestionsInputAccessoryView.backgroundColor = UIColor(white: 20 / 255.0, alpha: 1.0)
      
      
      self.suggestionsCollectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 67.0), collectionViewLayout: UICollectionViewFlowLayout())
      self.suggestionsCollectionView.register(UINib(nibName: "SuggestionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "suggestionCellId")
      self.suggestionsCollectionView.backgroundColor = UIColor.clear
      self.suggestionsCollectionView.delegate = self
      self.suggestionsCollectionView.dataSource = self
      self.suggestionsCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: 0.0)
      
      let layout = self.suggestionsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
      layout.estimatedItemSize = CGSize(width: 200.0, height: self.suggestionsCollectionView.bounds.size.height)
      layout.minimumInteritemSpacing = 8.0
      layout.scrollDirection = .horizontal
      
//      let suggestionBtn = UIButton()
//      suggestionBtn.backgroundColor = UIColor(white: 90 / 255.0, alpha: 1.0)
//      suggestionBtn.setTitle("Alberto", for: .normal)
//      suggestionBtn.setTitleColor(UIColor.white, for: .normal)
//      suggestionBtn.titleEdgeInsets = UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
//      suggestionBtn.widthAnchor.constraint(equalToConstant: suggestionBtn.intrinsicContentSize.width + 24.0).isActive = true
//      suggestionBtn.sizeToFit()
//      suggestionBtn.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
//      suggestionBtn.layer.cornerRadius = 7
      suggestionsInputAccessoryView.addSubview(self.suggestionsCollectionView)
//      suggestionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
//      suggestionsCollectionView.leadingAnchor.constraint(equalTo: clientInputAccessoryView.leadingAnchor, constant: 0.0).isActive = true
//      suggestionsCollectionView.topAnchor.constraint(equalTo: clientInputAccessoryView.topAnchor, constant: 0.0).isActive = true
//      suggestionsCollectionView.trailingAnchor.constraint(equalTo: clientInputAccessoryView.trailingAnchor, constant: 0.0).isActive = true
//      suggestionsCollectionView.bottomAnchor.constraint(equalTo: clientInputAccessoryView.bottomAnchor, constant: 0.0).isActive = true
      clientTextField.inputAccessoryView = suggestionsInputAccessoryView
      
      self.servicesTextField.tag = 2
      self.servicesTextField.inputAssistantItem.leadingBarButtonGroups = []
      self.servicesTextField.inputAssistantItem.trailingBarButtonGroups = []
      self.servicesTextField.delegate = self
      
      servicesTextField.inputAccessoryView = suggestionsInputAccessoryView
      
      
      self.notesUnderlinedTextField.inputAssistantItem.leadingBarButtonGroups = []
      self.notesUnderlinedTextField.inputAssistantItem.trailingBarButtonGroups = []
      
      self.notesUnderlinedTextField.delegate = self
      
   }
   
   func onDeleteClosure(stackView: UIStackView) -> (() -> Void)? {
      
      return {
         if (stackView.last() as! SmartDeleteTextField).text == "" && stackView.arrangedSubviews.count > 1 {
            stackView.removeLast()
            self.selectedData.client = ""
         }
      }
   }
   
   func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
      self.delegate?.hideOverlayView()
      self.dismiss(animated: false, completion: nil)
   }
   
   func doneBarButtonItemPressed(sender: UIBarButtonItem) {
      
      print(self.selectedData)
      
      self.delegate?.hideOverlayView()
      self.dismiss(animated: false, completion: nil)

   }
   
//   func subviewsOfView(view: UIView, withType type: String) -> [UIView] {
//      let prefix = NSString(format: "<%@", type)
//      var subviewArray = [UIView]()
//      for subview in view.subviews {
//         let tempArr = self.subviewsOfView(view: subview, withType: type)
//         for view in tempArr {
//            subviewArray.append(view)
//         }
//      }
//      if view.description.hasPrefix(prefix as String) {
//         subviewArray.append(view)
//      }
//      
//      return subviewArray
//   }
//   
//   func addColorToUIKeyboardButton() {
//      for keyboardWindow in UIApplication.shared.windows {
//         for keyboard in keyboardWindow.subviews {
//            for view in self.subviewsOfView(view: keyboard, withType: "UIKBKeyplaneView") {
//               let newView = UIView(frame: (self.subviewsOfView(view: keyboard, withType: "UIKBKeyView").last?.frame)!)
//               newView.frame = CGRect(x: newView.frame.origin.x + 2, y: newView.frame.origin.y + 1, width: newView.frame.size.width - 4, height: newView.frame.size.height - 3)
//               newView.backgroundColor = UIColor.green
//               newView.layer.cornerRadius = 4
//               view.insertSubview(newView, belowSubview: self.subviewsOfView(view: keyboard, withType: "UIKBKeyView").last!)
//               
//            }
//         }
//      }
//   }
   
}

extension AddAppointmentViewController: UITextFieldDelegate {
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      
      switch textField.tag {
      case 1:
         self.servicesTextField.becomeFirstResponder()
         self.selectedData.client = textField.text!
         self.suggestedTags = []
         self.suggestionsCollectionView.reloadData()
         self.suggestionsCollectionView.collectionViewLayout.invalidateLayout()
      case 2:
         self.notesUnderlinedTextField.becomeFirstResponder()
         self.suggestedTags = []
         self.suggestionsCollectionView.reloadData()
         self.suggestionsCollectionView.collectionViewLayout.invalidateLayout()
      case 3:
         self.selectedData.notes = textField.text!
      default:
         break
      }
      
      return true
   }
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      
      guard 1...2 ~= textField.tag  else {
         return
      }
      self.suggestedTags = []
      self.suggestionsCollectionView.reloadData()
      self.suggestionsCollectionView.collectionViewLayout.invalidateLayout()
   }
   
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
      
      var tags: [String] = []
      
      switch textField.tag {
      case 1:
         //if let text = textField.text {
            for client in self.clients {
               if client.lowercased().contains(newString.lowercased()) {
                  tags.append(client)
               }
            }
         //}
      case 2:
         //if let text = textField.text {
            for service in self.services {
               if service.serviceName.lowercased().contains(newString.lowercased()) {
                  tags.append(service.serviceName)
               }
            }
         //}
      default:
         return true
      }
      
      self.suggestedTags = tags
      self.suggestionsCollectionView.reloadData()
      self.suggestionsCollectionView.collectionViewLayout.invalidateLayout()
      
      return true
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      
      guard textField.tag == 2 else { return }
      
      // CAN ALSO BE PUT HERE
      
   }
}

extension AddAppointmentViewController: SuggestionCollectionViewCellDelegate {
   
   func insertNewTag(withName name: String) {
      
      if self.servicesTextField.isEditing {
         let tagButton = UIButton(type: .custom)
         tagButton.backgroundColor = UIColor.amBlue
         tagButton.layer.cornerRadius = 4.0
         tagButton.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
         tagButton.setTitle(name, for: .normal)
         tagButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 6.0, bottom: 4.0, right: 6.0)
         self.servicesHorizontalStackView.insertArrangedSubview(tagButton, at: self.servicesHorizontalStackView.arrangedSubviews.count - 1)
         self.selectedData.services = (serviceName: name, employees: [.Chiara], duration: 40)
         self.servicesTextField.text = ""
         
         
         // ALL THE WAY LONG CAN ALSO BE PUT INSIDE THE ETXTFIELD DIDENDEDITING DELEGATE METHOD
         if self.servicesHorizontalStackView.arrangedSubviews.count == 1 {
            self.servicesDurationHorizontalStackView.isHidden = true
            for view in self.servicesDurationHorizontalStackView.arrangedSubviews {
               self.servicesDurationHorizontalStackView.removeArrangedSubview(view)
               view.removeFromSuperview()
            }
         } else if self.servicesHorizontalStackView.arrangedSubviews.count != self.servicesDurationHorizontalStackView.arrangedSubviews.count {
            for _ in 0...(self.servicesHorizontalStackView.arrangedSubviews.count - self.servicesDurationHorizontalStackView.arrangedSubviews.count - 1) {
               let durationButton = UIButton(type: .custom)
               durationButton.setTitle("40 min", for: .normal)
               durationButton.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
               durationButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 12.0, bottom: 6.0, right: 12.0)
               durationButton.backgroundColor = UIColor.white
               durationButton.layer.cornerRadius = 6.0
               durationButton.layer.borderColor = UIColor.amBlue.cgColor
               durationButton.layer.borderWidth = 1.0
               durationButton.setTitleColor(UIColor.amBlue, for: .normal)
               self.servicesDurationHorizontalStackView.insertArrangedSubview(durationButton, at: 0)
            }
            UIView.animate(withDuration: 0.4, animations: {
               self.servicesDurationHorizontalStackView.isHidden = false
            })
         }
         
      }
      
      if self.clientTextField.isEditing {
         let tagButton = UIButton(type: .custom)
         tagButton.backgroundColor = UIColor.amBlue
         tagButton.layer.cornerRadius = 4.0
         tagButton.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
         tagButton.setTitle(name, for: .normal)
         tagButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 6.0, bottom: 4.0, right: 6.0)
         self.clientHorizontalStackView.insertArrangedSubview(tagButton, at: self.clientHorizontalStackView.arrangedSubviews.count - 1)
         self.clientTextField.text = ""
         self.selectedData.client = name
         //self.clientTextField.placeholder = ""
         self.clientTextField.resignFirstResponder()
         self.servicesTextField.becomeFirstResponder()
         
      }
      
   }
}

extension AddAppointmentViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
      return self.suggestedTags.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCellId", for: indexPath) as! SuggestionCollectionViewCell
      cell.suggestionButton.setTitle(self.suggestedTags[indexPath.row], for: .normal)
      cell.delegate = self
      return cell
   }
   
}

extension AddAppointmentViewController: UICollectionViewDelegate {
   
}


