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
      
      self.memoCollectionView.dataSource = self
      self.memoCollectionView.delegate = self
      (self.memoCollectionView.collectionViewLayout as? MasonryLayout)?.delegate = self
      self.memoCollectionView.register(UINib(nibName: "HeaderMemoCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
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
   
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      switch kind {
      case UICollectionElementKindSectionHeader:
         if let memoHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? HeaderMemoCollectionReusableView {
            memoHeaderView.delegate = self
            return memoHeaderView
         }
         return UICollectionReusableView()
      default:
         return UICollectionReusableView()
      }
   }
   
}

extension TakeNotesViewController: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSize(width: 100.0, height: 100.0)
   }
}

extension TakeNotesViewController: UICollectionViewDelegate {
   
}

extension TakeNotesViewController: MemoCollectionViewCellDelegate {
   
   func invalidateLayout(withNewTextViewContentSizeHeight height: CGFloat, forCellAt indexPath: IndexPath) {
      self.myMemos[indexPath.row].latestMemoTextViewHeight = height
      (self.memoCollectionView.collectionViewLayout as? MasonryLayout)?.emptyCache()
      self.memoCollectionView.collectionViewLayout.invalidateLayout()
   }
}

extension TakeNotesViewController: HeaderMemoDelegate {
   
   func addNewMemo() {
      let newMemo = Memo()
      self.myMemos.insert(newMemo, at: 0)
      self.memoCollectionView.reloadData()
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
