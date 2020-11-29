//
//  Memo.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/29/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit

class Memo {
   
   var text: String
   var isFavorite: Bool
   var notificationDate: Date?
   var latestContentSizeHeight: CGFloat?
   
   init() {
      self.text = ""
      self.isFavorite = false
   }
   
   init(withText text: String, isFavorite: Bool, notificationDate: Date?, latestContentSizeHeight: CGFloat? = nil) {
      self.text = text
      self.isFavorite = isFavorite
      self.notificationDate = notificationDate
      self.latestContentSizeHeight = latestContentSizeHeight
   }
   
}
