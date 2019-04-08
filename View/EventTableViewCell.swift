//
//  EventTableViewCell.swift
//  ThesisTest
//
//  Created by Trent Callan on 3/11/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    var team1Label = UILabel()
    var team1ScoreLabel = UILabel()
    var team2Label = UILabel()
    var team2ScoreLabel = UILabel()
    var sportNameLabel = UILabel()
    var notesLabel = UILabel()
    var team1ImageView = UIImageView()
    var team2ImageView = UIImageView()
    var scoreDividerLabel = UILabel()
    var versusLabel = UILabel()
    var logoFillerLabel = UILabel()
    var verticalStackView = UIStackView()
    var horizontalLogosStackView = UIStackView()
    var horizontalScoreStackView = UIStackView()
    var horizontalTeamLabelsStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpCell()
    }
    
    func setUpCell() {
        
        // NWC light blue ish color
        sportNameLabel.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
        versusLabel.text = "vs"
        
        sportNameLabel.numberOfLines = 0
        sportNameLabel.font = UIFont.systemFont(ofSize: 30)
        sportNameLabel.textAlignment = .center
        
        team1Label.numberOfLines = 0
        team1Label.font = UIFont.systemFont(ofSize: 20)
        team1Label.textAlignment = .center
        team2Label.numberOfLines = 0
        team2Label.font = UIFont.systemFont(ofSize: 20)
        team2Label.textAlignment = .center
        
        team1ScoreLabel.font = UIFont.systemFont(ofSize: 17)
        team1ScoreLabel.numberOfLines = 0
        team1ScoreLabel.textAlignment = .center
        team2ScoreLabel.font = UIFont.systemFont(ofSize: 17)
        team2ScoreLabel.numberOfLines = 0
        team2ScoreLabel.textAlignment = .center

        team1ImageView.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        team1ImageView.contentMode = .scaleAspectFit
        team2ImageView.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        team2ImageView.contentMode = .scaleAspectFit
        
        notesLabel.numberOfLines = 0
        notesLabel.textAlignment = .center
        
        verticalStackView.axis = .vertical
        horizontalTeamLabelsStackView.axis = .horizontal
        horizontalLogosStackView.axis = .horizontal
        horizontalScoreStackView.axis = .horizontal
        
        self.addSubview(sportNameLabel)
        self.addSubview(verticalStackView)
        self.addSubview(notesLabel)
        
        // Add views to the stack views
        horizontalTeamLabelsStackView.alignment = .center
        horizontalTeamLabelsStackView.distribution = .equalSpacing
        horizontalTeamLabelsStackView.spacing = 0
        horizontalTeamLabelsStackView.addArrangedSubview(team1Label)
        horizontalTeamLabelsStackView.addArrangedSubview(versusLabel)
        horizontalTeamLabelsStackView.addArrangedSubview(team2Label)
        
        horizontalLogosStackView.alignment = .center
        horizontalLogosStackView.distribution = .fillEqually
        horizontalLogosStackView.spacing = 0
        horizontalLogosStackView.addArrangedSubview(team1ImageView)
        horizontalLogosStackView.addArrangedSubview(logoFillerLabel)
        horizontalLogosStackView.addArrangedSubview(team2ImageView)
        
        horizontalScoreStackView.alignment = .center
        horizontalScoreStackView.distribution = .equalSpacing
        horizontalScoreStackView.spacing = 0
        horizontalScoreStackView.addArrangedSubview(team1ScoreLabel)
        horizontalScoreStackView.addArrangedSubview(scoreDividerLabel)
        horizontalScoreStackView.addArrangedSubview(team2ScoreLabel)

        verticalStackView.spacing = 16
        verticalStackView.addArrangedSubview(horizontalTeamLabelsStackView)
        verticalStackView.addArrangedSubview(horizontalLogosStackView)
        verticalStackView.addArrangedSubview(horizontalScoreStackView)
        
        setUpLayout()
    }
    
    func setUpLayout() {
        sportNameLabel.translatesAutoresizingMaskIntoConstraints = false
        sportNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sportNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        sportNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        sportNameLabel.bottomAnchor.constraint(equalTo: verticalStackView.topAnchor, constant: -16).isActive = true
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.topAnchor.constraint(equalTo: sportNameLabel.bottomAnchor, constant: 16).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: notesLabel.topAnchor, constant: -16).isActive = true
        
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16).isActive = true
        notesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        notesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        notesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
    }

}
