//
//  School.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/29/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

/*import Foundation
import UIKit
import CoreData

class School: NSObject, Codable {
    
    var name: String
    var logo: String
    var sports: [Sport]
    
    enum CodingKeys: String, CodingKey {
        case school = "school"
        case name = "name"
        case logo = "logo"
        case sports = "sports"
    }
    
    init(name: String, logo: String, sports: [Sport]) {
        self.name = name
        self.logo = logo
        self.sports = sports
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let school = try container.nestedContainer(keyedBy:
            CodingKeys.self, forKey: .school)
        self.name = try school.decode(String.self, forKey: .name)
        self.logo = try school.decode(String.self, forKey: .logo)
        self.sports = try school.decode([Sport].self, forKey: .sports)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var school = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .school)
        try school.encode(self.name, forKey: .name)
        try school.encode(self.logo, forKey: .logo)
        try school.encode(self.sports, forKey: .sports)
    }

    
}*/
