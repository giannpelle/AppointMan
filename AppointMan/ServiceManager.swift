//
//  ServiceManager.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/30/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ServiceManager: NSObject {
   static let shared = ServiceManager()
   var coreDataStack: CoreDataStack!
   
   var sorter: Sorter?
   var cachedServices: [Service] = [] {
      didSet {
         var manServices: [Service] = []
         var womanServices: [Service] = []
         var unisexServices: [[Service]] = []
         
         var pairNames: [String] = []
         
         for service in self.cachedServices {
            if let serviceName = service.name {
               if !(pairNames.contains(serviceName)) {
                  if (self.cachedServices.filter { $0.name == service.name }).count > 1 {
                     unisexServices.append(self.cachedServices.filter { $0.name == service.name })
                     pairNames.append(serviceName)
                  } else {
                     if service.gender == Int16(Gender.male.rawValue) {
                        manServices.append(service)
                     } else if service.gender == Int16(Gender.female.rawValue) {
                        womanServices.append(service)
                     }
                  }
               }
            }
         }
         
         self.cachedManServices = manServices
         self.cachedWomanServices = womanServices
         self.cachedUnisexServices = unisexServices
      }
   }
   var cachedManServices: [Service] = []
   var cachedWomanServices: [Service] = []
   var cachedUnisexServices: [[Service]] = []
   
   private override init() { }
   
   func getAllServicesFromPersistentStore() -> [Service] {
      let allServicesFetchRequest = NSFetchRequest<Service>(entityName: "Service")
      if let sorter = self.sorter {
         allServicesFetchRequest.sortDescriptors = [sorter.sortDescriptor]
      }
      if let services = try? self.coreDataStack.managedContext.fetch(allServicesFetchRequest) {
         return services
      } else {
         return []
      }
   }
   
   func getNumberOfSections() -> Int {
      self.cachedServices = self.getAllServicesFromPersistentStore()
      return (([self.cachedManServices, self.cachedWomanServices, self.cachedUnisexServices] as [AnyObject]).filter { $0.count > 0 }).count
   }
   
   func getNumberOfRows(for section: Int) -> Int {
      guard self.cachedServices.count > 0 else { return 0 }
      return (([self.cachedManServices, self.cachedWomanServices, self.cachedUnisexServices] as [AnyObject]).filter { $0.count > 0 })[section].count
   }
   
   func services(forItemAt indexPath: IndexPath) -> [Service] {
      let services = ([self.cachedManServices, self.cachedWomanServices, self.cachedUnisexServices] as [AnyObject]).filter { $0.count > 0 }
      if let manServices = services[indexPath.section] as? [Service], (manServices.filter { $0.gender == Int16(Gender.male.rawValue) }).count > 0 {
         return [manServices[indexPath.row]]
      } else if let womanServices = services[indexPath.section] as? [Service], (womanServices.filter { $0.gender == Int16(Gender.female.rawValue) }).count > 0 {
         return [womanServices[indexPath.row]]
      } else if let unisexServices = services[indexPath.section] as? [[Service]] {
         return unisexServices[indexPath.row]
      }
      
      return []
   }
   
   func sectionHeaderIndex(for indexPath: IndexPath) -> Int {
      let services = ([self.cachedManServices, self.cachedWomanServices, self.cachedUnisexServices] as [AnyObject]).filter { $0.count > 0 }
      if let manServices = services[indexPath.section] as? [Service], (manServices.filter { $0.gender == Int16(Gender.male.rawValue) }).count > 0 {
         return 0
      } else if let womanServices = services[indexPath.section] as? [Service], (womanServices.filter { $0.gender == Int16(Gender.female.rawValue) }).count > 0 {
         return 1
      } else if let _ = services[indexPath.section] as? [[Service]] {
         return 2
      }
      return 0
   }
   
   func deleteServices(services: [Service]) {
      for service in services {
         if let serviceName = service.name {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Service")
            fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %d AND %K == %d", #keyPath(Service.name), serviceName, #keyPath(Service.gender), service.gender, #keyPath(Service.color), service.color)
            let batchDeletion = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeletion.resultType = .resultTypeObjectIDs
            if let batchResult = try? self.coreDataStack.managedContext.execute(batchDeletion), let result = (batchResult as? NSBatchUpdateResult)?.result as? [NSManagedObjectID] {
               let changes = [NSDeletedObjectsKey : result]
               NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.coreDataStack.managedContext])
               print("\(result) records deleted")
            }
         }
      }
   }
}
