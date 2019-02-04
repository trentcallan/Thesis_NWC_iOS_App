//
//  Sport.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/29/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation

class Sport: NSObject, Codable {
    
    var type: String
    var NWCwins: Int
    var NWClosses: Int
    var overallWins: Int
    var overallLosses: Int
    
    init(type: String, NWCwins: Int, NWClosses: Int, overallWins: Int, overallLosses: Int) {
        self.type = type
        self.NWCwins = NWCwins
        self.NWClosses = NWClosses
        self.overallWins = overallWins
        self.overallLosses = overallLosses
    }
    
}
