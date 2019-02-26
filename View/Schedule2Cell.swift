//
//  Schedule2Cell.swift
//  ThesisTest
//
//  Created by Trent Callan on 2/15/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class Schedule2Cell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var team1Lbl: UILabel!
    @IBOutlet weak var team1ScoreLbl: UILabel!
    @IBOutlet weak var team2ScoreLbl: UILabel!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
