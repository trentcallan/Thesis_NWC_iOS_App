//
//  ActivityIndicatorView.swift
//  ThesisTest
//
//  Created by Trent Callan on 3/7/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIActivityIndicatorView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        createStyle()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        createStyle()
    }
    
    func createStyle() {
        self.frame = frame
        self.backgroundColor = UIColor.black
        self.style = .white
        self.hidesWhenStopped = true
        self.alpha = 0.8
        self.isHidden = true
    }
}
