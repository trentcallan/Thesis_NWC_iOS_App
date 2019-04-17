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
    var schools: [School] = []
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = true
        self.tableView.separatorStyle = .none
        self.tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "liveEventsReuseIdentifier")
        self.tableView.register(EmptyEventTableViewCell.self, forCellReuseIdentifier: "emptyEventReuseIdentifier")
        
        // Getting today and tomorrow's date and using those to populate the tableview
        let date = Date()
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        let result1 = formatter.string(from: date)
        let result2 = formatter.string(from: nextDay!)
        dates.append(result1)
        dates.append(result2)
        
        schools.loadSchools()
        loadSpecificEventsForDates(dates: dates)
        checkForUpdatesOfCurrentDate(date: date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
        // Deselect the selected row
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNil = selectedRow {
            tableView.deselectRow(at: selectedRowNotNil, animated: false)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return liveEvents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the section is empty then add a temporary empty event so I can
        // Add a empty cellview later
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
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "liveEventsReuseIdentifier", for: indexPath) as! EventTableViewCell
            let event = dayEvents[indexPath.row]
        
            cell.team1Label.text = event.team1
            cell.team2Label.text = event.team2
            cell.team1ScoreLabel.text = event.team1Score
            cell.team2ScoreLabel.text = event.team2Score
            if(event.team1Score != "" && event.team2Score != "") {
                cell.scoreDividerLabel.text = "-"
            }
            cell.sportNameLabel.text = event.sport
            if(event.notes != "") {
                cell.notesLabel.text = event.status + "\n" + event.notes
            } else {
                cell.notesLabel.text = event.status
            }
            cell.team1ImageView.image = nil
            cell.team2ImageView.image = nil
            if let logoString1 = event.team1Logo {
                cell.team1ImageView.image = UIImage(named: logoString1)
            }
            if let logoString2 = event.team2Logo {
                cell.team2ImageView.image = UIImage(named: logoString2)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = liveEvents[indexPath.section][indexPath.row]
        if let links = event.links as? Links {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "eventDetailsViewController") as! EventDetailsViewController
            viewController.links = links
            viewController.event = event
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
        view.backgroundColor = UIColor.lightGray
        let title = UILabel(frame: CGRect(x: 8, y: 8, width: self.view.bounds.width-16, height: 64))
        title.font = UIFont.systemFont(ofSize: 24)
        title.textAlignment = .center
        title.text = "\(dates[section])"
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
            if(minutesFromLast >= 2) {
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
                do {
                    try webScraper.managedContext.save()
                } catch let error as NSError {
                    print("could not save. \(error), \(error.userInfo)")
                }
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        })
        
        // Update the date of the last time live events were updated
        UserDefaults.standard.set(Date(), forKey: "lastVisitedLiveEvent")
    }
    
    func loadSpecificEventsForDates(dates: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let privateManagedContext = appDelegate.updateContext
        
        for i in 0...dates.count-1 {
            liveEvents.append([])
            let request = NSFetchRequest<Event>(entityName: "Event")
            let commitPredicate = NSPredicate(format: "date == %@", dates[i].toDate() as NSDate)
            request.predicate = commitPredicate
            do {
                liveEvents[i] = try privateManagedContext.fetch(request)
            }
            catch {
                print("Error = \(error.localizedDescription)")
            }
        }
    }
    

}
