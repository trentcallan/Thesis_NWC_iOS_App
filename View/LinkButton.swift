//
//  LinkButton.swift
//  ThesisTest
//
//  Created by Trent Callan on 4/3/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class LinkButton: UIButton {
    
    var link: String?
    var title: String?
    
    init(frame: CGRect, title: String, link: String) {
        super.init(frame: frame)
        self.title = title
        self.link = link
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpButton()
    }
    
    func setUpButton() {
        self.setTitle(title, for: .normal)
        self.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        if let linkToGoTo = link {
            if let url = URL(string: "https://www.nwcsports.com/\(linkToGoTo)") {
                UIApplication.shared.open(url, options: [:])
            }
        }

    }
}
