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

class LiveEventsTVC: UITableViewController {

    var liveEvents = [Event]()
    var todaysDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        let result = formatter.string(from: date)
        todaysDate = result
        loadSpecificEvents(currentDate: todaysDate)
        
        //if it's the first time loading this viewcontroller
        if(UserDefaults.standard.object(forKey: "lastVisitedLiveEvent") == nil) {
            UserDefaults.standard.set(date, forKey: "lastVisitedLiveEvent")
        }
        
        let lastTime = UserDefaults.standard.object(forKey: "lastVisitedLiveEvent") as! Date
        let minutesFromLast = Calendar.current.dateComponents([.minute], from: lastTime, to: date).minute ?? 0
        print("minutes last: \(minutesFromLast)")
        
        if(minutesFromLast > 5) {
            updateTodaysEvents()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveEvent", for: indexPath) as! LiveEventCell
        let event = liveEvents[indexPath.row]
        cell.team1.text = event.team1
        cell.team2.text = event.team2
        cell.team1Score.text = event.team1Score
        cell.team2Score.text = event.team2Score
        cell.sport.text = event.sport
        cell.notes.text = event.notes + event.status
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Live Events for \(todaysDate)"
    }
    
    func updateTodaysEvents() {
        var visitedWebsites = [String]()
        for event in liveEvents {
            let abbr = sportToAbbr[event.sport]
            if(!visitedWebsites.contains(abbr!)) {
                visitedWebsites.append(abbr!)
                print(abbr!)
            }
        }

            DispatchQueue.global(qos: .userInitiated).async(execute: {
                for site in visitedWebsites {
                    let webScraper = WebScraper()
                    webScraper.updateLiveEventsFromWebsite(teamAbbreviation: site)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        
        //update the date of the last time live events were updated
        UserDefaults.standard.set(Date(), forKey: "lastVisitedLiveEvent")
    }
    
    func loadSpecificEvents(currentDate: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<Event>(entityName: "Event")
        let commitPredicate = NSPredicate(format: "date == %@", currentDate)
        request.predicate = commitPredicate
        do {
            liveEvents = try managedContext.fetch(request)
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
    }
    

}
