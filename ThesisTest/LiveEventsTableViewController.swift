//
//  LiveEventsTVC.swift
//  ThesisTest
//
//  Created by Trent Callan on 2/23/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit
import CoreData
import SwiftSoup

class LiveEventsTableViewController: UITableViewController {

    var liveEvents = [[Event]]()
    var dates: [String] = []
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.tableView.register(EmptyEventTableViewCell.self, forCellReuseIdentifier: "emptyEventReuseIdentifier")
        
        let date = Date()
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        let result1 = formatter.string(from: date)
        let result2 = formatter.string(from: nextDay!)
        dates.append(result1)
        dates.append(result2)
        
        loadSpecificEventsForDates(dates: dates)
        checkForUpdatesOfCurrentDate(date: date)
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let tempFiller = Event(context: managedContext)
//        tempFiller.date = "Thursday, February 24"
//        tempFiller.team1 = "Willamette"
//        tempFiller.team2 = "Pacific"
//        tempFiller.team1Score = "10"
//        tempFiller.team2Score = "20"
//        tempFiller.notes = "3rd Quarter"
//        tempFiller.sport = "Women's Basketball"
//        tempFiller.status = ""
//        liveEvents[0].append(tempFiller)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return liveEvents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(liveEvents[section].count == 0) {
            emptySection = true
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return liveEvents[section].count }
            let managedContext = appDelegate.persistentContainer.viewContext
            liveEvents[section].append(Event(context: managedContext))
        }
        return liveEvents[section].count
    }
    
    var emptySection = false
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dayEvents = liveEvents[indexPath.section]
        if(dayEvents.count == 1 && emptySection) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyEventReuseIdentifier", for: indexPath) as! EmptyEventTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "liveEvent", for: indexPath) as! LiveEventTableViewCell
            let event = dayEvents[indexPath.row]
        
            cell.team1Label.text = event.team1
            cell.team2Label.text = event.team2
            cell.team1ScoreLabel.text = event.team1Score
            cell.team2ScoreLabel.text = event.team2Score
            cell.sportNameLabel.text = event.sport
            cell.notesLabel.text = event.notes + event.status
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(liveEvents[indexPath.section].count == 1 && emptySection) {
            return 80
        } else {
            return 200
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
        view.backgroundColor = UIColor.lightGray
        let title = UILabel(frame: CGRect(x: 8, y: 8, width: self.view.bounds.width-16, height: 64))
        title.font = UIFont.systemFont(ofSize: 24)
        title.textAlignment = .center
        title.text = "Live Events for \(dates[section])"
        view.addSubview(title)
        
        if(section == 0) {
            indicator = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            indicator.backgroundColor = UIColor.clear
            indicator.center.y = view.center.y
            view.addSubview(indicator)
        }
    
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func checkForUpdatesOfCurrentDate(date: Date) {
        // If it's the first time loading this viewcontroller
        if(UserDefaults.standard.object(forKey: "lastVisitedLiveEvent") == nil) {
            updateTodaysEvents()
            UserDefaults.standard.set(date, forKey: "lastVisitedLiveEvent")
        } else {
            // Else check if it's been more than 5 minutes to update
            let lastTime = UserDefaults.standard.object(forKey: "lastVisitedLiveEvent") as! Date
            let minutesFromLast = Calendar.current.dateComponents([.minute], from: lastTime, to: date).minute ?? 0
            if(minutesFromLast >= 5) {
                updateTodaysEvents()
            }
        }
    }
    
    func updateTodaysEvents() {
        
        // Find which pages of the NWC site I need to visit, but not multiple times
        var visitedWebsites = [String]()
        let day = liveEvents[0]
        for event in day {
            let abbr = sportToAbbr[event.sport]
            if(!visitedWebsites.contains(abbr!)) {
                visitedWebsites.append(abbr!)
            }
        }
        
        let webScraper = WebScraper()
        indicator.startAnimating()
        indicator.isHidden = false
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            for site in visitedWebsites {
                webScraper.updateLiveEventsFromWebsite(teamAbbreviation: site)
            }
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        })
        
        // Update the date of the last time live events were updated
        UserDefaults.standard.set(Date(), forKey: "lastVisitedLiveEvent")
    }
    
    func loadSpecificEventsForDates(dates: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for i in 0...dates.count-1 {
            liveEvents.append([])
            let request = NSFetchRequest<Event>(entityName: "Event")
            let commitPredicate = NSPredicate(format: "date == %@", dates[i])
            request.predicate = commitPredicate
            do {
                liveEvents[i] = try managedContext.fetch(request)
            }
            catch {
                print("Error = \(error.localizedDescription)")
            }
            if(liveEvents[i].count == 0) {
    
            }
        }
    }
    

}
