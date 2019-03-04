//
//  WebScraper.swift
//  ThesisTest
//
//  Created by Trent Callan on 2/26/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftSoup

class WebScraper {
    
    let teamAbbr: [String] = ["bsb", "sball", "mbkb", "wbkb", "msoc", "wsoc", "fball", "mten", "wten", "wlax", "wvball"]
    let abbrDict: [String : String] = ["bsb" : "Baseball", "sball" : "Softball", "mbkb" : "Men's Basketball", "wbkb" : "Women's Basketball", "msoc" : "Men's Soccer", "wsoc" : "Women's Soccer", "fball" : "Football", "mten" : "Men's Tennis", "wten" : "Women's Tennis", "wlax" : "Women's Lacrosse", "wvball" : "Women's Volleyball"]
    let sportToAbbr: [String : String] = ["Baseball": "bsb", "Softball": "sball", "Men's Basketball": "mbkb", "Women's Basketball" : "wbkb", "Men's Soccer" : "msoc", "Women's Soccer" : "wsoc", "Football" : "fball", "Men's Tennis" : "mten", "Women's Tennis" : "wten", "Women's Lacrosse" : "wlax", "Women's Volleyball" : "wvball"]
    
/******************************************************************************************************/
// Functions below in this section are for the standingsCVC
    
    func getAllStandings() {
        for sport in teamAbbr {
            getStandingDataFromWebsite(teamAbbreviation: sport)
        }
    }
    
    func getStandingDataFromWebsite(teamAbbreviation: String) {
        
        let url = URL(string: "https://www.nwcsports.com/sports/\(teamAbbreviation)/2018-19/standings")
        guard let myURL = url else {
            print("Error: \(String(describing: url)) doesn't seem to be a valid URL")
            return
        }
        let html = try! String(contentsOf: myURL, encoding: .utf8)
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            
            // Class:event-group contains all games for a day on most sports web page
            let standingGroups: Elements = try doc.select("[class^=stats-row]")
            
            for standing in standingGroups {
                cssQueryStandings(event: standing, teamAbbreviation: teamAbbreviation)
            }
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
    }
    
    func cssQueryStandings(event: Element, teamAbbreviation: String) {
        
        do {
            // CSS query calls for class names
            let conferenceFields = try event.select("[class=conf-field]")
            let generalFields = try event.select("[class=stats-field]")
            let team = try event.select("[class^=stats-team]")
            // Need to load school based on name so we can add the sports
            let teamName = try team.text()
            
            // Getting strings - be careful of 'get' will get error and crash if there is no element
            let confRecord = try conferenceFields.get(1).text()
            let confRecordComponents = confRecord.components(separatedBy: "-")
            var confWins = ""
            var confLosses = ""
            var confTies = ""
            if(confRecordComponents.count == 2) {
                confWins = confRecordComponents[0]
                confLosses = confRecordComponents[1]
            } else if(confRecordComponents.count == 3) {
                confWins = confRecordComponents[0]
                confTies = confRecordComponents[1]
                confLosses = confRecordComponents[2]
            }
            
            let overallRecord = try generalFields.get(2).text()
            let overallRecordComponents = overallRecord.components(separatedBy: "-")
            var overallWins = ""
            var overallLosses = ""
            var overallTies = ""
            if(overallRecordComponents.count == 2) {
                overallWins = overallRecordComponents[0]
                overallLosses = overallRecordComponents[1]
            } else if(overallRecordComponents.count == 3) {
                overallWins = overallRecordComponents[0]
                overallTies = overallRecordComponents[1]
                overallLosses = overallRecordComponents[2]
            }
            
            let sport = abbrDict[teamAbbreviation]
            addtoSport(schoolName: teamName, sportName: sport!, overallWins: overallWins, overallLosses: overallLosses, overallTies: overallTies, confWins: confWins, confLosses: confLosses, confTies: confTies)
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
        
    }
    
    func addtoSport(schoolName: String, sportName: String, overallWins: String, overallLosses: String, overallTies: String, confWins: String, confLosses: String, confTies: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        // Get the school
        var school = [School]()
        let request = NSFetchRequest<School>(entityName: "School")
        let commitPredicate = NSPredicate(format: "name == %@", schoolName)
        request.predicate = commitPredicate
        do {
            school = try managedContext.fetch(request)
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
        
        let sport = Sport(context: managedContext)
        sport.type = sportName
        sport.nwcLosses = confLosses
        sport.nwcWins = confWins
        sport.nwcTies = confTies
        sport.overallWins = overallWins
        sport.overallLosses = overallLosses
        sport.overallTies = overallTies
        sport.school = school[0]
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }
    
/*****************************************************************************************************/
    
    // Sets up all NWC schools in core data
    func setUpNWCSchools() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let school1 = School(context: managedContext)
        school1.name = "Whitman"
        school1.logo = "whitmanLogo"
        school1.color = Color(color: UIColor.cyan)
        let school2 = School(context: managedContext)
        school2.name = "Whitworth"
        school2.logo = "whitworthLogo"
        school2.color = Color(color: UIColor.red)
        let school3 = School(context: managedContext)
        school3.name = "Linfield"
        school3.logo = "linfieldLogo"
        school3.color = Color(color: UIColor.purple)
        let school4 = School(context: managedContext)
        school4.name = "Puget Sound"
        school4.logo = "pugetsoundLogo"
        school4.color = Color(color: UIColor.red)
        let school5 = School(context: managedContext)
        school5.name = "George Fox"
        school5.logo = "georgefoxLogo"
        school5.color = Color(color: UIColor.blue)
        let school6 = School(context: managedContext)
        school6.name = "Pacific Lutheran"
        school6.logo = "pluLogo"
        school6.color = Color(color: UIColor.yellow)
        let school7 = School(context: managedContext)
        school7.name = "Pacific (Ore.)"
        school7.logo = "pacificLogo"
        school7.color = Color(color: UIColor.cyan)
        let school8 = School(context: managedContext)
        school8.name = "Lewis & Clark"
        school8.logo = "lewisLogo"
        school8.color = Color(color: UIColor.orange)
        let school9 = School(context: managedContext)
        school9.name = "Willamette"
        school9.logo = "willametteLogo"
        school9.color = Color(color: UIColor.yellow)
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }
    
/********************************************************************************************************/
    // Functions below in this section are for schedule2TVC

    func getAllEvents() {
        for sportStr in teamAbbr {
            getEventDataFromWebsite(teamAbbreviation: sportStr)
        }
    }
    
    func getEventDataFromWebsite(teamAbbreviation: String) {
        
        let url = URL(string: "https://www.nwcsports.com/sports/\(teamAbbreviation)/2018-19/schedule")
        guard let myURL = url else {
            print("Error: \(String(describing: url)) doesn't seem to be a valid URL")
            return
        }
        let html = try! String(contentsOf: myURL, encoding: .utf8)
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            // Class:event-group contains all games for a day on most sports web page
            let eventGroups: Elements = try doc.select("[class=event-group]")
            
            for eventDay in eventGroups {
                // There is only one class called event row if there are multiple events on a day
                let multipleRows = try eventDay.select("[class^=event-row]")
                if(multipleRows.size() != 0 ) {
                    for subEventDay in multipleRows {
                        cssQueryEvent(event: subEventDay, sport: abbrDict[teamAbbreviation]!)
                    }
                } else {
                    cssQueryEvent(event: eventDay, sport: abbrDict[teamAbbreviation]!)
                }
            }
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
    }
    
    func cssQueryEvent(event: Element, sport: String) {
        
        do {
            // CSS query calls for class names
            let date = try event.select("[class=date]")
            let team = try event.select("[class^=team-name]")
            let score = try event.select("[class=team-score]")
            let status = try event.select("[class^=status]")
            let notes = try event.select("[class^=notes]")
            let links = try event.select("[class=links]")
            
            // Getting strings - be careful of 'get' will get error and crash if there is no element
            let dateStr = try date.text()
            let team1 = try team.get(0).text()
            let team2 = try team.get(1).text()
            let score1 = try score.get(0).text()
            let score2 = try score.get(1).text()
            let statusStr = try status.get(0).text()
            
            // How to handle cases where a class is used on some events and not others
            var notesStr = ""
            if(notes.size() != 0) {
                notesStr = try notes.get(0).text()
            }
            
            // Getting links
            let link = try links.select("[class=link]")
            let text = try links.select("[class=text]")
            var dict = [String : String]()
            if(link.size() != 0) {
                for idx in 0...link.size()-1 {
                    let href = try link.get(idx)
                    let linkHref: String = try href.attr("href")
                    let txt = try text.get(idx).text()
                    //print("text: \(txt) link: \(linkHref)")
                    dict = [txt : linkHref]
                }
            }
            
            addToEvent(team1: team1, team2: team2, date: dateStr, status: statusStr, notes: notesStr, team1Score: score1, team2Score: score2, sport: sport)
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
        
    }
    
    func addToEvent(team1: String, team2: String, date: String, status: String, notes: String, team1Score: String, team2Score: String, sport: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let event = Event(context: managedContext)
        event.team1 = team1
        event.team2 = team2
        event.team1Score = team1Score
        event.team2Score = team2Score
        event.date = date
        event.status = status
        event.notes = notes
        event.sport = sport
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }
    
/********************************************************************************************************/
    // Functions below in section are for the LiveEventsTVC
    
    func updateLiveEventsFromWebsite(teamAbbreviation: String) {
        
        let url = URL(string: "https://www.nwcsports.com/sports/\(teamAbbreviation)/2018-19/schedule")
        
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
                cssQueryLiveEvent(event: eventDay, sport: abbrDict[teamAbbreviation]!)
            }
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(type) \(message)")
        } catch {
            print("error")
        }
    }
    
    func cssQueryLiveEvent(event: Element, sport: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            // CSS query calls for class names
            let date = try event.select("[class=date]")
            let team = try event.select("[class^=team-name]")
            let score = try event.select("[class=team-score]")
            let status = try event.select("[class^=status]")
            let notes = try event.select("[class^=notes]")
            
            // Getting strings - be careful of 'get' will get error and crash if there is no element
            let dateStr = try date.text()
            let team1 = try team.get(0).text()
            let team2 = try team.get(1).text()
            let score1 = try score.get(0).text()
            let score2 = try score.get(1).text()
            let statusStr = try status.get(0).text()
            
            // How to handle cases where a class is used on some events and not others
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
                
                // Replace old values with new values
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
        
        // Save the updated context
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }
    
/********************************************************************************************************/
    //Delete functions if needed for each core data model
    
    func deleteAll() {
        deleteSports()
        deleteEvents()
        deleteSchools()
    }
    
    func deleteSchools() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Request all schools
        let request1 = NSFetchRequest<School>(entityName: "School")
        do {
            let result1 = try managedContext.fetch(request1)
            for sub1 in result1 {
                managedContext.delete(sub1)
            }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save. \(error), \(error.userInfo)")
            }
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
    }
    
    func deleteSports() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Request all schools
        let request1 = NSFetchRequest<Sport>(entityName: "Sport")
        do {
            let result1 = try managedContext.fetch(request1)
            for sub1 in result1 {
                managedContext.delete(sub1)
            }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save. \(error), \(error.userInfo)")
            }
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
    }
    
    func deleteEvents() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Request all schools
        let request1 = NSFetchRequest<Event>(entityName: "Event")
        do {
            let result1 = try managedContext.fetch(request1)
            for sub1 in result1 {
                managedContext.delete(sub1)
            }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save. \(error), \(error.userInfo)")
            }
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
    }
    
/****************************************************************************************************/
    
    
}
