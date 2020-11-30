//
//  Const.swift
//  TagTextField
//
//  Created by Gianluigi Pelle on 7/3/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit

class TagsTextFieldConsts {

   // headerStackView preferences
   static let tagsHorizontalStackViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

   // inputTextField preferences
   static let inputTextFieldTextInsets: UIEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)

}

extension UIView {
   
   // To get a reference of the first parentViewController of the caller view
   var parentViewController: UIViewController? {
      var parentResponder: UIResponder? = self
      while parentResponder != nil {
         parentResponder = parentResponder!.next
         if parentResponder is UIViewController {
            return parentResponder as! UIViewController!
         }
      }
      return nil
   }
}

extension UIStackView {
   
   open override func willRemoveSubview(_ subview: UIView) {
      if self.tag == 37 {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stackViewWillRemoveArrangedSubview"), object: nil)
      }
   }
   
   open override func didAddSubview(_ subview: UIView) {
      if self.tag == 37 {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stackViewDidAddArrangedSubview"), object: nil)
      }
   }
   
}
