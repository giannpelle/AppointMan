//
//  ServiceColor.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/30/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit

enum ServiceColor: Int {
   case one = 0, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen, twenty
   
   init() {
      let index = Int(arc4random_uniform(20))
      if let serviceColor = ServiceColor(rawValue: index) {
         self = serviceColor
      } else {
         self = .one
      }
   }
   
   init?(withInt16 int16: Int16?) {
      if let value = int16, value >= 0 && value <= 20 {
         self = ServiceColor(rawValue: Int(value))!
         return
      }
      return nil
   }
   
   func getColor(dark: Bool = false) -> UIColor {
      switch self {
      case .one:
         return UIColor(hue: 4/360.0, saturation: 100/100.0, brightness: dark ? 70/100.0 : 100/100.0, alpha: 1.0)
      case .two:
         return UIColor(hue: 292/360.0, saturation: 45/100.0, brightness: dark ? 70/100.0 : 100/100.0, alpha: 1.0)
      case .three:
         return UIColor(hue: 291/360.0, saturation: 78/100.0, brightness: dark ? 39/100.0 : 69/100.0, alpha: 1.0)
      case .four:
         return UIColor(hue: 262/360.0, saturation: 68/100.0, brightness: dark ? 42/100.0 : 72/100.0, alpha: 1.0)
      case .five:
         return UIColor(hue: 207/360.0, saturation: 92/100.0, brightness: dark ? 59/100.0 : 89/100.0, alpha: 1.0)
      case .six:
         return UIColor(hue: 199/360.0, saturation: 68/100.0, brightness: dark ? 67/100.0 : 97/100.0, alpha: 1.0)
      case .seven:
         return UIColor(hue: 182/360.0, saturation: 100/100.0, brightness: dark ? 9/100.0 : 39/100.0, alpha: 1.0)
      case .eight:
         return UIColor(hue: 174/360.0, saturation: 58/100.0, brightness: dark ? 41/100.0 : 71/100.0, alpha: 1.0)
      case .nine:
         return UIColor(hue: 151/360.0, saturation: 100/100.0, brightness: dark ? 60/100.0 : 90/100.0, alpha: 1.0)
      case .ten:
         return UIColor(hue: 89/360.0, saturation: 63/100.0, brightness: dark ? 40/100.0 : 70/100.0, alpha: 1.0)
      case .eleven:
         return UIColor(hue: 66/360.0, saturation: 74/100.0, brightness: dark ? 56/100.0 : 86/100.0, alpha: 1.0)
      case .twelve:
         return UIColor(hue: 49/360.0, saturation: 75/100.0, brightness: dark ? 70/100.0 : 100/100.0, alpha: 1.0)
      case .thirteen:
         return UIColor(hue: 45/360.0, saturation: 97/100.0, brightness: dark ? 70/100.0 : 100/100.0, alpha: 1.0)
      case .fourteen:
         return UIColor(hue: 36/360.0, saturation: 100/100.0, brightness: dark ? 70/100.0 : 100/100.0, alpha: 1.0)
      case .fifteen:
         return UIColor(hue: 14/360.0, saturation: 87/100.0, brightness: dark ? 70/100.0 : 100/100.0, alpha: 1.0)
      case .sixteen:
         return UIColor(hue: 360/360.0, saturation: 38/100.0, brightness: dark ? 70/100.0 : 100/100.0, alpha: 1.0)
      case .seventeen:
         return UIColor(hue: 16/360.0, saturation: 30/100.0, brightness: dark ? 25/100.0 : 55/100.0, alpha: 1.0)
      case .eighteen:
         return UIColor(hue: 200/360.0, saturation: 17/100.0, brightness: dark ? 38/100.0 : 68/100.0, alpha: 1.0)
      case .nineteen:
         return UIColor(hue: 203/360.0, saturation: 99/100.0, brightness: dark ? 34/100.0 : 64/100.0, alpha: 1.0)
      case .twenty:
         return UIColor(hue: 308/360.0, saturation: 67/100.0, brightness: dark ? 66/100.0 : 96/100.0, alpha: 1.0)
      }
   }
   
   static func getRandomColor(dark: Bool = false) -> UIColor {
      let index = Int(arc4random_uniform(20))
      if let currentServiceColor = ServiceColor(rawValue: index) {
         return currentServiceColor.getColor(dark: dark)
      } else {
         debugPrint("missing color for service")
         return UIColor.brown
      }
   }
}

enum Gender: Int {
   case male = 0, female
   
   init?(withInt16 int16: Int16?) {
      if let value = int16, value >= 0 && value <= 1 {
         self = Gender(rawValue: Int(value))!
         return
      }
      return nil
   }
   
   func getGenderMiniature() -> UIImage {
      switch self {
      case .male:
         return #imageLiteral(resourceName: "iconcina_sesso_uomo")
      case .female:
         return #imageLiteral(resourceName: "iconcina_sesso_donna")
      }
   }
}
