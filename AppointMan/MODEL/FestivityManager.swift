//
//  FestivityManager.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/13/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit

class FestivityManager: NSObject {
   static let shared = FestivityManager()
   
   var cachedFestivity: [String: AnyObject] = [:]
   
   private override init() { }

   func loadFestivity() {
      var format = PropertyListSerialization.PropertyListFormat.xml
      var plistData: [String: AnyObject] = [:]
      if let plistPath = Bundle.main.path(forResource: "Festivity", ofType: "plist"), let plistXML = FileManager.default.contents(atPath: plistPath) {
         do {
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &format) as! [String: AnyObject]
         } catch let error {
            print("Error \(error.localizedDescription)")
         }
         self.cachedFestivity = plistData
      }
   }
   
   func getFestivity(for date: Date) -> String? {
      if self.cachedFestivity.isEmpty {
         self.loadFestivity()
      }
      
      if let monthFestivities = self.cachedFestivity["\(date.getMonth())"] as? [[String: AnyObject]] {
         for festivity in monthFestivities {
            if let festivityDate = festivity["data"] as? Date, festivityDate.hasSameDMY(as: date), let festivityDescr = festivity["festivita"] as? String {
               return festivityDescr
            }
         }
      }
      
      return nil
   }
   
}
