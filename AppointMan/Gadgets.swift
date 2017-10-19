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
   
   override var isSelected: Bool {
      didSet {
         if self.isSelected {
            for view in self.subviews {
               if view.tag == 1 {
                  view.removeFromSuperview()
               }
            }
            
            let checkImageView = UIImageView(image: #imageLiteral(resourceName: "check"))
            checkImageView.tag = 1
            self.insertSubview(checkImageView, aboveSubview: self.imageView!)
            checkImageView.translatesAutoresizingMaskIntoConstraints = false
            checkImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
            checkImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
            checkImageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
            checkImageView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
         } else {
            for view in self.subviews {
               if view.tag == 1 {
                  view.removeFromSuperview()
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
