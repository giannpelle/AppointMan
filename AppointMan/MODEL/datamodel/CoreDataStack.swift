//
//  CoreDataStack.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 11/30/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import Foundation
import CoreData

public struct Sorter {
   let sortingProperty : String
   private var isAscending : Bool = true
   private let selector : Selector? = nil
   
   internal var sortDescriptor : NSSortDescriptor {
      get {
         return NSSortDescriptor(key: sortingProperty, ascending: isAscending, selector: selector)
      }
   }
   
   init(withSortingProperty sortingProperty: String, isAscending: Bool) {
      self.sortingProperty = sortingProperty
      self.isAscending = isAscending
   }
}

class CoreDataStack {
   
   // MARK: Properties
   private let modelName: String
   
   lazy var managedContext: NSManagedObjectContext = {
      return self.storeContainer.viewContext
   }()
   
   private lazy var storeContainer: NSPersistentContainer = {
      
      let container = NSPersistentContainer(name: self.modelName)
      container.loadPersistentStores { (storeDescription, error) in
         if let error = error {
            fatalError("Unresolved error \(error), \(error.localizedDescription)")
         }
      }
      return container
   }()
   
   // MARK: - Initializers
   init(modelName: String) {
      self.modelName = modelName
   }
}

// MARK: Internal
extension CoreDataStack {
   
   func saveContext() throws {
      guard managedContext.hasChanges else { return }
      
      try managedContext.save()
   }
   
   private func compute(expressionDescription: NSExpressionDescription, forProperty property: String, inEntity entityName: String) throws -> NSNumber {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
      fetchRequest.resultType = .dictionaryResultType
      
      fetchRequest.propertiesToFetch = [expressionDescription]
      do {
         let results = try self.managedContext.fetch(fetchRequest) as! [NSDictionary]
         let resultDict = results.first!
         //TODO:  THROW CUSTOM ERROR
         return resultDict[expressionDescription.name] as! NSNumber
      } catch let error  {
         throw error
      }
   }
   
   public func sum(forProperty property: String, inEntity entityName: String) throws -> NSNumber {
      
      let sumExpressionDesc = NSExpressionDescription()
      sumExpressionDesc.name = "sum" + property
      sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: property)])
      sumExpressionDesc.expressionResultType = .integer32AttributeType
      
      return try self.compute(expressionDescription: sumExpressionDesc, forProperty: property, inEntity: entityName)
   }
   
   public func min(forProperty property: String, inEntity entityName: String) throws -> NSNumber {
      
      let minExpressionDesc = NSExpressionDescription()
      minExpressionDesc.name = "min" + property
      minExpressionDesc.expression = NSExpression(forFunction: "min:", arguments: [NSExpression(forKeyPath: property)])
      minExpressionDesc.expressionResultType = .integer32AttributeType
      
      return try compute(expressionDescription: minExpressionDesc, forProperty: property, inEntity: entityName)
   }
   
   public func max(forProperty property: String, inEntity entityName: String) throws -> NSNumber {
      
      let maxExpressionDesc = NSExpressionDescription()
      maxExpressionDesc.name = "max" + property
      maxExpressionDesc.expression = NSExpression(forFunction: "max:", arguments: [NSExpression(forKeyPath: property)])
      maxExpressionDesc.expressionResultType = .integer32AttributeType
      
      return try self.compute(expressionDescription: maxExpressionDesc, forProperty: property, inEntity: entityName)
   }
   
   public func average(forProperty property: String, inEntity entityName: String) throws -> NSNumber {
      
      let averageExpressionDesc = NSExpressionDescription()
      averageExpressionDesc.name = "average" + property
      averageExpressionDesc.expression = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: property)])
      averageExpressionDesc.expressionResultType = .integer32AttributeType
      
      return try self.compute(expressionDescription: averageExpressionDesc, forProperty: property, inEntity: entityName)
   }
}
