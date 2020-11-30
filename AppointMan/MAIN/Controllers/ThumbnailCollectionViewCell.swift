//
//  ThumbnailCollectionViewCell.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/16/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
   
   @IBOutlet weak var thumbnailButton: ThumbnailVerticallyButton!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
   }
   
   func setup(withImage image: UIImage, andText text: String) {
      self.thumbnailButton.setup(withImage: image, andText: text)
   }
   
}
