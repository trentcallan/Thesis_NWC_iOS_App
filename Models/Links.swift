//
//  Links.swift
//  ThesisTest
//
//  Created by Trent Callan on 4/3/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation
import UIKit

class Links: NSObject, NSCoding {

    var links: [String : String]
    
    init(links: [String : String]) {
        self.links = links
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let links1 = aDecoder.decodeObject(forKey: "links") as? [String : String]
        self.init(links: links1!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(links, forKey: "links")
    }
}
