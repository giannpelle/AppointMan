//
//  MemoCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/24/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol MemoTextViewDelegate: class {
   func updateTextView(withHeight height: CGFloat)
   func setNeedsUpdateLayout()
}

class MemoTextView: UITextView {
   
   weak var memoDelegate: MemoTextViewDelegate?
   var underlineLayer: CALayer?
   
   override var contentSize: CGSize {
      willSet {
         if newValue.height != self.contentSize.height {
            print("oldContentSize: \(self.contentSize) willSet: \(newValue)")
            self.memoDelegate?.updateTextView(withHeight: newValue.height - 10.0)
            if let underlineLayer = self.underlineLayer {
               underlineLayer.frame.origin.y = newValue.height + 4.0
            }
         }
      }
   }
   
   override init(frame: CGRect, textContainer: NSTextContainer?) {
      super.init(frame: frame, textContainer: textContainer)
      
      self.setup()
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      self.setup()
   }
   
   func setup() {
      let underlineLayer = CALayer()
      underlineLayer.backgroundColor = UIColor.grayWith(value: 236).cgColor
      underlineLayer.frame = CGRect(x: 0.0, y: self.contentSize.height + 4.0, width: self.bounds.size.width, height: 2.0)
      self.underlineLayer = underlineLayer
      self.layer.addSublayer(underlineLayer)
   }
   
}

protocol MemoCollectionViewCellDelegate: class {
   func invalidateLayout(withNewTextViewHeight height: CGFloat)
}

class MemoCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var memoTextView: MemoTextView!
   
   weak var delegate: MemoCollectionViewCellDelegate?
   var currentTextViewContentSizeHeight: CGFloat = 0.0
   var needsUpdateLayout: Bool = false
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      
   }
   
   func setupUI() {
      self.memoTextView.backgroundColor = UIColor.green
      self.memoTextView.memoDelegate = self
      self.memoTextView.delegate = self
      self.memoTextView.text = "Enter text..."
      self.memoTextView.textColor = UIColor.grayWith(value: 152)
      self.memoTextView.autocorrectionType = .no
      self.memoTextView.spellCheckingType = .no
      self.memoTextView.inputAssistantItem.leadingBarButtonGroups = []
      self.memoTextView.inputAssistantItem.trailingBarButtonGroups = []
      self.memoTextView.selectedTextRange = self.memoTextView.textRange(from: self.memoTextView.beginningOfDocument, to: self.memoTextView.beginningOfDocument)
      self.memoTextView.font = UIFont.init(name: "SFUIText-Regular", size: 14.0)!
      self.memoTextView.textContainerInset = UIEdgeInsetsMake(4.0, 2.0, 6.0, 2.0)
   }
    
}

extension MemoCollectionViewCell: MemoTextViewDelegate {
   
   func updateTextView(withHeight height: CGFloat) {
      //let constrainedSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
      //let height = self.memoTextView.text.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFUIText-Regular", size: 14.0)!], context: nil).height.rounded(.up)
      self.delegate?.invalidateLayout(withNewTextViewHeight: height)
   }
   
   func setNeedsUpdateLayout() {
      self.needsUpdateLayout = true
   }
}

extension MemoCollectionViewCell: UITextViewDelegate {
   
   func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.grayWith(value: 152) {
         textView.text = nil
         textView.textColor = UIColor.grayWith(value: 75)
      }
   }
   
   func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.isEmpty {
         textView.text = "Enter text..."
         textView.textColor = UIColor.grayWith(value: 152)
      }
   }
   
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      
//      let str = (textView.text as NSString).replacingCharacters(in: range, with: text)
//      
//      let constrainedSize = CGSize(width: (UIScreen.main.bounds.size.width - (40.0 + 10 + 20 + 20 + 10 + 40)) / 3.0 - 40.0 - 4.0 - 12.0, height: CGFloat.greatestFiniteMagnitude)
//      
//      
//      let newHeight = (textView.text + text).boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFUIText-Regular", size: 14.0)!], context: nil).height
//      
//      if textView.contentSize.height != self.currentTextViewContentSizeHeight || text == "\n" {
//         self.currentTextViewContentSizeHeight = textView.contentSize.height
//         self.delegate?.invalidateLayout(withNewTextViewHeight: newHeight)
//      }
      
//      if self.needsUpdateLayout {
//         self.needsUpdateLayout = false
//         self.delegate?.invalidateLayout(withNewTextViewHeight: textView.contentSize.height)
//      }
//      let str = (textView.text as NSString).replacingCharacters(in: range, with: text)
//      self.delegate?.updateText(withNewText: str)
//
//      if textView.contentSize.height != self.currentTextViewContentSizeHeight || text == "\n" {
//         self.currentTextViewContentSizeHeight = textView.contentSize.height
//         self.invalidateLayout()
//      }
      
      // Combine the textView text and the replacement text to
      // create the updated text string
      let currentText = textView.text
      let updatedText = (currentText! as NSString).replacingCharacters(in: range, with: text)
      
      // If updated text view will be empty, add the placeholder
      // and set the cursor to the beginning of the text view
      if updatedText.isEmpty {
         textView.text = "Enter text..."
         textView.textColor = UIColor.grayWith(value: 152)
         textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
         
         return false
      }
         
      // Else if the text view's placeholder is showing and the
      // length of the replacement string is greater than 0, clear
      // the text view and set its color to black to prepare for
      // the user's entry
      else if textView.textColor == UIColor.lightGray && !text.isEmpty {
         textView.text = nil
         textView.textColor = UIColor.grayWith(value: 75)
      }
      
      return true
   }
   
   func textViewDidChangeSelection(_ textView: UITextView) {
      if self.window != nil {
         if textView.textColor == UIColor.grayWith(value: 152) {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
         }
      }
   }
}
