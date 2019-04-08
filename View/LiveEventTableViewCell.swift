//
//  LiveEventCell.swift
//  ThesisTest
//
//  Created by Trent Callan on 2/23/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class LiveEventTableViewCell: UITableViewCell {

    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team1ScoreLabel: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var team2ScoreLabel: UILabel!
    @IBOutlet weak var sportNameLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var team1ImageView: UIImageView!
    @IBOutlet weak var team2ImageView: UIImageView!
    @IBOutlet weak var scoreDividerLabel: UILabel!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var horizontalLogosStackView: UIStackView!
    @IBOutlet weak var horizontalScoreStackView: UIStackView!
    @IBOutlet weak var horizontalTeamLabelsStackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // NWC light blue ish color
        sportNameLabel.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
        
        // Allow dynamic sizing of labels
        team1Label.numberOfLines = 0
        team2Label.numberOfLines = 0
        notesLabel.numberOfLines = 0
        sportNameLabel.numberOfLines = 0
        
        verticalStackView.spacing = 8
        horizontalTeamLabelsStackView.alignment = .center
        horizontalLogosStackView.alignment = .center
        horizontalScoreStackView.alignment = .center
        
        horizontalTeamLabelsStackView.distribution = .equalCentering
        horizontalLogosStackView.distribution = .fillEqually
        horizontalScoreStackView.distribution = .equalCentering
    
    }
    
}
