//
//  StandingsHeaderView.swift
//  ThesisTest
//
//  Created by Trent Callan on 2/23/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class StandingsHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let border1 = CALayer()
        let border2 = CALayer()
        let width = CGFloat(2.0)
        border1.borderColor = UIColor.black.cgColor
        border2.borderColor = UIColor.black.cgColor
        border1.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width+50, height:2)
        border2.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width+50, height: 2)
        
        border1.borderWidth = width
        border2.borderWidth = width
        self.layer.addSublayer(border1)
        self.layer.addSublayer(border2)
        self.layer.masksToBounds = true
    }
    
}
