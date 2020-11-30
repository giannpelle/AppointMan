//
//  RevealMenuViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/4/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit

protocol RevealMenuDelegate: class {
   func openRevealMenu()
   func closeRevealMenu()
   func enableSmallMousePad()
   func disableSmallMousePad()
}

class RevealMenuViewController: UIViewController {
   
   let revealMenuWidth: CGFloat = UIScreen.main.bounds.size.width / 3.0
   let revealMenuVerticalPadding: CGFloat = 84.0//UIScreen.main.bounds.size.height * (11.0 / 100.0)
   
   @IBOutlet var revealMenuActionButtons: [UIButton]!
   @IBOutlet weak var revealMenuActionsStackView: UIStackView!
   @IBOutlet weak var smallMousePad: UIView!
   @IBOutlet weak var largeMousePad: UIView!
   @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var containerViewLeadingAnchor: NSLayoutConstraint!
   @IBOutlet weak var containerViewHeightEqualToViewAnchor: NSLayoutConstraint!
   
   var currentPanGestureTranslationX: CGFloat = 0.0
   var isRevealMenuOpen: Bool! {
      didSet {
         if isRevealMenuOpen {
            self.largeMousePad.isUserInteractionEnabled = true
            self.smallMousePad.isUserInteractionEnabled = false
            self.containerView.isUserInteractionEnabled = false
         } else {
            self.containerView.isUserInteractionEnabled = true
            self.smallMousePad.isUserInteractionEnabled = true
            self.largeMousePad.isUserInteractionEnabled = false
         }
      }
   }
   var currentRevealMenuActionSelected: Int! {
      didSet {
         self.currentChildVCPresented?.willMove(toParentViewController: nil)
         self.currentChildVCPresented?.view.removeFromSuperview()
         self.currentChildVCPresented?.removeFromParentViewController()
         for view in self.containerView.subviews {
            view.removeFromSuperview()
         }
         
         var viewControllerToBePresented: UIViewController
         
         switch self.currentRevealMenuActionSelected {
         case 0:
            let agendaVC = UIStoryboard.agendaVC()
            agendaVC.revealMenuDelegate = self
            viewControllerToBePresented = agendaVC
            break
         case 1:
            let dipendentiVC = UIStoryboard.dipendentiVC()
            dipendentiVC.revealMenuDelegate = self
            viewControllerToBePresented = dipendentiVC
            break
         case 2:
            let clientiVC = UIStoryboard.clientiVC()
            clientiVC.revealMenuDelegate = self
            viewControllerToBePresented = clientiVC
            break
         case 3:
            let prodottiVC = UIStoryboard.prodottiVC()
            //prodottiVC.revealMenuDelegate = self
            viewControllerToBePresented = prodottiVC
            break
         case 4:
            let statisticheVC = UIStoryboard.statisticheVC()
            //statisticheVC.revealMenuDelegate = self
            viewControllerToBePresented = statisticheVC
            break
         case 5:
            let bilancioVC = UIStoryboard.bilancioVC()
            //bilancioVC.revealMenuDelegate = self
            viewControllerToBePresented = bilancioVC
            break
         case 6:
            let impostazioniVC = UIStoryboard.impostazioniVC()
            //impostazioniVC.revealMenuDelegate = self
            viewControllerToBePresented = impostazioniVC
            break
         default:
            viewControllerToBePresented = UIViewController()
            break
         }
         
         self.addChildViewController(viewControllerToBePresented)
         self.currentChildVCPresented = viewControllerToBePresented
         self.containerView.addSubview(viewControllerToBePresented.view)
         viewControllerToBePresented.view.translatesAutoresizingMaskIntoConstraints = false
         viewControllerToBePresented.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
         viewControllerToBePresented.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
         viewControllerToBePresented.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
         viewControllerToBePresented.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
         viewControllerToBePresented.didMove(toParentViewController: self)
         
         self.containerView.layoutIfNeeded()
      }
   }
   var currentChildVCPresented: UIViewController?
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let smallMousePadPanGestureRec = UIPanGestureRecognizer(target: self, action: #selector(self.revealMenuPanGestureRecognized(sender:)))
      self.smallMousePad.addGestureRecognizer(smallMousePadPanGestureRec)
      
      let largeMousePadPanGestureRec = UIPanGestureRecognizer(target: self, action: #selector(self.revealMenuPanGestureRecognized(sender:)))
      self.largeMousePad.addGestureRecognizer(largeMousePadPanGestureRec)
      
      let largeMousePadTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.closeRevealMenu))
      self.largeMousePad.addGestureRecognizer(largeMousePadTapGestureRec)
      
      for (index, menuBtn) in self.revealMenuActionButtons.enumerated() {
         
         switch index {
         case 0:
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Agenda", andTextColor: UIColor.white.withAlphaComponent(0.6), andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .normal)
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Agenda", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .selected)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_agenda"), for: .normal)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_agenda_selected"), for: .selected)
         case 1:
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Dipendenti", andTextColor: UIColor.white.withAlphaComponent(0.6), andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .normal)
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Dipendenti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .selected)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_dipendenti"), for: .normal)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_dipendenti_selected"), for: .selected)
         case 2:
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Clienti", andTextColor: UIColor.white.withAlphaComponent(0.6), andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .normal)
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Clienti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .selected)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_clienti"), for: .normal)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_clienti_selected"), for: .selected)
         case 3:
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Prodotti", andTextColor: UIColor.white.withAlphaComponent(0.6), andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .normal)
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Prodotti", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .selected)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_prodotti"), for: .normal)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_prodotti_selected"), for: .selected)
         case 4:
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Statistiche", andTextColor: UIColor.white.withAlphaComponent(0.6), andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .normal)
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Statistiche", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .selected)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_statistiche"), for: .normal)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_statistiche_selected"), for: .selected)
         case 5:
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Bilancio", andTextColor: UIColor.white.withAlphaComponent(0.6), andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .normal)
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Bilancio", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .selected)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_bilancio"), for: .normal)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_bilancio_selected"), for: .selected)
         case 6:
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Impostazioni", andTextColor: UIColor.white.withAlphaComponent(0.6), andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .normal)
            menuBtn.setAttributedTitle(UILabel.attributedString(withText: "Impostazioni", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 20.0)!, andCharacterSpacing: 0.5), for: .selected)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_impostazioni"), for: .normal)
            menuBtn.setImage(#imageLiteral(resourceName: "icona_menu_impostazioni_selected"), for: .selected)
         default:
            break
         }
         
         menuBtn.isSelected = false
      }
      
      self.revealMenuActionButtons[0].isSelected = true
      self.currentRevealMenuActionSelected = 0
      self.isRevealMenuOpen = false
      
   }
   
   @objc func revealMenuPanGestureRecognized(sender: UIPanGestureRecognizer) {
      
      switch sender.state {
      case .began:
         if self.isRevealMenuOpen {
            
         } else {
            self.revealMenuActionsStackView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
         }
      case .changed:
         
         if self.isRevealMenuOpen {
            
            guard ((self.currentPanGestureTranslationX + sender.translation(in: self.view).x) < 0 || self.containerViewLeadingAnchor.constant < self.revealMenuWidth) && ((self.currentPanGestureTranslationX + sender.translation(in: self.view).x) > -self.revealMenuWidth || self.containerViewLeadingAnchor.constant > 0) else {
               return
            }
            
            if (self.currentPanGestureTranslationX + sender.translation(in: self.view).x) > 0 {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               self.containerViewLeadingAnchor.constant = self.revealMenuWidth
               self.containerViewHeightEqualToViewAnchor.constant = -self.revealMenuVerticalPadding
               self.revealMenuActionsStackView.alpha = 1.0
               self.revealMenuActionsStackView.transform = CGAffineTransform.identity
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            } else if (self.currentPanGestureTranslationX + sender.translation(in: self.view).x) < -self.revealMenuWidth {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               self.containerViewLeadingAnchor.constant = 0.0
               self.containerViewHeightEqualToViewAnchor.constant = 0.0
               self.revealMenuActionsStackView.alpha = 0.0
               self.revealMenuActionsStackView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            } else {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               let progress: CGFloat = 1 - abs(self.currentPanGestureTranslationX / self.revealMenuWidth)
               print(progress)
               
               self.containerViewLeadingAnchor.constant = self.revealMenuWidth * progress
               self.containerViewHeightEqualToViewAnchor.constant = -(progress * self.revealMenuVerticalPadding)
               self.revealMenuActionsStackView.alpha = progress
               self.revealMenuActionsStackView.transform = CGAffineTransform(scaleX: 1.4 - 0.4 * progress, y: 1.4 - 0.4 * progress)
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            }
            
         } else {
            
            guard ((self.currentPanGestureTranslationX + sender.translation(in: self.view).x) > 0 || self.containerViewLeadingAnchor.constant > 0) && ((self.currentPanGestureTranslationX + sender.translation(in: self.view).x) < self.revealMenuWidth || self.containerViewLeadingAnchor.constant < self.revealMenuWidth) else {
               return
            }
            
            if (self.currentPanGestureTranslationX + sender.translation(in: self.view).x) > self.revealMenuWidth {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               self.containerViewLeadingAnchor.constant = self.revealMenuWidth
               self.containerViewHeightEqualToViewAnchor.constant = -self.revealMenuVerticalPadding
               self.revealMenuActionsStackView.alpha = 1.0
               self.revealMenuActionsStackView.transform = CGAffineTransform.identity
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            } else if (self.currentPanGestureTranslationX + sender.translation(in: self.view).x) < 0 {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               self.containerViewLeadingAnchor.constant = 0.0
               self.containerViewHeightEqualToViewAnchor.constant = 0.0
               self.revealMenuActionsStackView.alpha = 0.0
               self.revealMenuActionsStackView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            } else {
               
               self.currentPanGestureTranslationX += sender.translation(in: self.view).x
               let progress: CGFloat = self.currentPanGestureTranslationX / self.revealMenuWidth
               print(progress)
               
               self.containerViewLeadingAnchor.constant = self.currentPanGestureTranslationX
               self.containerViewHeightEqualToViewAnchor.constant = -(progress * self.revealMenuVerticalPadding)
               self.revealMenuActionsStackView.alpha = progress
               self.revealMenuActionsStackView.transform = CGAffineTransform(scaleX: 1.4 - 0.4 * progress, y: 1.4 - 0.4 * progress)
               sender.setTranslation(CGPoint.zero, in: self.view)
               
            }
            
         }
         
      case .ended:
         
         if (self.isRevealMenuOpen && self.currentPanGestureTranslationX < -(self.revealMenuWidth * 40/100.0)) || (!self.isRevealMenuOpen && self.currentPanGestureTranslationX < (self.revealMenuWidth * 40/100.0)) {
            
            self.containerViewLeadingAnchor.constant = 0.0
            self.containerViewHeightEqualToViewAnchor.constant = 0.0
            UIView.animate(withDuration: 0.75, animations: {
               self.view.layoutIfNeeded()
               self.revealMenuActionsStackView.alpha = 0.0
               self.revealMenuActionsStackView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            }, completion: { (success) in
               if success {
                  sender.setTranslation(CGPoint.zero, in: self.view)
                  self.currentPanGestureTranslationX = 0.0
                  self.isRevealMenuOpen = self.containerViewLeadingAnchor.constant != 0
               }
            })
            
         } else {
            
            self.containerViewLeadingAnchor.constant = self.revealMenuWidth
            self.containerViewHeightEqualToViewAnchor.constant = -self.revealMenuVerticalPadding
            UIView.animate(withDuration: 0.75, animations: {
               self.view.layoutIfNeeded()
               self.revealMenuActionsStackView.alpha = 1.0
               self.revealMenuActionsStackView.transform = CGAffineTransform.identity
            }, completion: { (success) in
               if success {
                  sender.setTranslation(CGPoint.zero, in: self.view)
                  self.currentPanGestureTranslationX = 0.0
                  self.isRevealMenuOpen = self.containerViewLeadingAnchor.constant != 0
               }
            })
            
         }
         
      default:
         break
      }
      
   }
   
   @IBAction func revealMenuActionButtonPressed(sender: UIButton) {
      guard sender.tag != self.currentRevealMenuActionSelected else {
         return
      }
      
      for action in self.revealMenuActionButtons {
         action.isSelected = false
      }
      sender.isSelected = true
      self.currentRevealMenuActionSelected = sender.tag
      self.closeRevealMenu()
   }
   
}

extension RevealMenuViewController: RevealMenuDelegate {
   
   func openRevealMenu() {
      
      guard !self.isRevealMenuOpen else {
         return
      }
      
      self.revealMenuActionsStackView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
      
      self.containerViewLeadingAnchor.constant = self.revealMenuWidth
      self.containerViewHeightEqualToViewAnchor.constant = -self.revealMenuVerticalPadding
      UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 14.0, options: [], animations: {
         self.view.layoutIfNeeded()
         self.revealMenuActionsStackView.alpha = 1.0
         self.revealMenuActionsStackView.transform = CGAffineTransform.identity
      }) { (success) in
         if success {
            self.isRevealMenuOpen = true
         }
      }
      
   }
   
   @objc func closeRevealMenu() {
      guard self.isRevealMenuOpen else {
         return
      }
      
      self.containerViewLeadingAnchor.constant = 0.0
      self.containerViewHeightEqualToViewAnchor.constant = 0.0
      UIView.animate(withDuration: 0.7, animations: {
         self.view.layoutIfNeeded()
         self.revealMenuActionsStackView.alpha = 0.0
         self.revealMenuActionsStackView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
      }) { (success) in
         if success {
            self.isRevealMenuOpen = false
         }
      }
   }
   
   func enableSmallMousePad() {
      self.smallMousePad.isUserInteractionEnabled = true
   }
   
   func disableSmallMousePad() {
      self.smallMousePad.isUserInteractionEnabled = false
   }
   
}
