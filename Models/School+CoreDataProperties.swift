//
//  School+CoreDataProperties.swift
//  
//
//  Created by Trent Callan on 2/21/19.
//
//

import Foundation
import CoreData


extension School {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<School> {
        return NSFetchRequest<School>(entityName: "School")
    }

    @NSManaged public var name: String?
    @NSManaged public var logo: String?
    @NSManaged public var color: NSObject?
    @NSManaged public var sports: NSOrderedSet?

}

// MARK: Generated accessors for sports
extension School {

    @objc(insertObject:inSportsAtIndex:)
    @NSManaged public func insertIntoSports(_ value: Sport, at idx: Int)

    @objc(removeObjectFromSportsAtIndex:)
    @NSManaged public func removeFromSports(at idx: Int)

    @objc(insertSports:atIndexes:)
    @NSManaged public func insertIntoSports(_ values: [Sport], at indexes: NSIndexSet)

    @objc(removeSportsAtIndexes:)
    @NSManaged public func removeFromSports(at indexes: NSIndexSet)

    @objc(replaceObjectInSportsAtIndex:withObject:)
    @NSManaged public func replaceSports(at idx: Int, with value: Sport)

    @objc(replaceSportsAtIndexes:withSports:)
    @NSManaged public func replaceSports(at indexes: NSIndexSet, with values: [Sport])

    @objc(addSportsObject:)
    @NSManaged public func addToSports(_ value: Sport)

    @objc(removeSportsObject:)
    @NSManaged public func removeFromSports(_ value: Sport)

    @objc(addSports:)
    @NSManaged public func addToSports(_ values: NSOrderedSet)

    @objc(removeSports:)
    @NSManaged public func removeFromSports(_ values: NSOrderedSet)

}
