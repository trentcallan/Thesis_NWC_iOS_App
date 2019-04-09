//
//  ScheduleTVC.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/30/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit
import SwiftSoup
import CoreData

//teamAbbr is used in address of the website to get specific schedules for each sport
//base address is https://www.nwcsports.com/sports/"(enter team abbreviation here)"/2018-19/schedule
var teamAbbr: [String] = ["bsb", "sball", "mbkb", "wbkb", "msoc", "wsoc", "fball", "mten", "wten", "wlax", "wvball"]
var abbrDict: [String : String] = ["bsb" : "Baseball", "sball" : "Softball", "mbkb" : "Men's Basketball", "wbkb" : "Women's Basketball", "msoc" : "Men's Soccer", "wsoc" : "Women's Soccer", "fball" : "Football", "mten" : "Men's Tennis", "wten" : "Women's Tennis", "wlax" : "Women's Lacrosse", "wvball" : "Women's Volleyball"]
var sportToAbbr: [String : String] = ["Baseball": "bsb", "Softball": "sball", "Men's Basketball": "mbkb", "Women's Basketball" : "wbkb", "Men's Soccer" : "msoc", "Women's Soccer" : "wsoc", "Football" : "fball", "Men's Tennis" : "mten", "Women's Tennis" : "wten", "Women's Lacrosse" : "wlax", "Women's Volleyball" : "wvball"]

class SportForScheduleTableViewController: UITableViewController {

    var sportToSend: String = ""
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(indicator)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Find if it's been more than a day since updating
        let lastTime = UserDefaults.standard.object(forKey: "lastVisitedSchedule") as! Date
        let dayFromLast = Calendar.current.dateComponents([.day], from: lastTime, to: Date()).day ?? 0
        if(dayFromLast >= 1) {
            // Start animating the indicator to show user background work is being done
            indicator.isHidden = false
            indicator.startAnimating()
            
            let webScraper = WebScraper()
            // Update all data on the background thread
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                webScraper.getAllEvents()
                
                // Update the UI on the main thread
                DispatchQueue.main.async(execute: {
                    do {
                        try webScraper.managedContext.save()
                    } catch let error as NSError {
                        print("could not save. \(error), \(error.userInfo)")
                    }
                    self.indicator.stopAnimating()
                })
            })
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamAbbr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 24)
        cell.textLabel?.text = abbrDict[teamAbbr[indexPath.row]]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sportToSend = abbrDict[teamAbbr[indexPath.row]]!
        performSegue(withIdentifier: "toSchedule", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scheduleTVC = segue.destination as! ScheduleTableViewController
        scheduleTVC.sport = self.sportToSend
    }

    
}
