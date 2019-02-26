//
//  Sport+CoreDataProperties.swift
//  
//
//  Created by Trent Callan on 2/13/19.
//
//

import Foundation
import CoreData


extension Sport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sport> {
        return NSFetchRequest<Sport>(entityName: "Sport")
    }

    @NSManaged public var type: String!
    @NSManaged public var nwcWins: String!
    @NSManaged public var nwcLosses: String!
    @NSManaged public var nwcTies: String?
    @NSManaged public var overallWins: String!
    @NSManaged public var overallLosses: String!
    @NSManaged public var overallTies: String?
    @NSManaged public var school: School!

}
