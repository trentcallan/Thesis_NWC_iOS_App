//
//  Events.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/29/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation

class Event: NSObject, Codable {
    
    var homeSchool: School
    var awaySchool: School
    var homeTeamScore: Int
    var awayTeamScore: Int
    var dateOfEvent: String
    var period: Int
    var time: Int
    var eventLocation: String
    
    init(homeSchool: School, awaySchool: School, homeTeamScore: Int, awayTeamScore: Int, dateOfEvent: String) {
        self.homeSchool = homeSchool
        self.awaySchool = awaySchool
        self.homeTeamScore = homeTeamScore
        self.awayTeamScore = awayTeamScore
        self.dateOfEvent = dateOfEvent
        self.period = 0
        self.time = 0
        self.eventLocation = ""
    }
    
}
