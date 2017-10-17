//
//  ServicesHeaderCollectionReusableView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/14/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

enum Gender: Int {
   case male = 0, female
}

enum SectionType: Int {
   case female = 0, male, unisex
}

class ServicesHeaderCollectionReusableView: UICollectionReusableView {
   
   @IBOutlet weak var gendersStackView: UIStackView!
   
   var sectionType: SectionType!
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      
      switch self.sectionType {
      case .female:
         let femaleImageView = UIImageView(image: #imageLiteral(resourceName: "icona_sesso_donna"))
         self.gendersStackView.insertArrangedSubview(femaleImageView, at: 0)
      case .male:
         let maleImageView = UIImageView(image: #imageLiteral(resourceName: "icona_sesso_uomo"))
         self.gendersStackView.insertArrangedSubview(maleImageView, at: 0)
      case .unisex:
         let femaleImageView = UIImageView(image: #imageLiteral(resourceName: "icona_sesso_donna"))
         let maleImageView = UIImageView(image: #imageLiteral(resourceName: "icona_sesso_uomo"))
         self.gendersStackView.addArrangedSubview(femaleImageView)
         self.gendersStackView.addArrangedSubview(maleImageView)
      default:
         print("type of section unavailable")
      }
      
      let leftAccessoryLinePath = UIBezierPath()
      leftAccessoryLinePath.lineWidth = 0.5
      let rightAccessoryLinePath = UIBezierPath()
      rightAccessoryLinePath.lineWidth = 0.5
      
      if self.sectionType == .unisex {
         leftAccessoryLinePath.move(to: CGPoint(x: 14.0, y: ((rect.size.height / 2.0) - 1.0).rounded()))
         leftAccessoryLinePath.addLine(to: CGPoint(x: ((rect.size.width - 102.0) / 2.0).rounded(), y: ((rect.size.height / 2.0) - 1.0).rounded()))
         
         rightAccessoryLinePath.move(to: CGPoint(x: ((rect.size.width - 102.0) / 2.0).rounded() + 102.0, y: ((rect.size.height / 2.0) - 1.0).rounded()))
         rightAccessoryLinePath.addLine(to: CGPoint(x: rect.size.width - 14.0, y: ((rect.size.height / 2.0) - 1.0).rounded()))
      } else {
         leftAccessoryLinePath.move(to: CGPoint(x: 14.0, y: ((rect.size.height / 2.0) - 1.0).rounded()))
         leftAccessoryLinePath.addLine(to: CGPoint(x: ((rect.size.width - 68.0) / 2.0).rounded(), y: ((rect.size.height / 2.0) - 1.0).rounded()))
         
         rightAccessoryLinePath.move(to: CGPoint(x: ((rect.size.width - 68.0) / 2.0).rounded() + 68.0, y: ((rect.size.height / 2.0) - 1.0).rounded()))
         rightAccessoryLinePath.addLine(to: CGPoint(x: rect.size.width - 14.0, y: ((rect.size.height / 2.0) - 1.0).rounded()))
      }
      
      UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0).setStroke()
      leftAccessoryLinePath.stroke()
      rightAccessoryLinePath.stroke()
   }
}
