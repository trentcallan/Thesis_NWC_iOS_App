//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Trent Callan on 4/4/19.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var date: Date!
    @NSManaged public var notes: String!
    @NSManaged public var sport: String!
    @NSManaged public var status: String!
    @NSManaged public var team1: String!
    @NSManaged public var team1Score: String!
    @NSManaged public var team2: String!
    @NSManaged public var team2Score: String!
    @NSManaged public var links: NSObject?
    @NSManaged public var team1Logo: String?
    @NSManaged public var team2Logo: String?

}
