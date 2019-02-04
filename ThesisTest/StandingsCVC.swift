//
//  StandingsCVC.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/29/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class StandingsCVC: UICollectionViewController {

    let schools: [School] = [School(name: "Willamette University", logo: "willametteLogo", sport: Sport(type: "Men's Basketball", NWCwins: 4, NWClosses: 4, overallWins: 8, overallLosses: 6)), School(name: "George Fox", logo: "georgefoxLogo", sport: Sport(type: "Women's Basketball", NWCwins: 2, NWClosses: 1, overallWins: 3, overallLosses: 3))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionView = collectionView {
            let w = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 200)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schools.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "standingsCell", for: indexPath) as! StandingsCell
        let school = schools[indexPath.row]
        cell.Team.text = school.sport.type
        cell.Record.text = "NWC: \(school.sport.NWCwins) - \(school.sport.NWClosses)\nOverall: \(school.sport.overallWins) - \(school.sport.overallLosses)"
        cell.Logo.image = UIImage(named: school.logo)
        return cell
    }

}
