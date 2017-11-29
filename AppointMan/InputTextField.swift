//
//  InputTextField.swift
//  TagTextField
//
//  Created by Gianluigi Pelle on 6/15/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol InputTextFieldDataSource {
   func inputTextField(_ inputTextField: InputTextField, numberOfItemsForCurrentInputText inputText: String) -> Int
   func inputTextField(_ inputTextField: InputTextField, titleForItemAt index: Int, forCurrentInputText inputText: String) -> String
   func insertNewTag(withName name: String, shouldClearInputTextField: Bool) -> Void
}

class InputTextField: UITextField {
   
   var suggestionsCollectionView: UICollectionView!
   
   var onDidPressDeleteKey: (() -> Bool)?
   var onDidResignFirstResponder: (() -> Void)?
   var dataSource: InputTextFieldDataSource?
   var newInputText: String?
   var tagKeyboardAppearance: UIKeyboardAppearance = .default {
      didSet {
         self.keyboardAppearance = self.tagKeyboardAppearance
      }
   }
   var currentCollectionViewContentSize: CGFloat {
      get {
         var count: CGFloat = 8.0
         if let text = self.text {
            if let numberOfElements = self.dataSource?.inputTextField(self, numberOfItemsForCurrentInputText: text) {
               for index in 0..<numberOfElements {
                  let button = UIButton(type: .custom)
                  button.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
                  button.setTitle(self.dataSource?.inputTextField(self, titleForItemAt: index, forCurrentInputText: text), for: .normal)
                  button.heightAnchor.constraint(equalToConstant: 49.0).isActive = true
                  count += (button.intrinsicContentSize.width + 8.0)
               }
            }
         }
         return count
      }
   }
   
   init() {
      super.init(frame: CGRect.zero)
      
      self.setup()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      self.setup()
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      self.setup()
   }
   
   // I think it isn't necessary
//   override func didMoveToSuperview() {
//      self.setup()
//   }
   
   func setup() {
      
      self.keyboardAppearance = self.tagKeyboardAppearance
      self.borderStyle = .none
      self.autocorrectionType = .no
      self.spellCheckingType = .no
      self.backgroundColor = UIColor.clear
      self.inputAssistantItem.leadingBarButtonGroups = []
      self.inputAssistantItem.trailingBarButtonGroups = []
      
   }
   
   // To setup the suggestions collection view over the keyboard
   func setupSuggestionsCollectionView() {
      
      let suggestionsInputAccessoryView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 58.0))
      suggestionsInputAccessoryView.backgroundColor = self.tagKeyboardAppearance == .dark ? UIColor(red: 23/255.0, green: 24/255.0, blue: 25/255.0, alpha: 1.0) : UIColor(red: 208/255.0, green: 213/255.0, blue: 220/255.0, alpha: 1.0)
      
      self.suggestionsCollectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 67.0), collectionViewLayout: UICollectionViewFlowLayout())
      self.suggestionsCollectionView.register(UINib(nibName: "SuggestionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "suggestionCellId")
      self.suggestionsCollectionView.backgroundColor = UIColor.clear
      self.suggestionsCollectionView.delegate = self
      self.suggestionsCollectionView.dataSource = self
      // FIXME: collection view cells going out of bounds on the trailing corner
//      self.suggestionsCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
      
      let layout = self.suggestionsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
      //layout.estimatedItemSize = CGSize(width: 50.0, height: self.suggestionsCollectionView.bounds.size.height)
      layout.minimumInteritemSpacing = 8.0
      layout.scrollDirection = .horizontal
      suggestionsInputAccessoryView.addSubview(self.suggestionsCollectionView)
      
      self.inputAccessoryView = suggestionsInputAccessoryView
   }
   
   
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
      // Drawing code
   }
   
   override func deleteBackward() {
      if let onDidPressDeleteKey = self.onDidPressDeleteKey {
         if onDidPressDeleteKey() {
            super.deleteBackward()
         } else {
            // nothing
         }
      }
   }
   
   @discardableResult override func resignFirstResponder() -> Bool {
      super.resignFirstResponder()
      if let onDidResignFirstResponder = self.onDidResignFirstResponder {
         onDidResignFirstResponder()
      }
      return true
   }
   
   override func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: TagsTextFieldConsts.inputTextFieldTextInsets.left, dy: TagsTextFieldConsts.inputTextFieldTextInsets.top)
   }
   
   override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: TagsTextFieldConsts.inputTextFieldTextInsets.left, dy: TagsTextFieldConsts.inputTextFieldTextInsets.top)
   }
   
   override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: TagsTextFieldConsts.inputTextFieldTextInsets.left, dy: TagsTextFieldConsts.inputTextFieldTextInsets.top)
   }
   
}

extension InputTextField: UICollectionViewDelegate {
   
}

extension InputTextField: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if let newInputText = self.newInputText {
         let numerOfItems = self.dataSource?.inputTextField(self, numberOfItemsForCurrentInputText: newInputText) ?? 0
         //self.suggestionsCollectionView.collectionViewLayout.invalidateLayout()
         return numerOfItems
      } else if let inputText = self.text {
         return self.dataSource?.inputTextField(self, numberOfItemsForCurrentInputText: inputText) ?? 0
      } else {
         return 0
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCellId", for: indexPath) as! SuggestionCollectionViewCell
      cell.suggestionButton.backgroundColor = self.keyboardAppearance == .dark ? UIColor(colorLiteralRed: 97/255.0, green: 97/255.0, blue: 97/255.0, alpha: 1.0) : UIColor.white
      cell.suggestionButton.setTitleColor(self.keyboardAppearance == .dark ? UIColor.white : UIColor.black, for: .normal)
      if let newInputText = self.newInputText {
         cell.suggestionButton.setTitle(self.dataSource?.inputTextField(self, titleForItemAt: indexPath.row, forCurrentInputText: newInputText) ?? "", for: .normal)
      } else if let inputText = self.text {
         cell.suggestionButton.setTitle(self.dataSource?.inputTextField(self, titleForItemAt: indexPath.row, forCurrentInputText: inputText) ?? "", for: .normal)
      } else {
         cell.suggestionButton.setTitle("", for: .normal)
      }
      cell.delegate = self
      return cell
   }
   
//   func scrollViewDidScroll(_ scrollView: UIScrollView) {
//      print("contentOffset: \(scrollView.contentOffset.x + UIScreen.main.bounds.size.width)")
//      if scrollView.contentOffset.x > 1000.0 {
//         print("contentSize")
//         print(self.currentCollectionViewContentSize)
//      }
//   }
   
}

extension InputTextField: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      if let newInputText = self.newInputText {
         let button = UIButton(type: .custom)
         button.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
         button.setTitle(self.dataSource?.inputTextField(self, titleForItemAt: indexPath.row, forCurrentInputText: newInputText), for: .normal)
         return CGSize(width: button.intrinsicContentSize.width, height: 49.0)
      }
      
      fatalError()
   }
}

extension InputTextField: InputTextFieldDelegate {
   
   func inputTextField(_ inputTextField: InputTextField, inputTextDidChange newInputText: String) {
      self.newInputText = newInputText
      self.suggestionsCollectionView.reloadData()
   }

}

extension InputTextField: SuggestionCollectionViewCellDelegate {
   
   func insertNewTag(withName name: String, shouldClearInputTextField: Bool) {
      self.dataSource?.insertNewTag(withName: name, shouldClearInputTextField: shouldClearInputTextField)
   }
}
