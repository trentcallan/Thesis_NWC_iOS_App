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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        let result = formatter.string(from: date)
        todaysDate = result
        
        loadSpecificEvents(currentDate: result)
        updateTodaysEvents()
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
        for site in visitedWebsites {
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                self.getDataFromWebsite(teamAbbreviation: site)
            })
        }
        self.tableView.reloadData()
    }
    
    func getDataFromWebsite(teamAbbreviation: String) {
        
        //let webView = WKWebView()
        let url = URL(string: "https://www.nwcsports.com/sports/\(teamAbbreviation)/2018-19/schedule")
        //let request = URLRequest(url: url!)
        //webView.load(request)
        
        guard let myURL = url else {
            print("Error: \(String(describing: url)) doesn't seem to be a valid URL")
            return
        }
        let html = try! String(contentsOf: myURL, encoding: .utf8)
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let eventGroups = try doc.select("[class*=event-row][class*=inprogress]")
            print(eventGroups.size())
            for eventDay in eventGroups {
                cssQueryEvent(event: eventDay, sport: abbrDict[teamAbbreviation]!)
            }
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(type) \(message)")
        } catch {
            print("error")
        }
    }
    
    func cssQueryEvent(event: Element, sport: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            //css query calls for class names
            let date = try event.select("[class=date]")
            let team = try event.select("[class^=team-name]")
            let score = try event.select("[class=team-score]")
            let status = try event.select("[class^=status]")
            let notes = try event.select("[class^=notes]")
            
            //getting strings - be careful of 'get' will get error and crash if there is no element
            let dateStr = try date.text()
            let team1 = try team.get(0).text()
            let team2 = try team.get(1).text()
            let score1 = try score.get(0).text()
            let score2 = try score.get(1).text()
            let statusStr = try status.get(0).text()
            
            //how to handle cases where a class is used on some events and not others
            var notesStr = ""
            if(notes.size() != 0) {
                notesStr = try notes.get(0).text()
            }
            
            
            var currentEvents = [Event]()
            let request = NSFetchRequest<Event>(entityName: "Event")
            let commitPredicate1 = NSPredicate(format: "team1 == %@", team1)
            let commitPredicate2 = NSPredicate(format: "team2 == %@", team2)
            let commitPredicate3 = NSPredicate(format: "date == %@", dateStr)
            let commitPredicate4 = NSPredicate(format: "sport == %@", sport)
            let commits = NSCompoundPredicate(andPredicateWithSubpredicates: [commitPredicate1, commitPredicate2, commitPredicate3, commitPredicate4])
            request.predicate = commits
             
            do {
                currentEvents = try managedContext.fetch(request)
            } catch {
                print("Error = \(error.localizedDescription)")
            }
            
            if(currentEvents.count > 0) {
                let currentEvent = currentEvents[0]
                print("sport: \(currentEvent.sport)\nteam1: \(currentEvent.team1)score: \(score1)\nteam2: \(currentEvent.team2)score: \(score2)\nstatus: \(statusStr)\nnotes: \(notesStr)")
                
                //replace old values with new values
                currentEvent.team1 = team1
                currentEvent.team2 = team2
                currentEvent.team1Score = score1
                currentEvent.team2Score = score2
                //currentEvent.date = dateStr
                currentEvent.status = statusStr
                currentEvent.notes = notesStr
                //currentEvent.sport = sport
            }
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(type) \(message)")
        } catch {
            print("error")
        }
        
        //save the updated context
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
