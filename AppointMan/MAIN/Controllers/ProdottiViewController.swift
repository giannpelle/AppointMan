//
//  ProdottiViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 8/13/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class ProdottiViewController: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let firstView = AppointmentView(withAppointment: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.quarter, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
      self.view.addSubview(firstView)
      firstView.translatesAutoresizingMaskIntoConstraints = false
      firstView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
      firstView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
      
      let secondView = AppointmentView(withAppointment: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.twenty, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
      self.view.addSubview(secondView)
      secondView.translatesAutoresizingMaskIntoConstraints = false
      secondView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
      secondView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
      
      let thirdView = AppointmentView(withAppointment: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.twentyFive, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
      self.view.addSubview(thirdView)
      thirdView.translatesAutoresizingMaskIntoConstraints = false
      thirdView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
      thirdView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
      
      let firstView2 = AppointmentView(withAppointment: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.thirty, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
      self.view.addSubview(firstView2)
      firstView2.translatesAutoresizingMaskIntoConstraints = false
      firstView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
      firstView2.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
      
      let secondView2 = AppointmentView(withAppointment: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.thirtyFive, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
      self.view.addSubview(secondView2)
      secondView2.translatesAutoresizingMaskIntoConstraints = false
      secondView2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
      secondView2.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
      
      let thirdView2 = AppointmentView(withAppointment: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.fourty, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
      self.view.addSubview(thirdView2)
      thirdView2.translatesAutoresizingMaskIntoConstraints = false
      thirdView2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
      thirdView2.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
      
      let firstView3 = AppointmentView(withAppointment: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.fourtyFive, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
      self.view.addSubview(firstView3)
      firstView3.translatesAutoresizingMaskIntoConstraints = false
      firstView3.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
      firstView3.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
      
      let secondView3 = AppointmentView(withAppointment: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.large(50), serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
      self.view.addSubview(secondView3)
      secondView3.translatesAutoresizingMaskIntoConstraints = false
      secondView3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
      secondView3.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
      
      let thirdView3 = AppointmentView(withAppointment: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.large(50), serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: "Il cliente di solito arriva 10 minuti prima"))
      self.view.addSubview(thirdView3)
      thirdView3.translatesAutoresizingMaskIntoConstraints = false
      thirdView3.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
      thirdView3.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
      
      
//      if let secondView = UINib(nibName: "AppointmentView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? AppointmentView {
//         secondView.configure(for: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.quarter, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: "Il cliente di solito arriva 10 min prima"))
//         self.view.addSubview(secondView)
//         secondView.translatesAutoresizingMaskIntoConstraints = false
//         secondView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//         secondView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//      }
//
//      if let thirdView = UINib(nibName: "AppointmentView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? AppointmentView {
//         thirdView.configure(for: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.twenty, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
//         self.view.addSubview(thirdView)
//         thirdView.translatesAutoresizingMaskIntoConstraints = false
//         thirdView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//         thirdView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//      }
//
//      if let fourthView = UINib(nibName: "AppointmentView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? AppointmentView {
//         fourthView.configure(for: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.twenty, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: "Il cliente di solito arriva 10 min prima"))
//         self.view.addSubview(fourthView)
//         fourthView.translatesAutoresizingMaskIntoConstraints = false
//         fourthView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//         fourthView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//      }
//
//      if let fifthView = UINib(nibName: "AppointmentView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? AppointmentView {
//         fifthView.configure(for: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.twentyFive, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: nil))
//         self.view.addSubview(fifthView)
//         fifthView.translatesAutoresizingMaskIntoConstraints = false
//         fifthView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//         fifthView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//      }
//
//      if let sixthView = UINib(nibName: "AppointmentView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? AppointmentView {
//         sixthView.configure(for: (time: "10:30 - 11:30", service: "Taglio capelli", duration: AppointmentDuration.twentyFive, serviceColor: ServiceColor.getRandomColor(), customer: "Francesca Nomade", description: "Il cliente di solito arriva 10 min prima"))
//         self.view.addSubview(sixthView)
//         sixthView.translatesAutoresizingMaskIntoConstraints = false
//         sixthView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//         sixthView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//      }
      
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      
      for view in self.view.subviews {
         if let appView = view as? AppointmentView {
            print(view.frame)
         }
      }
      
   }
   
}
