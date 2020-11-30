//
//  EmployeePicture+CoreDataProperties.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 12/5/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//
//

import Foundation
import CoreData


extension EmployeePicture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeePicture> {
        return NSFetchRequest<EmployeePicture>(entityName: "EmployeePicture")
    }

    @NSManaged public var pictureData: NSData?
    @NSManaged public var employee: Employee?

}
