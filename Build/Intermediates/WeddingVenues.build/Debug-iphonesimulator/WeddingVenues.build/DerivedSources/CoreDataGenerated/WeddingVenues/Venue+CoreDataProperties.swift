//
//  Venue+CoreDataProperties.swift
//  
//
//  Created by Lauren Nicole Roth on 3/14/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Venue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Venue> {
        return NSFetchRequest<Venue>(entityName: "Venue");
    }

    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?

}
