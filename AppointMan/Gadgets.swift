//
//  Components.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/13/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit

class VerticallyButton: UIButton {
   
   var padding: CGFloat = 2.0 {
      didSet {
         setNeedsLayout()
      }
   }
   
   override var intrinsicContentSize: CGSize {
      let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
      
      if let titleSize = titleLabel?.sizeThatFits(maxSize), let imageSize = imageView?.sizeThatFits(maxSize) {
         let width = ceil(max(imageSize.width, titleSize.width))
         let height = ceil(imageSize.height + titleSize.height + padding)
         
         return CGSize(width: width, height: height)
      }
      
      return super.intrinsicContentSize
   }
   
   override func layoutSubviews() {
      if let image = imageView?.image, let title = titleLabel?.attributedText {
         let imageSize = image.size
         let titleSize = title.size()
         
         titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + padding) + 12.0, 0.0)
         imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + padding) + 6.0, 0.0, 0.0, -titleSize.width)
      }
      super.layoutSubviews()
   }
}

class ThumbnailVerticallyButton: UIButton {
   
   lazy var checkLayer: CAShapeLayer = {
      let circleLayer = CAShapeLayer()
      circleLayer.fillColor = UIColor.amBlue.cgColor
      let circlePath = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 16.0))
      circleLayer.path = circlePath.cgPath
      circleLayer.frame = CGRect(x: self.bounds.size.width - 29.0, y: 6.0, width: 16.0, height: 16.0)
      
      let checkLayer = CAShapeLayer()
      checkLayer.fillColor = UIColor.clear.cgColor
      let checkPath = UIBezierPath()
      checkPath.move(to: CGPoint(x: 4.0, y: 7.0))
      checkPath.addLine(to: CGPoint(x: 7.0, y: 10.0))
      checkPath.addLine(to: CGPoint(x: 12.0, y: 5.0))
      checkLayer.path = checkPath.cgPath
      checkLayer.strokeColor = UIColor.white.cgColor
      checkLayer.lineWidth = 2.0
      checkLayer.frame = circleLayer.bounds
      circleLayer.addSublayer(checkLayer)
      
      return circleLayer
   }()
   
   override var isSelected: Bool {
      didSet {
         if self.isSelected {
            if let sublayers = self.layer.sublayers {
               for layer in sublayers {
                  if layer == self.checkLayer {
                     layer.removeFromSuperlayer()
                  }
               }
            }
            
            self.layer.addSublayer(self.checkLayer)
         } else {
            if let sublayers = self.layer.sublayers {
               for layer in sublayers {
                  if layer == self.checkLayer {
                     layer.removeFromSuperlayer()
                  }
               }
            }
         }
      }
   }
   
   func setup(withImage image: UIImage, andText text: String) {
      self.setAttributedTitle(UILabel.attributedString(withText: text, andTextColor: UIColor.grayWith(value: 103), andFont: UIFont.init(name: "SFUIText-Semibold", size: 11.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
      self.setAttributedTitle(UILabel.attributedString(withText: text, andTextColor: UIColor.amBlue, andFont: UIFont.init(name: "SFUIText-Bold", size: 11.0)!, andCharacterSpacing: nil, isCentered: true), for: .selected)
      self.setImage(image.scale(toSize: CGSize(width: 48.0, height: 48.0)), for: .normal)
      self.setImage(image.scale(toSize: CGSize(width: 48.0, height: 48.0)).alpha(0.6), for: .selected)
   }
   
   var padding: CGFloat = 30.0 {
      didSet {
         setNeedsLayout()
      }
   }
   
   override var intrinsicContentSize: CGSize {
      let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
      
      if let titleSize = titleLabel?.sizeThatFits(maxSize), let imageSize = imageView?.sizeThatFits(maxSize) {
         let width = ceil(max(imageSize.width, titleSize.width))
         let height = ceil(imageSize.height + titleSize.height + padding)
         return CGSize(width: width, height: height)
      }
      return super.intrinsicContentSize
   }
   
   override func layoutSubviews() {
      if let image = imageView?.image, let title = titleLabel?.attributedText {
         let imageSize = image.size
         let titleSize = title.size()
         titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + padding) + 18.0, 0.0)
         imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + padding) + 22.0, 0.0, 0.0, -titleSize.width)
      }
      super.layoutSubviews()
      self.imageView?.layer.cornerRadius = (self.imageView?.bounds.size.height ?? 0.0) / 2.0
   }
}

class ThumbnailVerticallyStaticButton: UIButton {
   
   func setup(withImage image: UIImage, andText text: String) {
      self.isUserInteractionEnabled = false
      self.setAttributedTitle(UILabel.attributedString(withText: text, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 16.0)!, andCharacterSpacing: 1.14, isCentered: true), for: .normal)
      self.setImage(image.scale(toSize: CGSize(width: 48.0, height: 48.0)), for: .normal)
   }
   
   var padding: CGFloat = 30.0 {
      didSet {
         setNeedsLayout()
      }
   }
   
   override var intrinsicContentSize: CGSize {
      let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
      
      if let titleSize = titleLabel?.sizeThatFits(maxSize), let imageSize = imageView?.sizeThatFits(maxSize) {
         let width = ceil(max(imageSize.width, titleSize.width))
         let height = ceil(imageSize.height + titleSize.height + padding)
         return CGSize(width: width, height: height)
      }
      return super.intrinsicContentSize
   }
   
   override func layoutSubviews() {
      if let image = imageView?.image, let title = titleLabel?.attributedText {
         let imageSize = image.size
         let titleSize = title.size()
         titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + padding) + 22.0, 0.0)
         imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + padding) + 23.0, 0.0, 0.0, -titleSize.width)
      }
      super.layoutSubviews()
      self.imageView?.layer.cornerRadius = (self.imageView?.bounds.size.height ?? 0.0) / 2.0
   }
}

protocol BoxViewDelegate {
   func didRemove(view: BoxView, atColomnIndex colomnIndex: Int)
}

class BoxView: UIView {
   
   //var borderLayer: CALayer?
   var deleteBoxButton: UIButton!
   var topAccessoryLabel: UILabel!
   var bottomAccessoryLabel: UILabel!
   
   var delegate: BoxViewDelegate?
   var colomnIndex: Int = 0
   var isEditMode: Bool = false {
      didSet {
         if self.isEditMode {
            self.showDeleteBoxButton()
         } else {
            self.hideDeleteBoxButton()
         }
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
   
   override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      guard self.isUserInteractionEnabled, !self.clipsToBounds, !self.isHidden, self.alpha != 0.0 else {
         return nil
      }
         
      for subview in subviews.reversed() {
         let subPoint = subview.convert(point, from: self)
         if let result = subview.hitTest(subPoint, with: event) {
            return result
         }
      }
      return nil
   }
   
   func setup() {
      
      self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
      self.layer.cornerRadius = 5.0
      
      let borderView = UIView()
      borderView.backgroundColor = UIColor.clear
      borderView.layer.cornerRadius = 5.0
      borderView.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
      borderView.layer.borderWidth = 2.0
      self.addSubview(borderView)
      borderView.translatesAutoresizingMaskIntoConstraints = false
      borderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
      
      self.deleteBoxButton = UIButton()
      self.deleteBoxButton.isHidden = true
      self.deleteBoxButton.setImage(#imageLiteral(resourceName: "iconcina_elimina_box"), for: .normal)
      self.deleteBoxButton.addTarget(self, action: #selector(self.deleteBoxButtonPressed(sender:)), for: .touchUpInside)
      self.addSubview(self.deleteBoxButton)
      self.deleteBoxButton.translatesAutoresizingMaskIntoConstraints = false
      self.deleteBoxButton.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
      self.deleteBoxButton.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
      self.deleteBoxButton.centerXAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      self.deleteBoxButton.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
      
      self.topAccessoryLabel = UILabel()
      self.addSubview(self.topAccessoryLabel)
      self.topAccessoryLabel.translatesAutoresizingMaskIntoConstraints = false
      self.topAccessoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      self.topAccessoryLabel.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
      
      self.bottomAccessoryLabel = UILabel()
      self.addSubview(self.bottomAccessoryLabel)
      self.bottomAccessoryLabel.translatesAutoresizingMaskIntoConstraints = false
      self.bottomAccessoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      self.bottomAccessoryLabel.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
//      if let borderLayer = self.borderLayer {
//         borderLayer.frame = self.bounds
//      } else {
//         self.borderLayer = CALayer()
//         self.borderLayer?.frame = self.bounds
//         self.borderLayer?.backgroundColor = UIColor.clear.cgColor
//         self.borderLayer?.borderColor = UIColor.purple.cgColor
//         self.borderLayer?.borderWidth = 2.0
//         self.layer.addSublayer(borderLayer!)
//      }
      
   }
   
   func setupAccessoryLabels(withTopString topString: String, andBottomString bottomString: String) {
      self.topAccessoryLabel.attributedText = UILabel.attributedString(withText: topString, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 10.0)!, andCharacterSpacing: nil)
      self.topAccessoryLabel.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
      self.bottomAccessoryLabel.attributedText = UILabel.attributedString(withText: bottomString, andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 10.0)!, andCharacterSpacing: nil)
      self.bottomAccessoryLabel.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
   }
   
   func showDeleteBoxButton() {
      self.deleteBoxButton.isHidden = false
   }
   
   func hideDeleteBoxButton() {
      self.deleteBoxButton.isHidden = true
   }
   
   @objc func deleteBoxButtonPressed(sender: UIButton) {
      self.delegate?.didRemove(view: self, atColomnIndex: self.colomnIndex)
      self.removeFromSuperview()
   }
   
}

class PlaceholderOverlayableView: UIView, Overlayable {
   
   override func draw(_ rect: CGRect) {
      self.drawOverlay(rect)
   }
}

class PlaceholderTextView: UITextView, UITextViewDelegate {
   
   private let placeholderColor: UIColor = UIColor(white: 0.78, alpha: 1)
   private var placeholderLabel: UILabel!
   
   var placeholder: String = "" {
      didSet {
         self.placeholderLabel.text = placeholder
      }
   }
   
   lazy var textAttributes: [String: Any] = {
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 4.0
      style.alignment = .natural
      let attributes: [String: Any] = [NSAttributedStringKey.paragraphStyle.rawValue: style, NSAttributedStringKey.kern.rawValue: 0.0, NSAttributedStringKey.font.rawValue: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, NSAttributedStringKey.foregroundColor.rawValue: UIColor.grayWith(value: 152.0)]
      return attributes
   }()
   
   override var text: String! {
      didSet {
         textViewDidChange(self)
      }
   }
   
   override init(frame: CGRect, textContainer: NSTextContainer?) {
      super.init(frame: frame, textContainer: textContainer)
      self.configurePlaceholderLabel()
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.configurePlaceholderLabel()
   }
   
   func configurePlaceholderLabel() {
      self.typingAttributes = self.textAttributes
      self.textContainerInset = UIEdgeInsetsMake(14.0, 15.0, 14.0, 15.0)
      self.delegate = self
      
      self.placeholderLabel = UILabel()
      self.placeholderLabel.font = font
      self.placeholderLabel.textColor = self.placeholderColor
      self.placeholderLabel.text = self.placeholder
      self.placeholderLabel.numberOfLines = 0
      self.placeholderLabel.isHidden = !self.text.isEmpty
      self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
      
      self.addSubview(self.placeholderLabel)
      self.placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.textContainerInset.top).isActive = true
      self.placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.textContainerInset.left + 5.0).isActive = true

   }
   
   func textViewDidChange(_ textView: UITextView) {
      self.placeholderLabel.isHidden = !textView.text.isEmpty
   }
   
}
