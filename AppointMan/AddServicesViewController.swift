//
//  AddServicesViewController.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 9/28/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class OnBoardingNavigationBar: UINavigationBar {
   
   override func sizeThatFits(_ size: CGSize) -> CGSize {
      return CGSize(width: UIScreen.main.bounds.width, height: 60)
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      self.setup()
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      self.setup()
   }
   
   func setup() {
      self.tintColor = UIColor.white
      self.isTranslucent = false
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      if let rightBarButtonItem = topItem?.rightBarButtonItem {
         if let customView = rightBarButtonItem.customView {
            
            customView.frame = CGRect(x: 0.0, y: 0.0, width: customView.intrinsicContentSize.width, height: customView.intrinsicContentSize.height)
            
            // Could work on iOS 11
            
            /*customView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            customView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            self.layoutIfNeeded()
            for constr in customView.constraints {
               if constr.firstAttribute == .trailing || constr.secondAttribute == .leading {
                  //constr.constant = 0.0
               } else if constr.firstAttribute == .trailing || constr.secondAttribute == .trailing {
                  //constr.constant = 0.0
               }
            }*/
            
            /*// Adjust constraints between items in stack view
            for(UIView *subview in view.subviews) {
               if([subview isKindOfClass:[UIStackView class]]) {
                  for(NSLayoutConstraint *ctr in subview.constraints) {
                     if(ctr.firstAttribute == NSLayoutAttributeWidth || ctr.secondAttribute == NSLayoutAttributeWidth) {
                        ctr.constant = 0.f;
                     }
                  }
               }
            }*/
            
            /*customView.constraints.forEach { $0.isActive = false }
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 40).isActive = true
            customView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            customView.widthAnchor.constraint(equalToConstant: customView.intrinsicContentSize.width).isActive = true
            customView.heightAnchor.constraint(equalToConstant: customView.intrinsicContentSize.height).isActive = true
            //NSLayoutConstraint.activate([trailingConstr, bottomConstr])
            self.layoutIfNeeded()*/
            
            /*customView.translatesAutoresizingMaskIntoConstraints = false
            customView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            customView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            customView.widthAnchor.constraint(equalToConstant: customView.intrinsicContentSize.width).isActive = true
            customView.heightAnchor.constraint(equalToConstant: customView.intrinsicContentSize.height).isActive = true
            self.layoutIfNeeded()*/

         }
      }
   }
   
   /*override func draw(_ rect: CGRect) {
      super.draw(rect)
      
   }*/
   
   

}

class AddServicesViewController: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.navigationController?.navigationBar.barTintColor = UIColor.amBlue
      
      self.setupCurrentNavigationItem()
      
   }
   
   func setupCurrentNavigationItem() {
      // navigation bar title
      self.navigationItem.titleView = UILabel.onBoardingTitleView(withText: "Aggiungi servizi")
      
      // Avanti bar button item
      let testButton = UIButton()
      testButton.setTitle("Ciao", for: .normal)
      testButton.setTitleColor(UIColor.purple, for: .normal)
      testButton.backgroundColor = UIColor.yellow
      let testButtonBarButton = UIBarButtonItem(customView: testButton)
      
      let nextBarButtonItem = UIBarButtonItem(title: "Avanti", style: .plain, target: self, action: #selector(self.nextBarButtonItemPressed(sender:)))
      nextBarButtonItem.setTitleTextAttributes(UILabel.attributes(forTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .normal)
      nextBarButtonItem.setTitleTextAttributes(UILabel.attributes(forTextColor: UIColor.white, andFont: UIFont.init(name: "SFUIText-Regular", size: 14.0)!, andCharacterSpacing: nil), for: .highlighted)
      self.navigationItem.rightBarButtonItem = testButtonBarButton
      
      // Back bar button item
//      let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "on_boarding_back_button"), style: .plain, target: self, action: nil)
//      self.navigationItem.leftBarButtonItem = backBarButtonItem
//      navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//      self.navigationItem.leftBarButtonItem?.title = ""
//      self.navigationItem.backBarButtonItem?.title = ""
//      self.navigationItem.backBarButtonItem?.setBackButtonBackgroundImage(#imageLiteral(resourceName: "on_boarding_back_button"), for: .normal, barMetrics: .default)
//      self.navigationItem.backBarButtonItem?.setBackButtonBackgroundImage(#imageLiteral(resourceName: "on_boarding_back_button"), for: .highlighted, barMetrics: .default)
      
   }
   
   func nextBarButtonItemPressed(sender: UIBarButtonItem) {
     
     let nextVC = UIStoryboard.addEmployeesVC()
      self.navigationController?.pushViewController(nextVC, animated: true)
      //nextVC.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "on_boarding_back_button"), style: .plain, target: self, action: nil)
   }
   
   @IBAction func centeredButtonPressed(sender: UIButton) {
      if let newServiceVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "newServiceVC") as? NewServiceViewController {
         newServiceVC.modalPresentationStyle = .formSheet
         newServiceVC.preferredContentSize = CGSize(width: 540.0, height: 540.0)
         self.present(newServiceVC, animated: true, completion: nil)
      }
   }
   
}
