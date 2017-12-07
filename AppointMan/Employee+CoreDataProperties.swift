//
//  Employee+CoreDataProperties.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/5/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var hiredDate: NSDate?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var picture: EmployeePicture?
    @NSManaged public var services: NSSet?

}

// MARK: Generated accessors for services
extension Employee {

    @objc(addServicesObject:)
    @NSManaged public func addToServices(_ value: Service)

    @objc(removeServicesObject:)
    @NSManaged public func removeFromServices(_ value: Service)

    @objc(addServices:)
    @NSManaged public func addToServices(_ values: NSSet)

    @objc(removeServices:)
    @NSManaged public func removeFromServices(_ values: NSSet)

}
