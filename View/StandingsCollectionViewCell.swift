//
//  StandingsCell.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/29/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class StandingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sportNameLabel: UILabel!
    @IBOutlet weak var nwcRecordLabel: UILabel!
    @IBOutlet weak var overallRecordLabel: UILabel!
    @IBOutlet weak var nwcWinPercentageLabel: UILabel!
    @IBOutlet weak var overallWinPercentageLabel: UILabel!
    @IBOutlet weak var nwcRFLabel: UILabel!
    @IBOutlet weak var overallRFLabel: UILabel!
    @IBOutlet weak var nwcRALabel: UILabel!
    @IBOutlet weak var overallRALabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sportNameLabel.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
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
