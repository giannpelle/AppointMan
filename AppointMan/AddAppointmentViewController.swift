//
//  AddAppointmentViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/21/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit
import TagsTextField

class AddAppointmentViewController: UIViewController {
   
   let suggestionElements: [SuggestionElement] = [SuggestionElement(text: "Giovanni Verdde", id: "0"), SuggestionElement(text: "Francesco Verdde", id: "0"), SuggestionElement(text: "Luca Verdde", id: "0"), SuggestionElement(text: "Fernando Verdde", id: "0"), SuggestionElement(text: "Dario Verdde", id: "0"), SuggestionElement(text: "Stefano Verdde", id: "0"), SuggestionElement(text: "Edoardo Verdde", id: "0"), SuggestionElement(text: "Alberto Verdde", id: "0"), SuggestionElement(text: "Marco Verdde", id: "0"), SuggestionElement(text: "Pietro Verdde", id: "0"), SuggestionElement(text: "Nicola Verdde", id: "0")]
   
   @IBOutlet weak var customersTagsTextField: TagsTextField!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.customersTagsTextField.dataSource = self
      self.customersTagsTextField.delegate = self
      self.customersTagsTextField.setup(withAttributedPlaceholderText: UILabel.attributedString(withText: "Nome cliente", andTextColor: UIColor.grayWith(value: 152.0), andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: 0.0))
      //self.customersTagsTextField.setup(withAttributedPlaceholderText: UILabel.att)
      
   }
   
   @IBAction func closeButtonPressed(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
}

extension AddAppointmentViewController: TagsTextFieldDataSource {
   
   func tagsTextField(_ tagsTextField: TagsTextField, numberOfItemsForCurrentInputText inputText: String) -> Int {
      return self.suggestionElements.count
   }
   
   func tagsTextField(_ tagsTextField: TagsTextField, suggestionElementForItemAt index: Int, forCurrentInputText inputText: String) -> SuggestionElement {
      return self.suggestionElements[index]
   }
}

extension AddAppointmentViewController: TagsTextFieldDelegate {
   
   func tagsTextField(_ tagsTextField: TagsTextField, didAddTag tag: TagButton, withSuggestionElement suggestionElement: SuggestionElement) {
      
   }

   func tagsTextField(_ tagsTextField: TagsTextField, didRemoveTag tag: TagButton, withSuggestionElement suggestionElement: SuggestionElement) {
      
   }

   func tagsTextField(_ tagsTextField: TagsTextField, didSelectTag tag: TagButton, withSuggestionElement suggestionElement: SuggestionElement) {
      
   }

   func tagsTextField(_ tagsTextField: TagsTextField, didDeselectTag tag: TagButton, withSuggestionElement suggestionElement: SuggestionElement) {
      
   }
}
