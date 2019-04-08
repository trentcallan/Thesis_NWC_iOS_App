//
//  EmptyNotificationTableViewCell.swift
//  ThesisTest
//
//  Created by Trent Callan on 3/7/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class EmptyEventTableViewCell: UITableViewCell {

    var emptyNotificationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    func setupCell() {
        emptyNotificationLabel.text = "There are no events today"
        emptyNotificationLabel.font = UIFont.systemFont(ofSize: 22)
        emptyNotificationLabel.numberOfLines = 0
        emptyNotificationLabel.textAlignment = .center
        self.addSubview(emptyNotificationLabel)
    }

}
