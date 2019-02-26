//
//  Color.swift
//  ThesisTest
//
//  Created by Trent Callan on 2/21/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation
import UIKit

class Color: NSObject, NSCoding {
    
    var color: UIColor
    
    init(color: UIColor) {
        self.color = color
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let color1 = aDecoder.decodeObject(forKey: "color") as? UIColor
        self.init(color: color1!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(color, forKey: "color")
    }
    
    
}
