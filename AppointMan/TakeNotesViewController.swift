//
//  TakeNotesViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/24/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class TakeNotesViewController: UIViewController {
   
   @IBOutlet weak var navigationTitleViewLabel: UILabel!
   @IBOutlet weak var navigationRightBarButton: UIButton!
   @IBOutlet weak var addMemoButton: UIButton!
   @IBOutlet weak var memoCollectionView: UICollectionView!
   
   var newMemoTextViewContentSizeHeight: CGFloat?
   
   var memos = [Memo(withText: "Ciao a tutti io sono Pietro e torno sempre indietro", isFavorite: true, notificationDate: Date().increaseMonth(by: 1)), Memo(withText: "Ciao a tutti", isFavorite: true, notificationDate: Date()), Memo(withText: "Ciao a tutti io sono Pietro e torno sempre indietro ma a volte prenod l'autostrada senza fare danni wjsjs sjsjs sjsjs sjsjs sjsjs sjsjs sjs sjs sjssj sjsj sjsjs sj ssjs sj sjsjsjs sj sjsjs jssj sj", isFavorite: false, notificationDate: nil)]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
   }
   
   func applyTypography() {
      self.navigationTitleViewLabel.attributedText = UILabel.attributedString(withText: "Annota", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Semibold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
      self.navigationRightBarButton.setAttributedTitle(UILabel.attributedString(withText: "Fatto", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
   }
   
   func setupUI() {
      self.navigationRightBarButton.addTarget(self, action: #selector(self.doneButtonPressed(sender:)), for: .touchUpInside)
      
      self.addMemoButton.clipsToBounds = true
      self.addMemoButton.layer.cornerRadius = 5.0
      self.addMemoButton.setBackgroundColor(color: UIColor.amDarkBlue, forState: .normal)
      self.addMemoButton.setImage(#imageLiteral(resourceName: "icona_piu"), for: .normal)
      self.addMemoButton.setAttributedTitle(UILabel.attributedString(withText: "AGGIUNGI MEMO", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 12.0)!, andCharacterSpacing: 0.0, isCentered: true), for: .normal)
      self.addMemoButton.setBackgroundColor(color: UIColor.amDarkBlue, forState: .normal)
      self.addMemoButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 19.0, 0.0, 29.0)
      self.addMemoButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, -10.0)
      self.addMemoButton.addTarget(self, action: #selector(self.addNewMemoButtonPressed(sender:)), for: .touchUpInside)
      
      self.memoCollectionView.dataSource = self
      self.memoCollectionView.delegate = self
      (self.memoCollectionView.collectionViewLayout as? MasonryLayout)?.delegate = self
   }
   
   @objc func doneButtonPressed(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
   @objc func addNewMemoButtonPressed(sender: UIButton) {
      let addMemoVC = UIStoryboard.addMemoVC()
      addMemoVC.modalPresentationStyle = .formSheet
      addMemoVC.preferredContentSize = CGSize(width: 540.0, height: 600.0)
      self.present(addMemoVC, animated: true, completion: nil)
   }
   
}

extension TakeNotesViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return self.memos.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoCellId", for: indexPath) as? MemoCollectionViewCell else {
         return UICollectionViewCell()
      }
     
      cell.delegate = self
      cell.memo = self.memos[indexPath.row]
      return cell
   }
   
}

extension TakeNotesViewController: UICollectionViewDelegate {
   
}

extension TakeNotesViewController: MemoCollectionViewCellDelegate {
   
   func invalidateLayout(withNewTextViewContentSizeHeight height: CGFloat) {
      self.newMemoTextViewContentSizeHeight = height
      (self.memoCollectionView.collectionViewLayout as? MasonryLayout)?.emptyCache()
      self.memoCollectionView.collectionViewLayout.invalidateLayout()
   }
}

extension TakeNotesViewController: MasonryLayoutDelegate {
   
   func collectionView(_ collectionView: UICollectionView, heightForTextViewAt indexPath: IndexPath) -> CGFloat {
      
      return self.memos[indexPath.row].text.boundingRect(with: CGSize(width: (self.memoCollectionView.bounds.size.width - 40.0) / 3.0 - 32.0, height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFUIText-Regular", size: 14.0)!], context: nil).height
   }
}
