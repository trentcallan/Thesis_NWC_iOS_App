//
//  StandingsCell.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/29/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class StandingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nwcRecordLabel: UILabel!
    @IBOutlet weak var overallRecordLabel: UILabel!
    @IBOutlet weak var sportNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 8.0
        
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 8.0
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        
        /*Logo.layer.borderColor = UIColor.black.cgColor
        Logo.layer.borderWidth = 2.0
        
        Team.layer.borderColor = UIColor.black.cgColor
        Team.layer.borderWidth = 2.0
        
        nwcRecord.layer.borderColor = UIColor.black.cgColor
        nwcRecord.layer.borderWidth = 2.0
        
        overallRecord.layer.borderColor = UIColor.black.cgColor
        overallRecord.layer.borderWidth = 2.0*/
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
}
