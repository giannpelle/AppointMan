//
//  MemoCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/24/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol MemoTextViewDelegate: class {
   func updateTextView(withContentSizeHeight height: CGFloat)
}

class MemoTextView: UITextView {
   
   weak var memoDelegate: MemoTextViewDelegate?
   var underlineLayer: CALayer?
   var placeholderLabel: UILabel?
   
   override var text: String! {
      willSet {
         if let placeholderLabel = self.placeholderLabel {
            placeholderLabel.isHidden = !newValue.characters.isEmpty
         }
      }
   }
   
   override var contentSize: CGSize {
      willSet {
         if newValue.height != self.contentSize.height {
            self.memoDelegate?.updateTextView(withContentSizeHeight: newValue.height - 10.0)
            if let underlineLayer = self.underlineLayer {
               underlineLayer.frame.origin.y = newValue.height + 2.0
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
      underlineLayer.frame = CGRect(x: 2.0, y: self.contentSize.height + 2.0, width: self.bounds.size.width - 4.0, height: 2.0)
      self.underlineLayer = underlineLayer
      self.layer.addSublayer(underlineLayer)
      
      let placeholderLabel = UILabel()
      placeholderLabel.attributedText = UILabel.attributedString(withText: "Inserisci nota...", andTextColor: UIColor.grayWith(value: 152), andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: 0.0)
      self.placeholderLabel = placeholderLabel
      self.addSubview(placeholderLabel)
      placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
      placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4.0).isActive = true
      placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4.0).isActive = true
   }
   
}

protocol MemoCollectionViewCellDelegate: class {
   func invalidateLayout(withNewTextViewContentSizeHeight height: CGFloat)
}

class MemoCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var bookmarkButton: UIButton!
   @IBOutlet weak var editButton: UIButton!
   @IBOutlet weak var memoTextView: MemoTextView!
   
   weak var delegate: MemoCollectionViewCellDelegate?
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      
   }
   
   func setupUI() {
      self.clipsToBounds = true
      self.layer.cornerRadius = 3.0
      
      self.bookmarkButton.setImage(#imageLiteral(resourceName: "iconcina_annota_preferiti"), for: .normal)
      self.bookmarkButton.setImage(#imageLiteral(resourceName: "iconcina_annota_preferiti_selected"), for: .selected)
      
      self.memoTextView.delegate = self
      self.memoTextView.memoDelegate = self
      self.memoTextView.text = ""
      self.memoTextView.textColor = UIColor.grayWith(value: 75)
      self.memoTextView.font = UIFont.init(name: "SFUIText-Regular", size: 14.0)!
      self.memoTextView.autocorrectionType = .no
      self.memoTextView.spellCheckingType = .no
      self.memoTextView.inputAssistantItem.leadingBarButtonGroups = []
      self.memoTextView.inputAssistantItem.trailingBarButtonGroups = []
      self.memoTextView.textContainerInset = UIEdgeInsetsMake(4.0, 0.0, 6.0, 0.0)
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      self.endEditing(true)
   }
    
}

extension MemoCollectionViewCell: UITextViewDelegate {
   
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      let futureStr = (textView.text as NSString).replacingCharacters(in: range, with: text)
      if let memoTextView = textView as? MemoTextView {
         memoTextView.placeholderLabel?.isHidden = !futureStr.characters.isEmpty
      }
      
      return true
   }
}

extension MemoCollectionViewCell: MemoTextViewDelegate {
   
   func updateTextView(withContentSizeHeight height: CGFloat) {
      self.delegate?.invalidateLayout(withNewTextViewContentSizeHeight: height)
   }
}
