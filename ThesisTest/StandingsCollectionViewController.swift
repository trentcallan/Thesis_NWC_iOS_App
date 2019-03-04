//
//  StandingsCollectionViewController.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/29/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit
import CoreData
import SwiftSoup

class StandingsCollectionViewController: UICollectionViewController {
    
    var schools: [School] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSchools()
        
        // Allow the height of the cell to automatically adjust
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionView = collectionView {
            let w = collectionView.frame.width - 20
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            flowLayout.estimatedItemSize = CGSize(width: w, height: 80)
        }
        
        // If it's the first time loading this viewcontroller
        let date = Date()
        if(UserDefaults.standard.object(forKey: "lastVisitedStandings") == nil) {
            UserDefaults.standard.set(date, forKey: "lastVisitedStandings")
        }
        // Else find if it's been more than a day since updating
        let lastTime = UserDefaults.standard.object(forKey: "lastVisitedStandings") as! Date
        let dayFromLast = Calendar.current.dateComponents([.day], from: lastTime, to: date).day ?? 0
        if(dayFromLast >= 1) {
            let webScraper = WebScraper()
            webScraper.getAllStandings()
            UserDefaults.standard.set(date, forKey: "lastVisitedStandings")
        }
    }
    
    func loadSchools() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<School>(entityName: "School")
        do {
            schools = try managedContext.fetch(request)
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return schools.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (schools[section].sports?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "standingsCell", for: indexPath) as! StandingsCollectionViewCell
        let school = schools[indexPath.section]
        let color = school.color as! Color
        let sports: [Sport] = school.sports?.array as! [Sport]
        let sport = sports[indexPath.row]
        cell.backgroundColor = color.color
        cell.sportNameLabel.text = sport.type
        if(sport.nwcTies == "" && sport.overallTies == "") {
            cell.nwcRecordLabel.text = "NWC: \(sport.nwcWins!) - \(sport.nwcLosses!)"
            cell.overallRecordLabel.text = "Overall: \(sport.overallWins!) - \(sport.overallLosses!)"
        } else {
            cell.nwcRecordLabel.text = "NWC: \(sport.nwcWins!) - \(sport.nwcTies!) - \(sport.nwcLosses!)"
            cell.overallRecordLabel.text = "Overall: \(sport.overallWins!) - \(sport.overallTies!) - \(sport.overallLosses!)"
        }
        cell.logoImageView.image = UIImage(named: school.logo!)
        
        return cell
    }
    
    // Adding a header for each section
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! StandingsHeaderView
        
        header.headerLbl.text = schools[indexPath.section].name
        let color = schools[indexPath.section].color as! Color
        header.backgroundColor = color.color
        
        return header
    }
    

}
