//
//  LinkButtonsScrollView.swift
//  ThesisTest
//
//  Created by Trent Callan on 4/3/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class LinkButtonsScrollView: UIScrollView {

    var links: Links?
    
    init(frame: CGRect, links: Links) {
        super.init(frame: frame)
        self.links = links
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpView() {
        self.isScrollEnabled = true
        if let linksToUse = links {
            let numberOfButtons = linksToUse.links.count
            let widthSize = 96
            self.contentSize = CGSize(width: (numberOfButtons*widthSize) + (numberOfButtons*4), height: 64)
            let dict = linksToUse.links
            let allKeys = linksToUse.links.keys
            for (index, key) in allKeys.enumerated() {
                let button = LinkButton(frame: CGRect(x: index*96 + index*4, y: 0, width: 96, height: 64), title: key, link: dict[key]!)
                self.addSubview(button)
                
            }
        }
    }

}
