//
//  Sport+CoreDataProperties.swift
//  
//
//  Created by Trent Callan on 4/3/19.
//
//

import Foundation
import CoreData


extension Sport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sport> {
        return NSFetchRequest<Sport>(entityName: "Sport")
    }

    @NSManaged public var nwcLosses: String!
    @NSManaged public var nwcTies: String?
    @NSManaged public var nwcWins: String!
    @NSManaged public var overallLosses: String!
    @NSManaged public var overallTies: String?
    @NSManaged public var overallWins: String!
    @NSManaged public var type: String!
    @NSManaged public var nwcWinPercentage: String?
    @NSManaged public var overallWinPercentage: String?
    @NSManaged public var nwcRF: String?
    @NSManaged public var nwcRA: String?
    @NSManaged public var overallRF: String?
    @NSManaged public var overallRA: String?
    @NSManaged public var school: School!

}
