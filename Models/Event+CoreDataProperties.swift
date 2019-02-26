//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Trent Callan on 2/14/19.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var team1: String!
    @NSManaged public var team2: String!
    @NSManaged public var team1Score: String!
    @NSManaged public var team2Score: String!
    @NSManaged public var date: String!
    @NSManaged public var status: String!
    @NSManaged public var notes: String!
    @NSManaged public var sport: String!

}
