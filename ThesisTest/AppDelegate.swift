//
//  AppDelegate.swift
//  ThesisTest
//
//  Created by Trent Callan on 9/9/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit
import CoreData
import SwiftSoup

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        if(UserDefaults.standard.bool(forKey: "haveThingsBeenDownloaded") == nil) {
            UserDefaults.standard.set(false, forKey: "haveThingsBeenDownloaded")
        }

        //print("Things have been downloaded:  \(UserDefaults.standard.bool(forKey: "haveThingsBeenDownloaded"))")
        
        //if everything hasn't been downloaded
        if(!UserDefaults.standard.bool(forKey: "haveThingsBeenDownloaded")) {
            //make sure everything is deleted first
            deleteAll()
            //set up the NWC schools (there are 9)
            setUpNWCSchools()
            //get standings and events from NWC website and save them to core data
            getAllStandings()
            getAllEvents()
            //everything has been downloaded
            UserDefaults.standard.set(true, forKey: "haveThingsBeenDownloaded")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
/******************************************************************************************************/

    func deleteAll() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //request all schools, sports and events in core data
        let request1 = NSFetchRequest<School>(entityName: "School")
        let request2 = NSFetchRequest<Sport>(entityName: "Sport")
        let request3 = NSFetchRequest<Event>(entityName: "Event")
        do {
            let result1 = try managedContext.fetch(request1)
            for sub1 in result1 {
                managedContext.delete(sub1)
            }
            
            let result2 = try managedContext.fetch(request2)
            for sub2 in result2 {
                managedContext.delete(sub2)
            }
            
            let result3 = try managedContext.fetch(request3)
            for sub3 in result3 {
                managedContext.delete(sub3)
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
        print("done deleting")
    }
    
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
            
            //class:event-group contains all games for a day on most sports web page
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
            //css query calls for class names
            let conferenceFields = try event.select("[class=conf-field]")
            let generalFields = try event.select("[class=stats-field]")
            let team = try event.select("[class^=stats-team]")
            //need to load school based on name so we can add the sports
            let teamName = try team.text()
            
            //getting strings - be careful of 'get' will get error and crash if there is no element
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
            //print("\(teamName) conf: \(confWins)-\(confTies)-\(confLosses) overall: \(overallWins)-\(overallTies)-\(overallLosses)")
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
        
    }
    
    func addtoSport(schoolName: String, sportName: String, overallWins: String, overallLosses: String, overallTies: String, confWins: String, confLosses: String, confTies: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        //get the school
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
    
/******************************************************************************************************/
    
    //sets up all NWC schools in core data
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
    
/******************************************************************************************************/
    
    //gets all the events from NWC website
    //all functions below help
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
            //class:event-group contains all games for a day on most sports web page
            let eventGroups: Elements = try doc.select("[class=event-group]")
            
            for eventDay in eventGroups {
                //there is only a class called event row if there are multiple events on a day
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
            //css query calls for class names
            let date = try event.select("[class=date]")
            let team = try event.select("[class^=team-name]")
            let score = try event.select("[class=team-score]")
            let status = try event.select("[class^=status]")
            let notes = try event.select("[class^=notes]")
            let links = try event.select("[class=links]")
            
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
            
            //getting links
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
            //print("date: \(dateStr)\nteam1: \(team1) score: \(score1)\nteam2: \(team2) score: \(score2)\nstatus: \(statusStr)\nnotes: \(notesStr)")
            
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
    
    
}

