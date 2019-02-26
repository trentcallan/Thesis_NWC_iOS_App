//
//  Events.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/29/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

/*import Foundation

class Event: NSObject, Codable {
    
    var homeSchool: String
    var awaySchool: String
    var homeTeamScore: String
    var awayTeamScore: String
    var date: String
    var status: String
    var notes: String
    var links: [String : String]
    //var period: Int
    //var time: Int
    
    enum CodingKeys: String, CodingKey {
        case event = "event"
        case homeSchool = "homeSchool"
        case awaySchool = "awaySchool"
        case homeTeamScore = "homeTeamScore"
        case awayTeamScore = "awayTeamScore"
        case date = "date"
        case status = "status"
        case notes = "notes"
        case links = "links"
    }
    
    init(homeSchool: String, awaySchool: String, date: String, status: String, notes: String, homeTeamScore: String = "0", awayTeamScore: String = "0", links: [String : String] = ["" : ""]) {
        self.homeSchool = homeSchool
        self.awaySchool = awaySchool
        self.date = date
        self.status = status
        self.notes = notes
        self.homeTeamScore = homeTeamScore
        self.awayTeamScore = awayTeamScore
        self.links = links
        //self.period = 0
        //self.time = 0
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.homeSchool = try container.decode(String.self, forKey: .homeSchool)
        self.awaySchool = try container.decode(String.self, forKey: .awaySchool)
        self.date = try container.decode(String.self, forKey: .date)
        self.status = try container.decode(String.self, forKey: .status)
        self.notes = try container.decode(String.self, forKey: .notes)
        self.homeTeamScore = try container.decode(String.self, forKey: .homeTeamScore)
        self.awayTeamScore = try container.decode(String.self, forKey: .awayTeamScore)
        self.links = try container.decode([String : String].self, forKey: .links)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.homeSchool, forKey: .homeSchool)
        try container.encode(self.awaySchool, forKey: .awaySchool)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.notes, forKey: .notes)
        try container.encode(self.homeTeamScore, forKey: .homeTeamScore)
        try container.encode(self.awayTeamScore, forKey: .awayTeamScore)
        try container.encode(self.links, forKey: .links)
    }
    
}*/
