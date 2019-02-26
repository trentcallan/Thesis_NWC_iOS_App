//
//  Sport.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/29/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

/*import Foundation
import UIKit
import CoreData

class Sport: NSObject, Codable {
    
    var type: String
    var NWCwins: Int
    var NWClosses: Int
    var overallWins: Int
    var overallLosses: Int
    //var schedule: [Event]
    
    enum CodingKeys: String, CodingKey {
        case sport = "sport"
        case type = "type"
        case NWCwins = "NWCwins"
        case NWClosses = "NWClosses"
        case overallWins = "overallWins"
        case overallLosses = "overallLosses"
    }
    
    init(type: String, NWCwins: Int, NWClosses: Int, overallWins: Int, overallLosses: Int) {
        self.type = type
        self.NWCwins = NWCwins
        self.NWClosses = NWClosses
        self.overallWins = overallWins
        self.overallLosses = overallLosses
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.NWCwins = try container.decode(Int.self, forKey: .NWCwins)
        self.NWClosses = try container.decode(Int.self, forKey: .NWClosses)
        self.overallWins = try container.decode(Int.self, forKey: .overallWins)
        self.overallLosses = try container.decode(Int.self, forKey: .overallLosses)
        
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.NWCwins, forKey: .NWCwins)
        try container.encode(self.NWClosses, forKey: .NWClosses)
        try container.encode(self.overallWins, forKey: .overallWins)
        try container.encode(self.overallLosses, forKey: .overallLosses)
    }
    
    
}*/
