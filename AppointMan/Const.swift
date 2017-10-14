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




