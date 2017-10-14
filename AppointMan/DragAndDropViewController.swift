//
//  DragAndDropViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/31/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class DragAndDropViewController: UIViewController {
   
   @IBOutlet weak var hourScrollView: UIScrollView!
   @IBOutlet weak var employeeScrollView: UIScrollView!
   @IBOutlet weak var calendarScrollView: UIScrollView!
   
   var appointmentViews: [UIView] = [] {
      didSet {
         
         let group = DispatchGroup()
         
         for (index, view) in self.appointmentViews.enumerated() {
            if view.frame.origin.x != self.viewPositions[index] {
               
               for layer in self.view.layer.sublayers! {
                  if layer.name == "selectionLayer" {
                     layer.removeFromSuperlayer()
                  }
               }
               
               group.enter()
               
               UIView.animate(withDuration: 0.5, animations: {
                  view.frame.origin.x = self.viewPositions[index]
               }, completion: {
                  (completed) in
                  if (completed) {
                     
                     group.leave()
                     
                     for layer in self.view.layer.sublayers! {
                        if layer.name == "selectionLayer" {
                           
                        } else {
                           print("COUNT INTERNAL")
                           if let firstViewSelected = self.selectedAppoitmentViews.first, self.selectedAppoitmentViews.count == 1 {
                              let selectionLayer = CALayer()
                              selectionLayer.name = "selectionLayer"
                              selectionLayer.borderColor = UIColor.orange.cgColor
                              selectionLayer.borderWidth = 6.0
                              selectionLayer.frame = firstViewSelected.frame
                              self.view.layer.addSublayer(selectionLayer)
                           } else if let firstViewSelected = self.selectedAppoitmentViews.first, let lastViewSelected = self.selectedAppoitmentViews.last, self.selectedAppoitmentViews.count > 1 {
                              let selectionLayer = CALayer()
                              selectionLayer.name = "selectionLayer"
                              selectionLayer.borderColor = UIColor.orange.cgColor
                              selectionLayer.borderWidth = 6.0
                              selectionLayer.frame = CGRect(x: firstViewSelected.frame.origin.x, y: firstViewSelected.frame.origin.y, width: lastViewSelected.frame.maxX + 12.0, height: firstViewSelected.frame.size.height)
                              //selectionLayer.frame = CGRect(x: firstViewSelected.frame.origin.x, y: firstViewSelected.frame.origin.y, width: firstViewSelected.frame.size.width + (Const.employeeHeaderWidth + (Const.employeeColomnSpacing * 3.0) * CGFloat(self.selectedAppoitmentViews.count) - 1), height: firstViewSelected.frame.size.height)
                              self.view.layer.addSublayer(selectionLayer)
                           }
                        }
                     }
                  }
               })
            }
         }
         
         group.notify(queue: DispatchQueue.main) { 
            print("WOOOOW")
         }
      }
   }
   var viewPositions: [CGFloat] = []
//   lazy var appointmentViewPositions: [CGFloat] = {
//      var positions: [CGFloat] = []
//      for view in self.appointmentViews {
//         positions.append(view.frame.origin.x)
//      }
//      return positions
//   }()
   var lastItemCorrect: Int = 0
   
   var selectedAppoitmentViews: [UIView] = [] {
      didSet {
         
//         for (index, view) in selectedAppoitmentViews.enumerated() {
//            if view.frame.origin.x != self.viewPositions[index] {
//               UIView.animate(withDuration: 0.5, animations: { 
//                  view.frame.origin.x = self.viewPositions[index]
//               })
//               
//               for ind in self.lastItemCorrect..<self.appointmentViews.index(of: view)! {
//                  UIView.animate(withDuration: 0.5, animations: { 
//                     self.appointmentViews[ind].frame.origin.x = self.viewPositions[self.selectedAppoitmentViews.count >= index ? (ind + 1) : (ind - 1) ]
//                  })
//               }
//            } else {
//               lastItemCorrect = index + 1
//            }
//         }
      }
   }

   var currentAppointments = ["Taglio Capelli", "Barba", "Shampoo", "Barbagianni", "Capelli di nuovo"]
   
   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .default
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.setNeedsStatusBarAppearanceUpdate()
      
//      self.navigationController?.navigationBar.barTintColor = UIColor.amBlue
//      self.navigationController?.navigationBar.tintColor = UIColor.white
//      self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
      
      
      let startPosition = (self.view.bounds.size.width - (CGFloat(self.currentAppointments.count) * Const.employeeHeaderWidth + (Const.employeeColomnSpacing * 3.0 * (CGFloat(self.currentAppointments.count) - 1.0)))) / 2.0
      
      for index in 0..<self.currentAppointments.count {
         let appointmentView = Bundle.main.loadNibNamed("AppointmentBox", owner: self, options: nil)?[0] as! AppointmentBox
         appointmentView.tag = index
         switch index {
         case 0:
            appointmentView.appointmentAccessoryView.backgroundColor = UIColor(colorLiteralRed: 225/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
         case 1:
            appointmentView.appointmentAccessoryView.backgroundColor = UIColor(colorLiteralRed: 129/255.0, green: 193/255.0, blue: 150/255.0, alpha: 1.0)
         case 2:
            appointmentView.appointmentAccessoryView.backgroundColor = UIColor(colorLiteralRed: 148/255.0, green: 179/255.0, blue: 233/255.0, alpha: 1.0)
         case 3:
            appointmentView.appointmentAccessoryView.backgroundColor = UIColor(colorLiteralRed: 148/255.0, green: 179/255.0, blue: 233/255.0, alpha: 1.0)
         case 4:
            appointmentView.appointmentAccessoryView.backgroundColor = UIColor(colorLiteralRed: 148/255.0, green: 179/255.0, blue: 233/255.0, alpha: 1.0)
         default:
            break
         }
         appointmentView.frame = CGRect(x: startPosition + (CGFloat(index) * (Const.employeeHeaderWidth + Const.employeeColomnSpacing * 3.0)), y: (150.0 - Const.twoThirdUnitHeight) / 2.0, width: Const.employeeHeaderWidth, height: Const.twoThirdUnitHeight)
         self.view.addSubview(appointmentView)
         self.viewPositions.append(appointmentView.frame.origin.x)
         self.appointmentViews.append(appointmentView)
         
         let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.appointmentViewDidPressed(sender:)))
         appointmentView.addGestureRecognizer(tapGestureRecognizer)
      }
      
      //self.previousDisposition = self.appointmentViews.map { $0.frame.origin.x }
      
      self.setupEmployeeScrollView()
      self.setupCalendarScrollView()
      self.setupHourScrollView()
      
      
   }
   
   func appointmentViewDidPressed(sender: UITapGestureRecognizer) {
      if let selectedView = sender.view {
         
         if self.selectedAppoitmentViews.contains(selectedView) {
            for layer in selectedView.layer.sublayers! {
               if layer.name == "selectionLayer" {
                  layer.removeFromSuperlayer()
               }
            }
            self.selectedAppoitmentViews.remove(at: self.selectedAppoitmentViews.index(of: selectedView)!)
            self.appointmentViews.remove(at: self.appointmentViews.index(of: selectedView)!)
            self.appointmentViews.insert(selectedView, at: self.selectedAppoitmentViews.count)
         } else {
//            let selectionLayer = CALayer()
//            selectionLayer.name = "selectionLayer"
//            selectionLayer.frame = selectedView.bounds
//            selectionLayer.borderColor = UIColor(colorLiteralRed: 255/255.0, green: 127/255.0, blue: 46/255.0, alpha: 1.0).cgColor
//            selectionLayer.borderWidth = 6.0
//            selectedView.layer.addSublayer(selectionLayer)
            self.selectedAppoitmentViews.append(selectedView)
            self.appointmentViews.remove(at: self.appointmentViews.index(of: selectedView)!)
            self.appointmentViews.insert(selectedView, at: self.selectedAppoitmentViews.index(of: selectedView)!)
         }
         
      }
      
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
   
   
   
}

extension DragAndDropViewController: UICollectionViewDelegate {
   
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


