//
//  HomeViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/11/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate {
   func updateMasterWidth(withPercentCompletion percentCompletion: CGFloat) -> Void
   func openCloseMasterAnimated(shouldOpenView: Bool, time: Double?) -> Void
   func masterWidth() -> CGFloat
   func showAddAppointmentPopoverVC() -> Void
   func showOverlayView() -> Void
}

class HomeViewController: UIViewController {
   
   @IBOutlet weak var filterIndicatorView: UIView!
   @IBOutlet weak var hourScrollView: UIScrollView!
   @IBOutlet weak var employeeScrollView: UIScrollView!
   @IBOutlet weak var calendarScrollView: UIScrollView!
   
   var delegate: HomeViewControllerDelegate?
   var isFilterOpen: Bool {
      return Int(self.view.bounds.size.width) == Int(Const.detailMaxWidth)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let panGestureRecog = UIPanGestureRecognizer(target: self, action: #selector(self.updateMasterWidthWhileDragging))
      self.filterIndicatorView.addGestureRecognizer(panGestureRecog)
      
      self.setupHourScrollView()
      self.setupEmployeeScrollView()
      self.setupCalendarScrollView()
      
   }
   
   func setupHourScrollView() {
      
      self.hourScrollView.contentSize = CGSize(width: Const.hourHeaderWidth, height: Const.hourUnitHeight * (Const.numberOfMorningHours + Const.numberOfAfternoonHours) + Const.hourScrollViewInset + Const.halfdayBreakSpacing)
      
      let hourScrollViewTopInsetView = UIView()
      hourScrollViewTopInsetView.widthAnchor.constraint(equalToConstant: Const.hourHeaderWidth).isActive = true
      hourScrollViewTopInsetView.heightAnchor.constraint(equalToConstant: Const.hourScrollViewInset).isActive = true
      hourScrollViewTopInsetView.backgroundColor = UIColor.clear
      
      let halfdayBreakViewSeparator = UIView()
      halfdayBreakViewSeparator.widthAnchor.constraint(equalToConstant: Const.hourHeaderWidth).isActive = true
      halfdayBreakViewSeparator.heightAnchor.constraint(equalToConstant: Const.halfdayBreakSpacing).isActive = true
      halfdayBreakViewSeparator.backgroundColor = UIColor.clear
      
      var morningHourLabels = [UIView]()
      for index in 0...(Int(Const.numberOfMorningHours) - 1) {
         let myLabel = UILabel()
         myLabel.widthAnchor.constraint(equalToConstant: Const.hourHeaderWidth).isActive = true
         myLabel.heightAnchor.constraint(equalToConstant: Const.hourUnitHeight).isActive = true
         myLabel.font = UIFont.systemFont(ofSize: 20)
         myLabel.text = "\(index)"
         myLabel.textColor = UIColor.white
         myLabel.backgroundColor = UIColor.clear
         myLabel.textAlignment = .center
         morningHourLabels.append(myLabel)
      }
      
      var afternoonHourLabels = [UIView]()
      for index in 0...(Int(Const.numberOfAfternoonHours) - 1) {
         let myLabel = UILabel()
         myLabel.widthAnchor.constraint(equalToConstant: Const.hourHeaderWidth).isActive = true
         myLabel.heightAnchor.constraint(equalToConstant: Const.hourUnitHeight).isActive = true
         myLabel.font = UIFont.systemFont(ofSize: 20)
         myLabel.text = "\(index + Int(Const.numberOfMorningHours))"
         myLabel.textColor = UIColor.white
         myLabel.backgroundColor = UIColor.clear
         myLabel.textAlignment = .center
         afternoonHourLabels.append(myLabel)
      }
      let arrangedSubview = [hourScrollViewTopInsetView] + morningHourLabels + [halfdayBreakViewSeparator] + afternoonHourLabels
      let hourStackView = UIStackView(arrangedSubviews: arrangedSubview)
      hourStackView.axis = .vertical
      hourStackView.alignment = .center
      hourStackView.spacing = 0.0
      hourStackView.distribution = .fill
      
      self.hourScrollView.addSubview(hourStackView)
      hourStackView.translatesAutoresizingMaskIntoConstraints = false
      hourStackView.leadingAnchor.constraint(equalTo: self.hourScrollView.leadingAnchor, constant: 0.0).isActive = true
      hourStackView.topAnchor.constraint(equalTo: self.hourScrollView.topAnchor, constant: 0.0).isActive = true
      hourStackView.widthAnchor.constraint(equalToConstant: Const.hourHeaderWidth).isActive = true
      hourStackView.heightAnchor.constraint(equalToConstant: Const.hourUnitHeight * (Const.numberOfMorningHours + Const.numberOfAfternoonHours) + Const.hourScrollViewInset + Const.halfdayBreakSpacing).isActive = true
   }
   
   func setupEmployeeScrollView() {
      
      self.employeeScrollView.contentSize = CGSize(width: (Const.employeeHeaderWidth) * CGFloat(Const.numberOfEmployees) + Const.employeeColomnSpacing * CGFloat(Const.numberOfEmployees - 1), height: Const.employeeHeaderHeight)
      
      var employeeLabels = [UILabel]()
      for index in 0...(Int(Const.numberOfEmployees) - 1) {
         let myLabel = UILabel()
         myLabel.widthAnchor.constraint(equalToConstant: Const.employeeHeaderWidth).isActive = true
         myLabel.heightAnchor.constraint(equalToConstant: Const.employeeHeaderHeight).isActive = true
         myLabel.font = UIFont.systemFont(ofSize: 20)
         myLabel.text = "\(Const.employees[index])"
         myLabel.textColor = UIColor.white
         myLabel.backgroundColor = UIColor.clear
         myLabel.textAlignment = .center
         employeeLabels.append(myLabel)
      }
      let employeeStackView = UIStackView(arrangedSubviews: employeeLabels)
      employeeStackView.axis = .horizontal
      employeeStackView.alignment = .center
      employeeStackView.spacing = Const.employeeColomnSpacing
      employeeStackView.distribution = .fillEqually
      
      
      self.employeeScrollView.addSubview(employeeStackView)
      employeeStackView.translatesAutoresizingMaskIntoConstraints = false
      employeeStackView.widthAnchor.constraint(equalToConstant: (Const.employeeHeaderWidth) * CGFloat(Const.numberOfEmployees) + Const.employeeColomnSpacing * CGFloat(Const.numberOfEmployees - 1)).isActive = true
      employeeStackView.leadingAnchor.constraint(equalTo: employeeScrollView.leadingAnchor, constant: 0.0).isActive = true
      employeeStackView.heightAnchor.constraint(equalToConstant: Const.employeeHeaderHeight).isActive = true
      employeeStackView.topAnchor.constraint(equalTo: employeeScrollView.topAnchor, constant: 0.0).isActive = true
   }
   
   func setupCalendarScrollView() {
      
      self.calendarScrollView.contentSize = CGSize(width: (Const.employeeHeaderWidth) * CGFloat(Const.numberOfEmployees) + Const.employeeColomnSpacing * CGFloat(Const.numberOfEmployees - 1), height: Const.hourUnitHeight * CGFloat(Const.numberOfMorningHours + Const.numberOfAfternoonHours) + Const.halfdayBreakSpacing)
      self.calendarScrollView.delegate = self
      
      guard let calendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as? CalendarView else {
         return
      }
      calendarScrollView.addSubview(calendarView)
      calendarView.translatesAutoresizingMaskIntoConstraints = false
      calendarView.backgroundColor = UIColor.clear
      calendarView.leadingAnchor.constraint(equalTo: calendarScrollView.leadingAnchor, constant: 0.0).isActive = true
      //calendarView.centerYAnchor.constraint(equalTo: calendarScrollView.centerYAnchor, constant: 0.0).isActive = true
      calendarView.widthAnchor.constraint(equalToConstant: (Const.employeeHeaderWidth) * CGFloat(Const.numberOfEmployees) + Const.employeeColomnSpacing * CGFloat(Const.numberOfEmployees - 1)).isActive = true
      calendarView.topAnchor.constraint(equalTo: calendarScrollView.topAnchor, constant: 0.0).isActive = true
      calendarView.heightAnchor.constraint(equalToConstant: Const.hourUnitHeight * CGFloat(Const.numberOfMorningHours + Const.numberOfAfternoonHours) + Const.halfdayBreakSpacing).isActive = true
   }
   
   var translationInView: CGPoint = CGPoint.zero
   
   func updateMasterWidthWhileDragging(sender: UIPanGestureRecognizer) {
      
      let deltaTranslationInView = sender.translation(in: self.view)
      translationInView.x += deltaTranslationInView.x
      let percentCompletion = ((delegate?.masterWidth())! + deltaTranslationInView.x) / Const.masterMaxWidth
      
      
      switch sender.state {
      case .began, .changed:
         self.delegate?.updateMasterWidth(withPercentCompletion: percentCompletion)
      case .ended:
         if translationInView.x > 0 {
            // apri tutto
            self.delegate?.openCloseMasterAnimated(shouldOpenView: percentCompletion >= 0.3, time: nil)
         }
         
         if translationInView.x < 0 {
            //chiudi tutto
            self.delegate?.openCloseMasterAnimated(shouldOpenView: !(percentCompletion <= 0.7), time: nil)
         }
      default:
         break
      }
      
      sender.setTranslation(CGPoint.zero, in: self.view)
   }
}

extension HomeViewController {
   
   @IBAction func filterBarButtonItemPressed(sender: UIBarButtonItem) {
      
      // Int to round the values and avoid the == failure
      self.delegate?.openCloseMasterAnimated(shouldOpenView: !self.isFilterOpen, time: nil)
      
   }
   
   @IBAction func addAppointmentButtonPressed(sender: UIBarButtonItem) {
      self.delegate?.showOverlayView()
      self.delegate?.showAddAppointmentPopoverVC()

   }
   
}

extension HomeViewController: UICollectionViewDelegate {
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
      var isStickyHeader = false
      
      if scrollView.contentOffset.x <= 0.0 && scrollView.contentOffset.y <= 0.0 {
         scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
         self.employeeScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
         self.hourScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
         return
      }
      
      if scrollView.contentOffset.x <= 0.0 {
         scrollView.contentOffset.x = 0.0
         self.employeeScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
         self.hourScrollView.setContentOffset(CGPoint(x: 0.0, y: scrollView.contentOffset.y), animated: false)
         isStickyHeader = true
      }
      
      if scrollView.contentOffset.y <= 0.0 {
         scrollView.contentOffset.y = 0.0
         self.hourScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
         self.employeeScrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0.0), animated: false)
         isStickyHeader = true
      }
      
      if isStickyHeader { return }
      
      self.hourScrollView.setContentOffset(CGPoint(x: 0.0, y: scrollView.contentOffset.y), animated: false)
      self.employeeScrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0.0), animated: false)
      
   }
}
