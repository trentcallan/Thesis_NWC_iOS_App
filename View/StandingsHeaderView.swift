//
//  StandingsHeaderView.swift
//  ThesisTest
//
//  Created by Trent Callan on 2/23/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

protocol ViewTappedDelegate {
    func viewTapped(section: Int)
}

class StandingsHeaderView: UICollectionReusableView, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var schoolLogoImageView: UIImageView!
    @IBOutlet weak var headerLbl: UILabel!
    var standingsViewDelegate: ViewTappedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        let border1 = CALayer()
        let border2 = CALayer()
        let width = CGFloat(2.0)
        border1.borderColor = UIColor.black.cgColor
        border2.borderColor = UIColor.black.cgColor
        let screenWidth = UIScreen.main.bounds.width
        border1.frame = CGRect(x: 0, y: self.frame.size.height - width, width: screenWidth, height:2)
        border2.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 2)
        
        border1.borderWidth = width
        border2.borderWidth = width
        self.layer.addSublayer(border1)
        self.layer.addSublayer(border2)
        self.layer.masksToBounds = true
    }
    
    @objc func handleHeaderTap() {
        standingsViewDelegate?.viewTapped(section: self.tag)
    }
    
}
