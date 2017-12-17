//
//  Service+CoreDataProperties.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/11/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var color: Int16
    @NSManaged public var duration: Int16
    @NSManaged public var gender: Int16
    @NSManaged public var name: String?
    @NSManaged public var id: Int16
    @NSManaged public var employee: Employee?

}
