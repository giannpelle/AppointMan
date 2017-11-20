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
   
   // AGENDA CONTEXT
   @IBOutlet weak var agendaContextStackView: UIStackView!
   @IBOutlet weak var accessoryTimetableAgendaScrollView: UIScrollView!
   @IBOutlet weak var accessoryEmployeesAgendaScrollView: UIScrollView!
   @IBOutlet weak var agendaScrollView: UIScrollView!
   
   // DATE PICKER
   @IBOutlet weak var calendarDatePickerView: GPCalendarDatePickerView!
   @IBOutlet weak var calendarDatePickerViewTrailingAnchor: NSLayoutConstraint!
   
   // FILTRA APPUNTAMENTI controller
   @IBOutlet weak var filterAppointmentsContainerView: UIView!
   @IBOutlet weak var filterAppointmentsContainerViewLeadingAnchor: NSLayoutConstraint!
   
   // BOTTOM BAR
   @IBOutlet weak var bottomBarView: UIView!
   @IBOutlet weak var calendarDatePickerButton: UIButton!
   @IBOutlet weak var filterButton: UIButton!
   
   var numberOfEmployees: Int = 5
   var startHourToDisplay: Int = 6
   var endHourToDisplay: Int = 22
   weak var revealMenuDelegate: RevealMenuDelegate?
   var currentPanGestureTranslationX: CGFloat = 0.0
   var isFilterAppointmentsContainerViewOpen: Bool = false
   var timetableAccessoryStackView: UIStackView?
   
   var numberOfHoursToDisplay: Int {
      return endHourToDisplay - startHourToDisplay + 1
   }
   
   var isBubbleMenuOpen: Bool = false {
      didSet {
         self.triangolinoDisclosureIndicatorButton.setImage(self.isBubbleMenuOpen ? #imageLiteral(resourceName: "triangolino_close_disclosure_indicator") : #imageLiteral(resourceName: "triangolino_open_disclosure_indicator"), for: .normal)
      }
   }
   
   var isCalendarDatePickerViewOpen: Bool = false {
      didSet {
         if self.isCalendarDatePickerViewOpen {
            self.revealMenuDelegate?.disableSmallMousePad()
         } else {
            self.revealMenuDelegate?.enableSmallMousePad()
         }
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.applyTypography()
      self.setupUI()
      
      //FIX ME: shadow needs refactoring
//      self.bottomBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
//      self.bottomBarView.layer.shadowOpacity = 1.0
//      self.bottomBarView.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
//      self.bottomBarView.layer.shadowRadius = 24.0
//      self.bottomBarView.layer.masksToBounds = false
   }
   
   func applyTypography() {
      self.todayNumberLabel.attributedText = UILabel.attributedString(withText: "\(Calendar.current.component(.day, from: Date()))", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 26)!, andCharacterSpacing: -1.46)
      let monthFormatter = DateFormatter()
      monthFormatter.dateFormat = "MMMM"
      monthFormatter.locale = Locale(identifier: "it_IT")
      let yearFormatter = DateFormatter()
      yearFormatter.dateFormat = "yyyy"
      yearFormatter.locale = Locale(identifier: "it_IT")
      self.todayMonthLabel.attributedText = UILabel.attributedString(withText: monthFormatter.string(from: Date()).uppercased() + " " + yearFormatter.string(from: Date()), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 11)!, andCharacterSpacing: 1.38)
      
      self.cancelButton.setAttributedTitle(UILabel.attributedString(withText: "Annulla", andTextColor: UIColor.white.withAlphaComponent(0.5), andFont: UIFont.init(name: "SFUIText-Bold", size: 10.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
      self.takeNoteButton.setAttributedTitle(UILabel.attributedString(withText: "Annota", andTextColor: UIColor.white.withAlphaComponent(0.5), andFont: UIFont.init(name: "SFUIText-Bold", size: 10.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
      self.newAppointmentButton.setAttributedTitle(UILabel.attributedString(withText: "Nuovo", andTextColor: UIColor.white.withAlphaComponent(0.5), andFont: UIFont.init(name: "SFUIText-Bold", size: 10.0)!, andCharacterSpacing: nil, isCentered: true), for: .normal)
   }
   
   func setupUI() {
      
      self.bubbleMenuView.layer.roundCorners(corners: [.topLeft, .bottomLeft], radius: self.bubbleMenuView.bounds.size.height / 2.0, viewBounds: bubbleMenuView.bounds)
      let bubbleMenuViewPanGestureRec = UIPanGestureRecognizer(target: self, action: #selector(self.bubbleMenuPanGestureRecognized(sender:)))
      self.bubbleMenuView.addGestureRecognizer(bubbleMenuViewPanGestureRec)
      self.triangolinoDisclosureIndicatorButton.addTarget(self, action: #selector(self.bubbleMenuDisclosureButtonPressed(sender:)), for: .touchUpInside)
      
      self.cancelButton.setImage(#imageLiteral(resourceName: "icona_agenda_annulla"), for: .normal)
      self.cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed(sender:)), for: .touchUpInside)
      
      self.takeNoteButton.setImage(#imageLiteral(resourceName: "icona_agenda_annota"), for: .normal)
      self.takeNoteButton.addTarget(self, action: #selector(self.takeNoteButtonPressed(sender:)), for: .touchUpInside)
      
      self.newAppointmentButton.setImage(#imageLiteral(resourceName: "icona_agenda_nuovo"), for: .normal)
      self.newAppointmentButton.addTarget(self, action: #selector(self.newAppointmentButtonPressed(sender:)), for: .touchUpInside)
      
      self.setupAgenda()
      
      self.calendarDatePickerButton.addTarget(self, action: #selector(self.calendarDatePickerButtonPressed(sender:)), for: .touchUpInside)
      self.calendarDatePickerButton.setBackgroundColor(color: UIColor.amDarkBlue, forState: .normal)
      self.calendarDatePickerButton.setBackgroundColor(color: UIColor.amBlue, forState: .selected)
      
      self.filterButton.addTarget(self, action: #selector(self.filterButtonPressed(sender:)), for: .touchUpInside)
      self.filterButton.setBackgroundColor(color: UIColor.amDarkBlue, forState: .normal)
      self.filterButton.setBackgroundColor(color: UIColor.amBlue, forState: .selected)
   }
   
   func setupAgenda() {
      self.setupAccessoryTimetable()
      self.setupAccessoryEmployees()
      
      let agendaView = AgendaView(frame: CGRect(x: 0.0, y: 0.0, width: 240.0 * 5, height: 16 * 120.0))
      agendaView.backgroundColor = UIColor.amBlue
      agendaView.delegate = self
      self.agendaScrollView.contentSize = agendaView.bounds.size
      self.agendaScrollView.delegate = self
      self.agendaScrollView.layer.borderWidth = 2.0
      self.agendaScrollView.layer.borderColor = UIColor.amDarkBlue.withAlphaComponent(0.3).cgColor
      self.agendaScrollView.bounces = false
      self.agendaScrollView.showsVerticalScrollIndicator = false
      self.agendaScrollView.showsHorizontalScrollIndicator = false
      self.agendaScrollView.addSubview(agendaView)
      agendaView.translatesAutoresizingMaskIntoConstraints = false
      agendaView.topAnchor.constraint(equalTo: self.agendaScrollView.topAnchor, constant: 0.0).isActive = true
      agendaView.leadingAnchor.constraint(equalTo: self.agendaScrollView.leadingAnchor, constant: 0.0).isActive = true
      agendaView.widthAnchor.constraint(equalToConstant: agendaView.bounds.size.width).isActive = true
      agendaView.heightAnchor.constraint(equalToConstant: agendaView.bounds.size.height).isActive = true
   }
   
   func setupAccessoryTimetable() {
      self.accessoryTimetableAgendaScrollView.showsVerticalScrollIndicator = false
      self.accessoryTimetableAgendaScrollView.isScrollEnabled = false
      self.accessoryTimetableAgendaScrollView.contentSize = CGSize(width: self.accessoryTimetableAgendaScrollView.bounds.size.width, height: Const.hourUnitHeight * self.numberOfHoursToDisplay + Const.quarterHourUnitHeight)
      
      var hourLabels = [UIView]()
      for index in 0...(self.numberOfHoursToDisplay * 4 + 1) {
         let myLabel = UILabel()
         myLabel.widthAnchor.constraint(equalToConstant: self.accessoryTimetableAgendaScrollView.bounds.size.width).isActive = true
         myLabel.heightAnchor.constraint(equalToConstant: Const.quarterHourUnitHeight).isActive = true
         myLabel.attributedText = UILabel.attributedString(withText: self.timetableStrigForLabel(at: index), andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil, isCentered: true)
         myLabel.alpha = index % 4 == 2 ? 1.0 : 0.0
         hourLabels.append(myLabel)
      }
      
      let hoursStackView = UIStackView(arrangedSubviews: hourLabels)
      hoursStackView.axis = .vertical
      hoursStackView.alignment = .center
      hoursStackView.spacing = 0.0
      hoursStackView.distribution = .fill
      self.timetableAccessoryStackView = hoursStackView
      
      self.accessoryTimetableAgendaScrollView.addSubview(hoursStackView)
      hoursStackView.translatesAutoresizingMaskIntoConstraints = false
      hoursStackView.leadingAnchor.constraint(equalTo: self.accessoryTimetableAgendaScrollView.leadingAnchor, constant: 0.0).isActive = true
      hoursStackView.topAnchor.constraint(equalTo: self.accessoryTimetableAgendaScrollView.topAnchor, constant: 0.0).isActive = true
      hoursStackView.widthAnchor.constraint(equalToConstant: self.accessoryTimetableAgendaScrollView.bounds.size.width).isActive = true
      hoursStackView.heightAnchor.constraint(equalToConstant: Const.hourUnitHeight * self.numberOfHoursToDisplay + Const.quarterHourUnitHeight).isActive = true
   }
   
   func setupAccessoryEmployees() {
      self.accessoryEmployeesAgendaScrollView.showsHorizontalScrollIndicator = false
      self.accessoryEmployeesAgendaScrollView.isScrollEnabled = false
      self.accessoryEmployeesAgendaScrollView.contentSize = CGSize(width: 240.0 * 5, height: self.accessoryEmployeesAgendaScrollView.bounds.size.height)
      
      var employeeButtons = [ThumbnailVerticallyStaticButton]()
      for _ in 0..<5 {
         let myButton = ThumbnailVerticallyStaticButton()
         myButton.widthAnchor.constraint(equalToConstant: 240.0).isActive = true
         myButton.heightAnchor.constraint(equalToConstant: 92.0).isActive = true
         myButton.setup(withImage: #imageLiteral(resourceName: "thumbnail_1"), andText: "Luciano")
         employeeButtons.append(myButton)
      }
      
      let employeesStackView = UIStackView(arrangedSubviews: employeeButtons)
      employeesStackView.axis = .horizontal
      employeesStackView.distribution = .fill
      employeesStackView.spacing = 0.0
      employeesStackView.alignment = .center
      
      self.accessoryEmployeesAgendaScrollView.addSubview(employeesStackView)
      employeesStackView.translatesAutoresizingMaskIntoConstraints = false
      employeesStackView.leadingAnchor.constraint(equalTo: self.accessoryEmployeesAgendaScrollView.leadingAnchor, constant: 0.0).isActive = true
      employeesStackView.topAnchor.constraint(equalTo: self.accessoryEmployeesAgendaScrollView.topAnchor, constant: 0.0).isActive = true
      employeesStackView.widthAnchor.constraint(equalToConstant: 240.0 * 5).isActive = true
      employeesStackView.heightAnchor.constraint(equalToConstant: self.accessoryEmployeesAgendaScrollView.bounds.size.height).isActive = true
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      if let touch = touches.first, let view = touch.view, view == self.bubbleMenuActionsStackView || touch.view == self.bubbleMenuView {} else {
         self.closeBubbleMenu()
      }
      if let touch = touches.first, let view = touch.view, view == self.filterAppointmentsContainerView || touch.view == self.filterButton {} else {
         self.closeFilterAppointmentsContainerView()
      }
      if let touch = touches.first, let view = touch.view, view == self.calendarDatePickerView || touch.view == self.calendarDatePickerButton {} else {
         self.closeCalendarDatePickerView()
      }
   }
   
   func cleanViewControllerView() {
      self.closeBubbleMenu()
      self.closeFilterAppointmentsContainerView()
      self.closeCalendarDatePickerView()
   }
   
   @IBAction func hamburgerMenuButtonPressed(sender: UIButton) {
      self.cleanViewControllerView()
      self.revealMenuDelegate?.openRevealMenu()
   }
   
   func timetableStrigForLabel(at index: Int) -> String {
      let hour = (index + 2) / 4 + self.startHourToDisplay - 1
      switch index % 4 {
      case 0:
         return "\(hour):30"
      case 1:
         return "\(hour):45"
      case 2:
         return "\(hour):00"
      case 3:
         return "\(hour):15"
      default:
         return ""
      }
   }
   
}

// MARK: UIScrollViewDelegate

extension AgendaViewController: UIScrollViewDelegate {
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      self.accessoryTimetableAgendaScrollView.contentOffset.y = scrollView.contentOffset.y
      self.accessoryEmployeesAgendaScrollView.contentOffset.x = scrollView.contentOffset.x
   }
}

// MARK: AgendaViewDelegate

extension AgendaViewController: AgendaViewDelegate {
   func highlightAccessoryTimetable(at index: Int) {
      
      if let hourLabels = self.timetableAccessoryStackView?.arrangedSubviews as? [UILabel] {
         for (index, hourLabel) in hourLabels.enumerated() {
            hourLabel.attributedText = UILabel.attributedString(withText: hourLabel.text ?? "", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil, isCentered: true)
            if index % 4 == 2 { continue }
            hourLabel.alpha = 0.0
         }
         
         hourLabels[index].attributedText = UILabel.attributedString(withText: hourLabels[index].text ?? "", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Bold", size: 16.0)!, andCharacterSpacing: nil, isCentered: true)
         hourLabels[index].alpha = 1.0
         
      }
   }
   
   func resetHighlightStateOnAccessoryTimetable() {
      if let hourLabels = self.timetableAccessoryStackView?.arrangedSubviews as? [UILabel] {
         for (index, hourLabel) in hourLabels.enumerated() {
            hourLabel.attributedText = UILabel.attributedString(withText: hourLabels[index].text ?? "", andTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil, isCentered: true)
            if index % 4 == 2 { continue }
            hourLabel.alpha = 0.0
         }
      }
   }
}

// MARK: CalendarDatePickerView handler

extension AgendaViewController {
   
   @objc func calendarDatePickerButtonPressed(sender: UIButton) {
      if self.isCalendarDatePickerViewOpen {
         self.closeCalendarDatePickerView()
      } else {
         self.openCalendarDatePickerView()
      }
   }
   
   func openCalendarDatePickerView() {
      guard !self.isCalendarDatePickerViewOpen else {
         return
      }
      
      self.calendarDatePickerView.currentMonthIndex = Calendar.current.dateComponents([.month], from: Date(), to: self.calendarDatePickerView.currentDateSelected).month!
      self.calendarDatePickerViewTrailingAnchor.constant = 292.0
      UIView.animate(withDuration: 0.6, animations: {
         self.view.layoutIfNeeded()
      }) { (success) in
         self.isCalendarDatePickerViewOpen = true
         self.calendarDatePickerButton.isSelected = true
      }
   }
   
   func closeCalendarDatePickerView() {
      guard self.isCalendarDatePickerViewOpen else {
         return
      }
      
      self.calendarDatePickerViewTrailingAnchor.constant = 0.0
      UIView.animate(withDuration: 0.6, animations: {
         self.view.layoutIfNeeded()
      }) { (success) in
         self.isCalendarDatePickerViewOpen = false
         self.calendarDatePickerButton.isSelected = false
      }
   }
}

// MARK: FilterVC handler

extension AgendaViewController {
   
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
   
   @objc func filterButtonPressed(sender: UIButton) {
      if self.isFilterAppointmentsContainerViewOpen {
         self.closeFilterAppointmentsContainerView()
      } else {
         self.openFilterAppointmentsContainerView()
      }
   }
}

// MARK: BubbleMenu handler

extension AgendaViewController {
   
   @objc func cancelButtonPressed(sender: UIButton) {
      
   }
   
   @objc func takeNoteButtonPressed(sender: UIButton) {
      self.closeBubbleMenu()
      let takeNotesVC = UIStoryboard.takeNotesVC()
      self.present(takeNotesVC, animated: true, completion: nil)
   }
   
   @objc func newAppointmentButtonPressed(sender: UIButton) {
      
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
   
   @objc func bubbleMenuDisclosureButtonPressed(sender: UIButton) {
      
      if self.isBubbleMenuOpen {
         self.closeBubbleMenu()
      } else {
         self.openBubbleMenu()
      }
      
   }
}
