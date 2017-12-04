//
//  AppDelegate.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 5/11/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?
   lazy var coreDataStack = CoreDataStack(modelName: "AppointMan")

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      ServiceManager.shared.coreDataStack = self.coreDataStack
      
      self.window = UIWindow(frame: UIScreen.main.bounds)
      let mainController = UIStoryboard.addServicesVC()
      mainController.coreDataStack = self.coreDataStack
      let navigationController = UINavigationController(rootViewController: mainController)
      navigationController.isNavigationBarHidden = true
      self.window?.rootViewController = navigationController
      self.window?.makeKeyAndVisible()
      return true
   }
   
   func applicationDidEnterBackground(_ application: UIApplication) {
      do {
         try self.coreDataStack.saveContext()
      } catch let error as NSError {
         print(error.localizedDescription)
      }
   }
   
   func applicationWillTerminate(_ application: UIApplication) {
      do {
         try self.coreDataStack.saveContext()
      } catch let error as NSError {
         print(error.localizedDescription)
      }
   }

   func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
   }

   func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   }

   func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }

}

