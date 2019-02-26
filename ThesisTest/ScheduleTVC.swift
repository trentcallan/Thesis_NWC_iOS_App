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

class ScheduleTVC: UITableViewController {

    var sportToSend: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.navigationItem.title = "Schedule"
        
        //mens - track and field, swimming, golf and cross country
        //womens - cross country, golf, rowing, track and field, swimming
        //these need a different algorithm to get their data
        
        //works for these: baseball, softball, mens bball, womens bball, mens soccer, womens soccer, football, mens tennis, womens tennis, womens lax and womens volleyball

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamAbbr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = abbrDict[teamAbbr[indexPath.row]]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sportToSend = abbrDict[teamAbbr[indexPath.row]]!
        performSegue(withIdentifier: "toSchedule", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let schedule2TVC = segue.destination as! Schedule2TVC
        schedule2TVC.sport = self.sportToSend
    }

    
}
