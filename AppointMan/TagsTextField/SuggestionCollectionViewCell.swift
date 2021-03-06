//
//  SuggestionCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/22/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol SuggestionCollectionViewCellDelegate {
   func insertNewTag(withName name: String, shouldClearInputTextField: Bool) -> Void
}

class SuggestionCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var suggestionButton: UIButton!
   
   var delegate: SuggestionCollectionViewCellDelegate?
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.suggestionButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
      //self.suggestionButton.backgroundColor = UIColor(colorLiteralRed: 97 / 255.0, green: 97 / 255.0, blue: 97 / 255.0, alpha: 1.0)
      self.suggestionButton.layer.cornerRadius = 4.0
      let heightConstr = self.suggestionButton.heightAnchor.constraint(equalToConstant: 49.0)
      heightConstr.priority = 999
      heightConstr.isActive = true
      
   }
   
   @IBAction func suggestionButtonPressed(sender: UIButton) {
      if let tag = sender.titleLabel?.text {
         self.delegate?.insertNewTag(withName: tag, shouldClearInputTextField: true)
      }
   }
   
}
