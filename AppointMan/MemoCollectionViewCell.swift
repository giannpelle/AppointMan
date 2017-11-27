//
//  MemoCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/24/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

// MODEL must be
class Memo {
   var text: String
   var isFavorite: Bool
   var notificationDate: Date?
   var latestMemoTextViewHeight: CGFloat? // in textViewHeight forRowAtIndexPath if let height -> return height ELSE calculate it
   
   init() {
      self.text = ""
      self.isFavorite = false
      self.notificationDate = nil
      self.latestMemoTextViewHeight = UIFont.init(name: "SFUIText-Regular", size: 14.0)!.lineHeight.rounded(.up)
   }
   
   init(text: String, isFavorite: Bool, latestMemoTextViewHeight: CGFloat?, notificationDate: Date? = nil) {
      self.text = text
      self.isFavorite = isFavorite
      self.latestMemoTextViewHeight = latestMemoTextViewHeight
      self.notificationDate = notificationDate
   }
}

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
            placeholderLabel.isHidden = !newValue.isEmpty
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
   func invalidateLayout(withNewTextViewContentSizeHeight height: CGFloat, forCellAt indexPath: IndexPath)
}

class MemoCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var favoriteButton: UIButton!
   @IBOutlet weak var memoTextView: MemoTextView!
   
   weak var delegate: MemoCollectionViewCellDelegate?
   var beforeEditingContentOffset: CGPoint?
   
   var memo: Memo! {
      didSet {
         self.memoTextView.text = self.memo.text
         self.favoriteButton.isSelected = self.memo.isFavorite
      }
   }
   
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
      
      self.favoriteButton.setImage(#imageLiteral(resourceName: "iconcina_annota_preferiti"), for: .normal)
      self.favoriteButton.setImage(#imageLiteral(resourceName: "iconcina_annota_preferiti_selected"), for: .selected)
      self.favoriteButton.addTarget(self, action: #selector(self.favoriteButtonPressed(sender:)), for: .touchUpInside)
      
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
   
   @objc func favoriteButtonPressed(sender: UIButton) {
      sender.isSelected = !sender.isSelected
      self.memo.isFavorite = sender.isSelected
   }
    
}

extension MemoCollectionViewCell: UITextViewDelegate {
   
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      let futureStr = (textView.text as NSString).replacingCharacters(in: range, with: text)
      if let memoTextView = textView as? MemoTextView {
         memoTextView.placeholderLabel?.isHidden = !futureStr.isEmpty
      }
      
      if futureStr.hasSuffix("\n\n") {
         textView.text.removeLast()
         self.updateTextView(withContentSizeHeight: textView.contentSize.height - UIFont.init(name: "SFUIText-Regular", size: 14.0)!.lineHeight.rounded(.up))
         if let underlineLayer = self.memoTextView.underlineLayer {
            underlineLayer.frame.origin.y = textView.contentSize.height + 2.0
         }
         textView.endEditing(true)
         self.memo.text = textView.text
         return false
      }
      
      self.memo.text = futureStr
      return true
   }
   
   func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
      if let memoCollectionView = self.collectionView, let indexPath = self.indexPath, let layoutAttributes = memoCollectionView.layoutAttributesForItem(at: indexPath) {
         self.beforeEditingContentOffset = memoCollectionView.contentOffset
         UIView.animate(withDuration: 0.45, animations: {
            memoCollectionView.contentOffset = CGPoint(x: 0.0, y: layoutAttributes.frame.origin.y - 14.0)
         })
         //memoCollectionView.setContentOffset(CGPoint(x: 0.0, y: layoutAttributes.frame.origin.y - 14.0), animated: true)
      }
      return true
   }
   
   func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
      if let memoCollectionView = self.collectionView, let beforeEditingContentOffset = self.beforeEditingContentOffset {
         UIView.animate(withDuration: 0.45, animations: {
            memoCollectionView.contentOffset = beforeEditingContentOffset
         })
      }
      return true
   }
   
}

extension MemoCollectionViewCell: MemoTextViewDelegate {
   
   func updateTextView(withContentSizeHeight height: CGFloat) {
      if let indexPath = self.indexPath {
         self.delegate?.invalidateLayout(withNewTextViewContentSizeHeight: height, forCellAt: indexPath)
      }
   }
}

// MARK: to get the indexPath from within the cell

extension UIResponder {
   
   func next<T: UIResponder>(_ type: T.Type) -> T? {
      return next as? T ?? next?.next(type)
   }
}

extension UICollectionViewCell {
   
   var collectionView: UICollectionView? {
      return next(UICollectionView.self)
   }
   
   var indexPath: IndexPath? {
      return collectionView?.indexPath(for: self)
   }
}
