//
//  EventDetailsViewController.swift
//  ThesisTest
//
//  Created by Trent Callan on 4/3/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var versusLabel: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var team1LogoImageView: UIImageView!
    @IBOutlet weak var team2LogoImageView: UIImageView!
    @IBOutlet weak var score1Label: UILabel!
    @IBOutlet weak var scoreSeparatorLabel: UILabel!
    @IBOutlet weak var score2Label: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    
    var links: Links?
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem?.title = "Back"
        navigationItem.title = event?.sport
        
        dateLabel.backgroundColor = UIColor.gray
        if let eventClicked = event {
            dateLabel.text = eventClicked.date.toStringDate()
            team1Label.text = eventClicked.team1
            team2Label.text = eventClicked.team2
            statusLabel.text = eventClicked.status
            notesLabel.text = eventClicked.notes
            if let logoString1 = eventClicked.team1Logo {
                team1LogoImageView.image = UIImage(named: logoString1)
            }
            if let logoString2 = eventClicked.team2Logo {
                team2LogoImageView.image = UIImage(named: logoString2)
            }
            score1Label.text = eventClicked.team1Score
            score2Label.text = eventClicked.team2Score
            if(eventClicked.team1Score == "" && eventClicked.team2Score == "") {
                scoreSeparatorLabel.text = ""
            } else {
                if let score1 = Int(eventClicked.team1Score), let score2 = Int(eventClicked.team2Score) {
                    if(score1 > score2 && eventClicked.status.contains("Final")) {
                        score1Label.backgroundColor = UIColor.green
                    } else if(score1 < score2 && eventClicked.status.contains("Final")) {
                        score2Label.backgroundColor = UIColor.green
                    }
                }
            }

        }

        let scrollViewHeight: CGFloat = 64
        let scrollBottomPadding: CGFloat = 8
        if let linksToUse = links, let tabBarHeight = tabBarController?.tabBar.bounds.height {
            let scrollView = LinkButtonsScrollView(frame: CGRect(x: 8, y: (self.view.bounds.height - scrollViewHeight - scrollBottomPadding - tabBarHeight), width: self.view.bounds.width, height: 64), links: linksToUse)
            self.view.addSubview(scrollView)
            NSLayoutConstraint(item: verticalStackView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: -16).isActive = true
        }
    }
    
}
