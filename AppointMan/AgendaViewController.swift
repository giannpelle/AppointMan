//
//  AgendaViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/10/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit

class AgendaViewController: UIViewController {

   let minimumBubbleMenuTrailingConstant: CGFloat = -189.0
   
   @IBOutlet weak var todayNumberLabel: UILabel!
   @IBOutlet weak var todayMonthLabel: UILabel!
   
   // BUBBLE MENU
   @IBOutlet weak var bubbleMenuView: UIView!
   @IBOutlet weak var bubbleMenuViewTrailingAnchor: NSLayoutConstraint!
   @IBOutlet weak var triangolinoDisclosureIndicatorButton: UIButton!
   @IBOutlet weak var bubbleMenuActionsStackView: UIStackView!
   @IBOutlet weak var cancelButton: VerticallyButton!
   @IBOutlet weak var takeNoteButton: VerticallyButton!
   @IBOutlet weak var newAppointmentButton: VerticallyButton!
   
   // DATE PICKER
   @IBOutlet weak var calendarView: GPCalendarView!
   @IBOutlet weak var calendarViewTrailingAnchor: NSLayoutConstraint!
   
   // FILTRA APPUNTAMENTI controller
   @IBOutlet weak var filterAppointmentsContainerView: UIView!
   @IBOutlet weak var filterAppointmentsContainerViewLeadingAnchor: NSLayoutConstraint!
   
   // BOTTOM BAR
   @IBOutlet weak var bottomBarView: UIView!
   @IBOutlet weak var calendarButton: UIButton!
   @IBOutlet weak var filterButton: UIButton!
   
   var revealMenuDelegate: RevealMenuDelegate?
   var currentPanGestureTranslationX: CGFloat = 0.0
   var isBubbleMenuOpen: Bool = false {
      didSet {
         self.triangolinoDisclosureIndicatorButton.setImage(self.isBubbleMenuOpen ? #imageLiteral(resourceName: "triangolino_close_disclosure_indicator") : #imageLiteral(resourceName: "triangolino_open_disclosure_indicator"), for: .normal)
      }
   }
   var isCalendarViewOpen: Bool = false {
      didSet {
         if self.isCalendarViewOpen {
            self.revealMenuDelegate?.disableSmallMousePad()
         } else {
            self.revealMenuDelegate?.enableSmallMousePad()
         }
      }
   }
   var isFilterAppointmentsContainerViewOpen: Bool = false
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.view.clipsToBounds = true
      
      self.todayNumberLabel.attributedText = UILabel.attributedString(withText: "\(Calendar.current.component(.day, from: Date()))", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 26)!, andCharacterSpacing: -1.46)
      let monthFormatter = DateFormatter()
      monthFormatter.dateFormat = "MMMM"
      monthFormatter.locale = Locale(identifier: "it_IT")
      let yearFormatter = DateFormatter()
      yearFormatter.dateFormat = "yyyy"
      yearFormatter.locale = Locale(identifier: "it_IT")
      self.todayMonthLabel.attributedText = UILabel.attributedString(withText: monthFormatter.string(from: Date()).uppercased() + " " + yearFormatter.string(from: Date()), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 11)!, andCharacterSpacing: 1.38)
      
      // BUBBLE MENU setup
      
      self.bubbleMenuView.layer.roundCorners(corners: [.topLeft, .bottomLeft], radius: self.bubbleMenuView.bounds.size.height / 2.0, viewBounds: bubbleMenuView.bounds)
      
      let bubbleMenuViewPanGestureRec = UIPanGestureRecognizer(target: self, action: #selector(self.bubbleMenuPanGestureRecognized(sender:)))
      self.bubbleMenuView.addGestureRecognizer(bubbleMenuViewPanGestureRec)
      
      self.cancelButton.setImage(#imageLiteral(resourceName: "icona_agenda_annulla"), for: .normal)
      self.cancelButton.setAttributedTitle(UILabel.attributedString(withText: " Annulla ", andTextColor: UIColor.white.withAlphaComponent(0.5), andFont: UIFont.init(name: "SFUIText-Bold", size: 10.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
      
      self.takeNoteButton.setImage(#imageLiteral(resourceName: "icona_agenda_annota"), for: .normal)
      self.takeNoteButton.setAttributedTitle(UILabel.attributedString(withText: " Annota ", andTextColor: UIColor.white.withAlphaComponent(0.5), andFont: UIFont.init(name: "SFUIText-Bold", size: 10.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
      
      self.newAppointmentButton.setImage(#imageLiteral(resourceName: "icona_agenda_nuovo"), for: .normal)
      self.newAppointmentButton.setAttributedTitle(UILabel.attributedString(withText: "  Nuovo  ", andTextColor: UIColor.white.withAlphaComponent(0.5), andFont: UIFont.init(name: "SFUIText-Bold", size: 10.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
      
      
      // BOTTOM BAR setup
      
      //FIX ME: shadow needs refactoring
//      self.bottomBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
//      self.bottomBarView.layer.shadowOpacity = 1.0
//      self.bottomBarView.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
//      self.bottomBarView.layer.shadowRadius = 24.0
//      self.bottomBarView.layer.masksToBounds = false
      
      self.calendarButton.setBackgroundColor(color: UIColor.amDarkBlue, forState: .normal)
      self.calendarButton.setBackgroundColor(color: UIColor.amBlue, forState: .selected)
      
      self.filterButton.setBackgroundColor(color: UIColor.amDarkBlue, forState: .normal)
      self.filterButton.setBackgroundColor(color: UIColor.amBlue, forState: .selected)
      
   }
   
   func cleanViewControllerView() {
      self.closeBubbleMenu()
      self.closeFilterAppointmentsContainerView()
      self.closeCalendarView()
   }
   
   // MARK: REVEAL MENU delegate
   
   @IBAction func hamburgerMenuButtonPressed(sender: UIButton) {
      self.cleanViewControllerView()
      self.revealMenuDelegate?.openRevealMenu()
   }
   
   // MARK: BUBBLE MENU working part
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      if let touch = touches.first, let view = touch.view, view == self.bubbleMenuActionsStackView || touch.view == self.bubbleMenuView {
         
      } else {
         self.closeBubbleMenu()
      }
      
      if let touch = touches.first, let view = touch.view, view == self.filterAppointmentsContainerView || touch.view == self.filterButton {
         
      } else {
         self.closeFilterAppointmentsContainerView()
      }
      
      if let touch = touches.first, let view = touch.view, view == self.calendarView || touch.view == self.calendarButton {
         
      } else {
         self.closeCalendarView()
      }
      
   }
   
   @objc func bubbleMenuPanGestureRecognized(sender: UIPanGestureRecognizer) {
      
      switch sender.state {
      case .began:
         break
      case .changed:
         
         if self.isBubbleMenuOpen {
            
            guard ((self.currentPanGestureTranslationX + sender.translation(in: self.view).x) > 0 || self.bubbleMenuViewTrailingAnchor.constant < 0) && ((self.currentPanGestureTranslationX + sender.translation(in: self.view).x) < abs(self.minimumBubbleMenuTrailingConstant) || self.bubbleMenuViewTrailingAnchor.constant > self.minimumBubbleMenuTrailingConstant) else {
               return
            }
            
            if (self.currentPanGestureTranslationX + sender.translation(in: self.view).x) < 0 {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               self.bubbleMenuViewTrailingAnchor.constant = 0.0
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            } else if (self.currentPanGestureTranslationX + sender.translation(in: self.view).x) > abs(self.minimumBubbleMenuTrailingConstant) {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               self.bubbleMenuViewTrailingAnchor.constant = self.minimumBubbleMenuTrailingConstant
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            } else {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               let progress: CGFloat = self.currentPanGestureTranslationX / abs(self.minimumBubbleMenuTrailingConstant)
               print(progress)
               
               self.bubbleMenuViewTrailingAnchor.constant = self.minimumBubbleMenuTrailingConstant * progress
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            }
            
         } else {
            
            guard ((self.currentPanGestureTranslationX + sender.translation(in: self.view).x) < 0 || self.bubbleMenuViewTrailingAnchor.constant > self.minimumBubbleMenuTrailingConstant) && (abs(self.currentPanGestureTranslationX + sender.translation(in: self.view).x) < abs(self.minimumBubbleMenuTrailingConstant) || self.bubbleMenuViewTrailingAnchor.constant < 0) else {
               return
            }
            
            if (self.currentPanGestureTranslationX + sender.translation(in: self.view).x) > 0 {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               self.bubbleMenuViewTrailingAnchor.constant = self.minimumBubbleMenuTrailingConstant
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            } else if abs(self.currentPanGestureTranslationX + sender.translation(in: self.view).x) > abs(self.minimumBubbleMenuTrailingConstant) {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               self.bubbleMenuViewTrailingAnchor.constant = 0.0
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            } else {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               let progress: CGFloat = 1 - abs(self.currentPanGestureTranslationX / abs(self.minimumBubbleMenuTrailingConstant))
               print(progress)
               
               self.bubbleMenuViewTrailingAnchor.constant = self.minimumBubbleMenuTrailingConstant * progress
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            }
            
         }
         
      case .ended:
         
         if (self.isBubbleMenuOpen && self.currentPanGestureTranslationX > (-self.minimumBubbleMenuTrailingConstant * 40/100.0)) || (!self.isBubbleMenuOpen && -self.currentPanGestureTranslationX < (-self.minimumBubbleMenuTrailingConstant * 40/100.0)) {
            
            self.bubbleMenuViewTrailingAnchor.constant = self.minimumBubbleMenuTrailingConstant
            UIView.animate(withDuration: 0.4, animations: {
               self.view.layoutIfNeeded()
            }, completion: { (success) in
               if success {
                  sender.setTranslation(CGPoint.zero, in: self.view)
                  self.currentPanGestureTranslationX = 0.0
                  self.isBubbleMenuOpen = self.bubbleMenuViewTrailingAnchor.constant != -189
               }
            })
            
         } else {
            
            self.bubbleMenuViewTrailingAnchor.constant = 0.0
            UIView.animate(withDuration: 0.4, animations: {
               self.view.layoutIfNeeded()
            }, completion: { (success) in
               if success {
                  sender.setTranslation(CGPoint.zero, in: self.view)
                  self.currentPanGestureTranslationX = 0.0
                  self.isBubbleMenuOpen = self.bubbleMenuViewTrailingAnchor.constant != -189
               }
            })
            
         }
         
      default:
         break
      }
      
   }
   
   func openBubbleMenu() {
      guard !self.isBubbleMenuOpen else {
         return
      }
      
      self.bubbleMenuViewTrailingAnchor.constant = 0.0
      UIView.animate(withDuration: 0.4, animations: {
         self.view.layoutIfNeeded()
      }, completion: { (success) in
         if success {
            self.isBubbleMenuOpen = self.bubbleMenuViewTrailingAnchor.constant != -189
         }
      })
      
   }
   
   func closeBubbleMenu() {
      
      guard self.isBubbleMenuOpen else {
         return
      }
      
      self.bubbleMenuViewTrailingAnchor.constant = self.minimumBubbleMenuTrailingConstant
      UIView.animate(withDuration: 0.4, animations: {
         self.view.layoutIfNeeded()
      }, completion: { (success) in
         if success {
            self.isBubbleMenuOpen = self.bubbleMenuViewTrailingAnchor.constant != -189
         }
      })
      
   }
   
   @IBAction func bubbleMenuDisclosureButtonPressed(sender: UIButton) {
      
      if self.isBubbleMenuOpen {
         self.closeBubbleMenu()
      } else {
         self.openBubbleMenu()
      }
      
   }
   
   // MARK: DATE PICKER working part
   
   func openCalendarView() {
      guard !self.isCalendarViewOpen else {
         return
      }
      
      self.calendarView.currentMonthIndex = Calendar.current.dateComponents([.month], from: Date(), to: self.calendarView.currentDateSelected).month!
      self.calendarViewTrailingAnchor.constant = 292.0
      UIView.animate(withDuration: 0.6, animations: {
         self.view.layoutIfNeeded()
      }) { (success) in
         self.isCalendarViewOpen = true
         self.calendarButton.isSelected = true
      }
   }
   
   func closeCalendarView() {
      guard self.isCalendarViewOpen else {
         return
      }
      
      self.calendarViewTrailingAnchor.constant = 0.0
      UIView.animate(withDuration: 0.6, animations: {
         self.view.layoutIfNeeded()
      }) { (success) in
         self.isCalendarViewOpen = false
         self.calendarButton.isSelected = false
      }
   }
   
   // MARK: FILTRA APPUNTAMENTI working part
   
   func openFilterAppointmentsContainerView() {
      guard !self.isFilterAppointmentsContainerViewOpen else {
         return
      }
      
      self.filterAppointmentsContainerViewLeadingAnchor.constant = -UIScreen.main.bounds.size.width * 4/10.0
      UIView.animate(withDuration: 0.6, animations: {
         self.view.layoutIfNeeded()
      }) { (success) in
         self.isFilterAppointmentsContainerViewOpen = true
         self.filterButton.isSelected = true
      }
   }
   
   func closeFilterAppointmentsContainerView() {
      guard self.isFilterAppointmentsContainerViewOpen else {
         return
      }
      
      self.filterAppointmentsContainerViewLeadingAnchor.constant = 0.0
      UIView.animate(withDuration: 0.6, animations: {
         self.view.layoutIfNeeded()
      }) { (success) in
         self.isFilterAppointmentsContainerViewOpen = false
         self.filterButton.isSelected = false
      }
   }
   
   // MARK: BOTTOM BAR working part
   
   @IBAction func calendarButtonPressed(sender: UIButton) {
      if self.isCalendarViewOpen {
         self.closeCalendarView()
      } else {
         self.openCalendarView()
      }
   }
   
   @IBAction func filterButtonPressed(sender: UIButton) {
      if self.isFilterAppointmentsContainerViewOpen {
         self.closeFilterAppointmentsContainerView()
      } else {
         self.openFilterAppointmentsContainerView()
      }
   }
   
}
