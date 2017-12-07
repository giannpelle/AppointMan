//
//  EmployeeManager.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/4/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit
import CoreData

typealias EmployeeTuple = (firstName: String, lastName: String, cellPhoneNumber: String?, email: String?, pictureData: NSData?, services: [Service]?)

class EmployeeManager: NSObject {
   static let shared = EmployeeManager()
   var coreDataStack: CoreDataStack!

   var cachedEmployees: [Employee] = []

   private override init() { }

   func getAllEmployeesFromPersistentStore() -> [Employee] {
      let allEmployeesFetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
      allEmployeesFetchRequest.sortDescriptors = [NSSortDescriptor(key: "hiredDate", ascending: true)]
      if let employees = try? self.coreDataStack.managedContext.fetch(allEmployeesFetchRequest) {
         return employees
      } else {
         return []
      }
   }

   func getNumberOfRows() -> Int {
      self.cachedEmployees = self.getAllEmployeesFromPersistentStore()
      return self.cachedEmployees.count
   }

   func employee(forItemAt indexPath: IndexPath) -> Employee {
      return self.cachedEmployees[indexPath.row]
   }
   
   func saveEmployee(with employee: EmployeeTuple) throws {
      let newEmployee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: self.coreDataStack.managedContext) as! Employee
      newEmployee.firstName = employee.firstName
      newEmployee.lastName = employee.lastName
      newEmployee.phoneNumber = employee.cellPhoneNumber
      newEmployee.email = employee.email
      
      let pictureObject = EmployeePicture(context: self.coreDataStack.managedContext)
      pictureObject.pictureData = employee.pictureData
      newEmployee.picture = pictureObject
      
      if let services = employee.services {
         let servicesSet = NSSet(array: services)
         newEmployee.services = servicesSet
      }
      
      try self.coreDataStack.saveContext()
   }

}
