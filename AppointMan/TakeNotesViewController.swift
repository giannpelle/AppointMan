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
   
   var myMemos: [Memo] = [Memo(text: "Ciao", isFavorite: true, latestMemoTextViewHeight: 17.0), Memo(text: "Ciao quest è una prova per vedere se ci sta su due righe", isFavorite: false, latestMemoTextViewHeight: 34.0), Memo(text: "Ciao prova tre", isFavorite: false, latestMemoTextViewHeight: 17.0)]
   
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
      self.addMemoButton.addTarget(self, action: #selector(self.addNewMemo(sender:)), for: .touchUpInside)
      
      self.memoCollectionView.dataSource = self
      self.memoCollectionView.delegate = self
      (self.memoCollectionView.collectionViewLayout as? MasonryLayout)?.delegate = self
   }
   
   @objc func addNewMemo(sender: UIButton) {
      let newMemo = Memo()
      self.myMemos.insert(newMemo, at: 0)
      self.memoCollectionView.reloadData()
      (self.memoCollectionView.collectionViewLayout as? MasonryLayout)?.emptyCache()
      self.memoCollectionView.collectionViewLayout.invalidateLayout()
   }
   
   @objc func doneButtonPressed(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
}

extension TakeNotesViewController: UICollectionViewDataSource {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return self.myMemos.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoCellId", for: indexPath) as? MemoCollectionViewCell else {
         return UICollectionViewCell()
      }
     
      cell.memo = self.myMemos[indexPath.row]
      cell.delegate = self
      return cell
   }
   
}

extension TakeNotesViewController: UICollectionViewDelegate {
   
}

extension TakeNotesViewController: MemoCollectionViewCellDelegate {
   
   func invalidateLayout(withNewTextViewContentSizeHeight height: CGFloat, forCellAt indexPath: IndexPath) {
      self.myMemos[indexPath.row].latestMemoTextViewHeight = Int(height / 17.0) * 17.0
      (self.memoCollectionView.collectionViewLayout as? MasonryLayout)?.emptyCache()
      self.memoCollectionView.collectionViewLayout.invalidateLayout()
   }
}

extension TakeNotesViewController: MasonryLayoutDelegate {
   
   func collectionView(_ collectionView: UICollectionView, heightForTextViewAtIndexPath indexPath: IndexPath) -> CGFloat {
      
      if let height = self.myMemos[indexPath.row].latestMemoTextViewHeight {
         print(height)
         return height
      }
      
      return UIFont.init(name: "SFUIText-Regular", size: 14.0)!.lineHeight.rounded(.up)
      
      // SOLO SE PROPRIO SENZA SPERANZE calcolare altezza programmaticamente
      //let constrainedSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
      //let height = self.memoTextView.text.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFUIText-Regular", size: 14.0)!], context: nil).height.rounded(.up)
      
   }
}
