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
    var indicator = UIActivityIndicatorView()
    var removedSchools = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRemovedSchools()
        schools.loadSchools()
        
        indicator = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(indicator)
                
    }
    
    func setUpRemovedSchools() {
        let userDefaults = UserDefaults.standard
        
        if(userDefaults.object(forKey: "removedSchools") == nil) {
            let collapsedSectionsToStart = [true, true, true, true, true, true, true, true, true]
            userDefaults.set(collapsedSectionsToStart, forKey:"removedSchools")
        }
        removedSchools = userDefaults.object(forKey: "removedSchools") as! [Bool]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Find if it's been more than a day since updating
        let lastTime = UserDefaults.standard.object(forKey: "lastVisitedStandings") as! Date
        let dayFromLast = Calendar.current.dateComponents([.day], from: lastTime, to: Date()).day ?? 0
        if(dayFromLast >= 1) {
            // Start animating the indicator to show user background work is being done
            indicator.isHidden = false
            indicator.startAnimating()
            
            let webScraper = WebScraper()
            // Update all data on the background thread
            
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                webScraper.getAllStandings()
                
                // Update the UI on the main thread
                DispatchQueue.main.async(execute: {
                    do {
                        try webScraper.managedContext.save()
                    } catch let error as NSError {
                        print("could not save. \(error), \(error.userInfo)")
                    }
                    self.indicator.stopAnimating()
                    self.collectionView.reloadData()
                })
            })
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return schools.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        for (index, removedSchool) in removedSchools.enumerated() {
            if(section == index && removedSchool) {
                return 0
            }
        }
        return (schools[section].sports?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "standingsCell", for: indexPath) as! StandingsCollectionViewCell
        let school = schools[indexPath.section]
        let sports: [Sport] = school.sports?.array as! [Sport]
        let sport = sports[indexPath.row]
        cell.sportNameLabel.text = sport.type
        if(sport.nwcTies == "" && sport.overallTies == "") {
            cell.nwcRecordLabel.text = sport.nwcWins + " - " + sport.nwcLosses
            cell.overallRecordLabel.text = sport.overallWins + " - " + sport.overallLosses
        } else {
            cell.nwcRecordLabel.text = sport.nwcWins + " - " + sport.nwcTies! + " - " + sport.nwcLosses
            cell.overallRecordLabel.text = sport.overallWins + " - " + sport.overallTies! + " - " + sport.overallLosses
        }
        cell.nwcWinPercentageLabel.text = sport.nwcWinPercentage
        cell.overallWinPercentageLabel.text = sport.overallWinPercentage
        cell.nwcRFLabel.text = sport.nwcRF
        cell.overallRFLabel.text = sport.overallRF
        cell.nwcRALabel.text = sport.nwcRA
        cell.overallRALabel.text = sport.nwcRA
        
        return cell
    }
    
    // Adding a header for each section
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! StandingsHeaderView
        header.standingsViewDelegate = self
        header.tag = indexPath.section
        
        header.headerLbl.text = schools[indexPath.section].name
        header.schoolLogoImageView.image = UIImage(named: schools[indexPath.section].logo!)
        let color = schools[indexPath.section].color as! Color
        header.backgroundColor = color.color
        
        return header
    }
    
    func loadSpecificSchool(schoolName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let privateManagedObjectContext = appDelegate.updateContext
        var temporarySchools: [School] = []
        
        let request = NSFetchRequest<School>(entityName: "School")
        let commitPredicate = NSPredicate(format: "name == %@", schoolName)
        request.predicate = commitPredicate
        do {
            temporarySchools = try privateManagedObjectContext.fetch(request)
            for school in temporarySchools {
                schools.insert(school, at: 0)
            }
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
        
    }
    

}

extension StandingsCollectionViewController : ViewTappedDelegate {

    func viewTapped(section: Int) {
        // On tapping a section header
        let numberOfSportsInSection = schools[section].sports.count
        
        // Empty section
        if(removedSchools[section]) {
            removedSchools[section] = false
            UserDefaults.standard.set(removedSchools, forKey:"removedSchools")

            var indexPathArray = [IndexPath]()
            for i in 0...numberOfSportsInSection-1 {
                let indexPath = IndexPath(row: i, section: section)
                indexPathArray.append(indexPath)
            }
                        
            collectionView?.performBatchUpdates({
                self.collectionView?.insertItems(at: indexPathArray)
            }, completion: nil)
        } else {

            removedSchools[section] = true
            UserDefaults.standard.set(removedSchools, forKey:"removedSchools")
            
            var indexPathArray = [IndexPath]()
            for i in 0...numberOfSportsInSection-1 {
                
                let indexPath = IndexPath(row: i, section: section)
                indexPathArray.append(indexPath)
            }
            
            collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: indexPathArray)
            }, completion: nil)
        }
    }
    
}
