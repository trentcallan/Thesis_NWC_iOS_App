//
//  SharedCode.swift
//  ThesisTest
//
//  Created by Trent Callan on 4/8/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Date {
    
    func toStringDate() -> String
    {
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Specify Format of String to Parse
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        // Get string from date
        let stringFromDate = dateFormatter.string(from: self)
        
        return stringFromDate
    }
}

extension String {
    
    func toDate() -> Date
    {
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Specify Format of String to Parse
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        // Get date from string
        let dateFromString = dateFormatter.date(from: self)!
        
        return dateFromString
    }
    
}

extension Array where Element == School {
    
    // Load schools and their order is determined by sectionNumber
    mutating func loadSchools() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let privateManagedObjectContext = appDelegate.updateContext
        
        let request = NSFetchRequest<School>(entityName: "School")
        let sortDescriptor = NSSortDescriptor(key: "sectionNumber", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortDescriptor]
        do {
            self = try privateManagedObjectContext.fetch(request)
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
    }
    
}
