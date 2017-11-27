//
//  HeaderMemoCollectionReusableView.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/27/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol HeaderMemoDelegate: class {
   func addNewMemo()
}

class HeaderMemoCollectionReusableView: UICollectionReusableView {
   
   @IBOutlet weak var addMemoButton: UIButton!
   
   weak var delegate: HeaderMemoDelegate?
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      self.addMemoButton.clipsToBounds = true
      self.addMemoButton.layer.cornerRadius = 5.0
      self.addMemoButton.setBackgroundColor(color: UIColor.amDarkBlue, forState: .normal)
      self.addMemoButton.setImage(#imageLiteral(resourceName: "icona_piu"), for: .normal)
      self.addMemoButton.setAttributedTitle(UILabel.attributedString(withText: "AGGIUNGI MEMO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
      self.addMemoButton.setBackgroundColor(color: UIColor.amDarkBlue, forState: .normal)
      self.addMemoButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 19.0, 0.0, 29.0)
      self.addMemoButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, -10.0)
      self.addMemoButton.addTarget(self, action: #selector(self.addMemoButtonPressed(sender:)), for: .touchUpInside)
   }
   
   @objc func addMemoButtonPressed(sender: UIButton) {
      self.delegate?.addNewMemo()
   }
}
