//
//  Constants.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/15/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

/* UIFont(name:
 
 SF UI Text
 == SFUIText-Medium
 == SFUIText-Light
 == SFUIText-Regular
 == SFUIText-SemiboldItalic
 == SFUIText-Heavy
 == SFUIText-Bold
 == SFUIText-MediumItalic
 == SFUIText-Italic
 == SFUIText-BoldItalic
 == SFUIText-Semibold
 == SFUIText-LightItalic
 == SFUIText-HeavyItalic
 
 SF Pro Display
 == SFProDisplay-HeavyItalic
 == SFProDisplay-ThinItalic
 == SFProDisplay-Ultralight
 == SFProDisplay-Heavy
 == SFProDisplay-BoldItalic
 == SFProDisplay-SemiboldItalic
 == SFProDisplay-Regular
 == SFProDisplay-Bold
 == SFProDisplay-MediumItalic
 == SFProDisplay-Thin
 == SFProDisplay-Semibold
 == SFProDisplay-BlackItalic
 == SFProDisplay-Light
 == SFProDisplay-UltralightItalic
 == SFProDisplay-Italic
 == SFProDisplay-LightItalic
 == SFProDisplay-Black
 == SFProDisplay-Medium
 
 SF Pro Text
 == SFProText-Heavy
 == SFProText-LightItalic
 == SFProText-HeavyItalic
 == SFProText-Medium
 == SFProText-Italic
 == SFProText-Bold
 == SFProText-SemiboldItalic
 == SFProText-Light
 == SFProText-MediumItalic
 == SFProText-BoldItalic
 == SFProText-Regular
 == SFProText-Semibold
 
 SF UI Display
 == SFUIDisplay-Regular
 == SFUIDisplay-Bold
 == SFUIDisplay-Thin
 == SFUIDisplay-Medium
 == SFUIDisplay-Heavy
 == SFUIDisplay-Ultralight
 == SFUIDisplay-Semibold
 == SFUIDisplay-Light
 == SFUIDisplay-Black

*/

import Foundation
import UIKit

extension UIColor {
   static let amOnBoardingHeaderTextGrey = #colorLiteral(red: 0.4078176022, green: 0.407827884, blue: 0.4078223705, alpha: 1)
   static let amOnBoardingHeaderTextLightGrey = #colorLiteral(red: 0.7137254902, green: 0.7137254902, blue: 0.7137254902, alpha: 1)
   static let amBlue = #colorLiteral(red: 0.04705882353, green: 0.3215686275, blue: 0.6941176471, alpha: 1)
   static let amOpaqueBlue = #colorLiteral(red: 0.4549019608, green: 0.5529411765, blue: 0.6901960784, alpha: 1)
   static let amDarkBlue = #colorLiteral(red: 0.03137254902, green: 0.2039215686, blue: 0.4509803922, alpha: 1)
   static let amBackgroundBlue = #colorLiteral(red: 0.04671200365, green: 0.1254901961, blue: 0.2352941176, alpha: 1)
   static let amLightGray = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
   static let amCalendarOutOfBoundsDaysGrey = #colorLiteral(red: 0.4980392157, green: 0.5607843137, blue: 0.6431372549, alpha: 0.3)
   static let amFloatingTextFieldPlaceholderText = #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.5960784314, alpha: 1)
   static let amFloatingTextFieldText = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
   static let amSliderDatePickerBubble = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
}

enum ServiceColor: Int {
   case one = 0, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen, twenty
   
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

class Const {
   
   static let defaultOpenCloseAnimationDuration: Double = 0.25
   static let masterToAllWidthPercentage: CGFloat = 1.0 / 3.0
   static let masterMaxWidth: CGFloat = UIScreen.main.bounds.size.width * Const.masterToAllWidthPercentage
   static let detailMaxWidth: CGFloat = UIScreen.main.bounds.size.width * (1 - Const.masterToAllWidthPercentage)
   static let hourHeaderWidth: CGFloat = 40.0
   static let hourUnitHeight: CGFloat = 144.0
   static let halfHourUnitHeight: CGFloat = 72.0
   static let twoThirdUnitHeight: CGFloat = 96.0
   static let halfdayBreakSpacing: CGFloat = 20.0
   static let employeeColomnSpacing: CGFloat = 2.0
   static let hourScrollViewInset: CGFloat = 10.0
   static let employeeHeaderHeight: CGFloat = 40.0
   static let employeeHeaderWidth: CGFloat = UIScreen.main.bounds.size.width * (1.0 / 5.0)
   static let numberOfMorningHours: CGFloat = 6.0
   static let numberOfAfternoonHours: CGFloat = 4.0
   static let numberOfEmployees: CGFloat = 8
   
   // Hard coded values, will be set during initial setup
   static let employees = ["Laura", "Marco", "Giovanni", "Francesca", "Carlo", "Mario", "Giuseppina", "Marica"]
   
}




