////
////  TagsTextField.swift
////  TagTextField
////
////  Created by Gianluigi Pelle on 6/14/17.
////  Copyright © 2017 Scratch App. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//protocol TagsTextFieldDataSource {
//   func tagsTextField(_ tagsTextField: TagsTextField, numberOfItemsForCurrentInputText inputText: String) -> Int
//   func tagsTextField(_ tagsTextField: TagsTextField, titleForItemAt index: Int, forCurrentInputText inputText: String) -> String
//}
//
//protocol TagsTextFieldDelegate {
//   func tagsTextField(_ tagsTextField: TagsTextField, didAddTag tag: TagButton, withTitle title: String) -> Void
//   func tagsTextField(_ tagsTextField: TagsTextField, didRemoveTag tag: TagButton, withTitle title: String) -> Void
//   func tagsTextField(_ tagsTextField: TagsTextField, didSelectTag tag: TagButton, withTitle title: String) -> Void
//   func tagsTextField(_ tagsTextField: TagsTextField, didDeselectTag tag: TagButton, withTitle title: String) -> Void
//}
//
//extension TagsTextFieldDelegate {
//   func tagsTextField(_ tagsTextField: TagsTextField, didAddTag tag: TagButton, withTitle title: String) {}
//   func tagsTextField(_ tagsTextField: TagsTextField, didRemoveTag tag: TagButton, withTitle title: String) {}
//   func tagsTextField(_ tagsTextField: TagsTextField, didSelectTag tag: TagButton, withTitle title: String) {}
//   func tagsTextField(_ tagsTextField: TagsTextField, didDeselectTag tag: TagButton, withTitle title: String) {}
//}
//
//protocol InputTextFieldDelegate {
//   func inputTextField(_ inputTextField: InputTextField, inputTextDidChange newInputText: String) -> Void
//}
//
//class TagsTextField: UIView {
//   
//   var tagsHorizontalStackView: UIStackView!
//   var inputTextField: InputTextField!
//   
//   // The black background view under the translucent keyboard to make the keyboard flat
//   var keyboardBackgroundViewHeightAnchor: NSLayoutConstraint!
//   
//   var delegate: TagsTextFieldDelegate?
//   var dataSource: TagsTextFieldDataSource?
//   var inputTextFieldDelegate: InputTextFieldDelegate?
//   
//   // Currently added tags
//   var currentTags: [TagButton] {
//      get {
//         if self.tagsHorizontalStackView.arrangedSubviews.count > 1 {
//            let tags = self.tagsHorizontalStackView.arrangedSubviews[0..<self.tagsHorizontalStackView.arrangedSubviews.count - 1].flatMap { $0 as? TagButton }
//            return tags
//         } else {
//            return []
//         }
//      }
//   }
//   var selectedTag: TagButton? {
//      willSet {
//         if let selectedTag = self.selectedTag, newValue == nil && !self.isRemovingTag {
//            self.delegate?.tagsTextField(self, didDeselectTag: selectedTag, withTitle: selectedTag.title(for: .normal)!)
//         } else if newValue == nil && self.isRemovingTag {
//            self.isRemovingTag = false
//         }
//      }
//      didSet {
//         if let selectedTag = self.selectedTag {
//            self.delegate?.tagsTextField(self, didSelectTag: selectedTag, withTitle: selectedTag.title(for: .normal)!)
//         }
//      }
//   }
//   var isReady: Bool? {
//      get {
//         if self.currentTags.isEmpty && inputTextField.text == "" {
//            return nil
//         } else if self.currentTags.count > 0 && self.inputTextField.text == "" {
//            return true
//         } else {
//            return false
//         }
//      }
//   }
//   var allowsOnlyTagsOnEndEditing: Bool = false
//   var isRemovingTag: Bool = false
//   var placeholderText: String = "" {
//      didSet {
//         self.inputTextField.placeholder = placeholderText
//      }
//   }
//   var keyboardAppearance: UIKeyboardAppearance = .default {
//      didSet {
//         self.inputTextField.tagKeyboardAppearance = self.keyboardAppearance
//      }
//   }
//   var tagButtonStyle: TagButtonStyle = .plain
//   var tagButtonDefaultBackgroundColor: UIColor = UIColor.blue
//   var tagButtonSelectedBackgroundColor: UIColor = UIColor.black
//   var tagButtonSelectedBorderColor: UIColor = UIColor.yellow
//   var tagButtonSelectedBorderWidth: CGFloat = 2.0
//   var tagButtonCornerRadius: CGFloat = 8.0
//   var tagButtonContentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
//   var tagButtonTopInset: CGFloat = 4.0
//   var bottomBorderWidth: CGFloat = 1.0
//   var bottomBorderReadyColor: UIColor = UIColor.gray
//   var bottomBorderNotReadyColor: UIColor = UIColor.red
//   var bottomBorderDefaultColor: UIColor = UIColor.gray
//   
//   init() {
//      super.init(frame: CGRect.zero)
//      
//      self.setup()
//   }
//   
//   override init(frame: CGRect) {
//      super.init(frame: frame)
//      
//      self.setup()
//   }
//   
//   required init?(coder aDecoder: NSCoder) {
//      super.init(coder: aDecoder)
//      
//      self.setup()
//   }
//   
//   @discardableResult override func resignFirstResponder() -> Bool {
//      self.inputTextField.resignFirstResponder()
//      return super.resignFirstResponder()
//   }
//   
//   override func didMoveToSuperview() {
//      // The black background view under the translucent keyboard to make the keyboard flat
//      self.setupKeyboard()
//      self.inputTextField.setupSuggestionsCollectionView()
//   }
//   
//   // I think it isn't necessary
////   override func didMoveToSuperview() {
////      self.setup()
////   }
//   
//   func setup() {
//      
//      self.backgroundColor = UIColor.clear
//      
//      // Initializing the Input Text Field
//      self.inputTextField = InputTextField()
//      self.inputTextField.delegate = self
//      self.inputTextField.dataSource = self
//      self.inputTextFieldDelegate = self.inputTextField
//      self.inputTextField.onDidPressDeleteKey = {
//         if let selectedTag = self.selectedTag {
//            self.removeTag(tag: selectedTag)
//            self.isRemovingTag = true
//            self.selectedTag = nil
//            return false
//         } else if self.tagsHorizontalStackView.arrangedSubviews.count > 1 {
//            if let tagButton = self.tagsHorizontalStackView.arrangedSubviews[self.tagsHorizontalStackView.arrangedSubviews.count - 2] as? TagButton {
//               tagButton.isSelected = true
//               self.selectedTag = tagButton
//            }
//            return true
//         } else {
//            return true
//         }
//      }
//      self.inputTextField.onDidResignFirstResponder = {
//         self.setNeedsDisplay()
//      }
//      
//      // Initializing the horizontal Stack View that will host the tags
//      self.tagsHorizontalStackView = UIStackView(arrangedSubviews: [self.inputTextField])
//      self.tagsHorizontalStackView.tag = 37
//      self.tagsHorizontalStackView.axis = .horizontal
//      self.tagsHorizontalStackView.distribution = .fill
//      self.tagsHorizontalStackView.alignment = .center
//      self.tagsHorizontalStackView.spacing = 8.0
//      
//      self.addSubview(self.tagsHorizontalStackView)
//      self.tagsHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
//      self.tagsHorizontalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: TagsTextFieldConsts.tagsHorizontalStackViewPadding.top).isActive = true
//      self.tagsHorizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: TagsTextFieldConsts.tagsHorizontalStackViewPadding.left).isActive = true
//      self.tagsHorizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -TagsTextFieldConsts.tagsHorizontalStackViewPadding.right).isActive = true
//      self.tagsHorizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -TagsTextFieldConsts.tagsHorizontalStackViewPadding.bottom).isActive = true
//      
//      NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "stackViewWillRemoveArrangedSubview"), object: nil, queue: nil, using: catchNotification(notification:))
//      NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "stackViewDidAddArrangedSubview"), object: nil, queue: nil, using: catchNotification(notification:))
//   }
//   
//   
//   // Only override draw() if you perform custom drawing.
//   // An empty implementation adversely affects performance during animation.
//   // To draw the bottom separator line
//   override func draw(_ rect: CGRect) {
//      
//      guard let context = UIGraphicsGetCurrentContext() else { return }
//      context.saveGState()
//      
//      if self.allowsOnlyTagsOnEndEditing {
//         if let isReady = self.isReady {
//            if isReady {
//               context.setStrokeColor(self.bottomBorderReadyColor.cgColor)
//            } else {
//               context.setStrokeColor(self.bottomBorderNotReadyColor.cgColor)
//            }
//         } else {
//            context.setStrokeColor(self.bottomBorderReadyColor.cgColor)
//         }
//      } else {
//         context.setStrokeColor(self.bottomBorderDefaultColor.cgColor)
//      }
//      
//      context.setLineCap(.square)
//      context.setLineWidth(self.bottomBorderWidth)
//      
//      context.move(to: CGPoint(x: self.bounds.origin.x, y: self.bounds.size.height - self.bottomBorderWidth))
//      context.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - self.bottomBorderWidth))
//      context.strokePath()
//      
//      context.restoreGState()
//   }
//   
//   func setupKeyboard() {
//      
//      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: .UIKeyboardWillHide, object: nil)
//      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
//      
//      let keyboardBackgroundView = UIView()
//      keyboardBackgroundView.backgroundColor = UIColor.black
//      self.parentViewController?.view.addSubview(keyboardBackgroundView)
//      keyboardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//      keyboardBackgroundView.bottomAnchor.constraint(equalTo: self.parentViewController!.view.bottomAnchor).isActive = true
//      keyboardBackgroundView.leadingAnchor.constraint(equalTo: self.parentViewController!.view.leadingAnchor).isActive = true
//      keyboardBackgroundView.trailingAnchor.constraint(equalTo: self.parentViewController!.view.trailingAnchor).isActive = true
//      self.keyboardBackgroundViewHeightAnchor = keyboardBackgroundView.heightAnchor.constraint(equalToConstant: 0.0)
//      self.keyboardBackgroundViewHeightAnchor.isActive = true
//      
//   }
//   
//   func keyboardNotification(notification: NSNotification) {
//      
//      let isShowing = notification.name == .UIKeyboardWillShow
//      
//      if let userInfo = notification.userInfo {
//         let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//         let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
//         let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
//         let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
//         let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
//         self.keyboardBackgroundViewHeightAnchor.constant = isShowing ? (endFrame!.size.height) : 0.0
//         UIView.animate(withDuration: duration,
//                        delay: TimeInterval(0),
//                        options: animationCurve,
//                        animations: { self.parentViewController?.view.layoutIfNeeded() },
//                        completion: nil)
//      }
//   }
//   
//   func catchNotification(notification: Notification) -> Void {
//      
//      if notification.name.rawValue == "stackViewWillRemoveArrangedSubview" {
//         if self.tagsHorizontalStackView.arrangedSubviews.count == 2 {
//            self.inputTextField.placeholder = self.placeholderText
//         } else {
//            self.inputTextField.placeholder = ""
//         }
//      }
//      if notification.name.rawValue == "stackViewDidAddArrangedSubview" {
//         self.inputTextField.placeholder = ""
//      }
//   }
//   
//   deinit {
//      NotificationCenter.default.removeObserver(self)
//   }
//   
//}
//
//extension TagsTextField {
//   
//   func insertNewTag(withName name: String, shouldClearInputTextField: Bool) {
//      
//      let tagButton = TagButton()
//      tagButton.dataSource = self
//      tagButton.setTitle(name, for: .normal)
//      tagButton.heightAnchor.constraint(equalToConstant: self.inputTextField.bounds.size.height - (self.tagButtonTopInset * 2.0))
//      tagButton.addTarget(self, action: #selector(self.tagButtonPressed(sender:)), for: .touchUpInside)
//      self.tagsHorizontalStackView.insertArrangedSubview(tagButton, at: self.tagsHorizontalStackView.arrangedSubviews.count - 1)
//      tagButton.isHidden = false
//      self.delegate?.tagsTextField(self, didAddTag: tagButton, withTitle: name)
//      
//      if shouldClearInputTextField {
//         self.inputTextField.text = ""
//      }
//      
//      self.inputTextField.newInputText = ""
//      self.inputTextField.suggestionsCollectionView.reloadData()
//   }
//   
//   func removeTag(tag: TagButton) {
//      self.removeTag(tag: tag, atIndex: nil)
//   }
//   
//   func removeTag(atIndex index: Int) {
//      self.removeTag(tag: nil, atIndex: index)
//   }
//   
//   func removeTag(tag: TagButton?, atIndex index: Int?) {
//      if let tag = tag {
//         tag.isHidden = true
//         tag.removeFromSuperview()
//         self.delegate?.tagsTextField(self, didRemoveTag: tag, withTitle: tag.title(for: .normal)!)
//      } else if let index = index {
//         if let tagToRemove = self.tagsHorizontalStackView.arrangedSubviews[index] as? TagButton {
//            tagToRemove.isHidden = true
//            tagToRemove.removeFromSuperview()
//            self.delegate?.tagsTextField(self, didRemoveTag: tagToRemove, withTitle: tagToRemove.title(for: .normal)!)
//         }
//      }
//   }
//   
//   func tagButtonPressed(sender: TagButton) {
//      if let selectedTag = self.selectedTag, selectedTag == sender {
//         sender.isSelected = false
//         self.selectedTag = nil
//      } else if let selectedTag = self.selectedTag {
//         selectedTag.isSelected = false
//         sender.isSelected = true
//         self.selectedTag = sender
//      } else {
//         sender.isSelected = true
//         self.inputTextField.becomeFirstResponder()
//         self.selectedTag = sender
//      }
//      
//   }
//
//}
//
//extension TagsTextField: UITextFieldDelegate {
//   
//   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//      
//      let newInputText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
//      
//      if let _ = self.selectedTag, newInputText.characters.count < textField.text!.characters.count {
//         return true
//      }
//      
//      self.inputTextFieldDelegate?.inputTextField(self.inputTextField, inputTextDidChange: newInputText)
//
////      
////      if string == " " {
////         let firstWord = String(newString.characters.split(separator: " ")[0])
////         self.insertNewTag(withName: firstWord)
////         textField.text = ""
////         textField.resignFirstResponder()
////      }
//
//      return true
//   }
//   
//   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//      if textField.text != "" {
//         for tagBtn in self.currentTags {
//            if tagBtn.title(for: .normal)?.lowercased() == textField.text?.lowercased() {
//               self.insertNewTag(withName: textField.text!, shouldClearInputTextField: true)
//               textField.resignFirstResponder()
//               return false
//            }
//         }
//         textField.resignFirstResponder()
//         return false
//      }
//      textField.resignFirstResponder()
//      return false
//   }
//   
//}
//
//extension TagsTextField: InputTextFieldDataSource {
//   
//   func inputTextField(_ inputTextField: InputTextField, numberOfItemsForCurrentInputText inputText: String) -> Int {
//      return self.dataSource?.tagsTextField(self, numberOfItemsForCurrentInputText: inputText) ?? 0
//   }
//   
//   func inputTextField(_ inputTextField: InputTextField, titleForItemAt index: Int, forCurrentInputText inputText: String) -> String {
//      return self.dataSource?.tagsTextField(self, titleForItemAt: index, forCurrentInputText: inputText) ?? ""
//   }
//   
//}
//
//extension TagsTextField: TagButtonDataSource {
//   
//   func tagStyle() -> TagButtonStyle {
//      return self.tagButtonStyle
//   }
//   
//   func tagDefaultBackgroundColor() -> UIColor {
//      return self.tagButtonDefaultBackgroundColor
//   }
//   
//   func tagSelectedBackgroundColor() -> UIColor {
//      return self.tagButtonSelectedBackgroundColor
//   }
//   
//   func tagSelectedBorderColor() -> UIColor {
//      return self.tagButtonSelectedBorderColor
//   }
//   
//   func tagSelectedBorderWidth() -> CGFloat {
//      return self.tagButtonSelectedBorderWidth
//   }
//   
//   func tagCornerRadius() -> CGFloat {
//      return self.tagButtonCornerRadius
//   }
//   
//   func tagContentEdgeInsets() -> UIEdgeInsets {
//      return self.tagButtonContentEdgeInsets
//   }
//   
//}
//
//
