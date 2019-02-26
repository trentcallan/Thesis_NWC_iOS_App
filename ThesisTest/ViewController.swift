//
//  ViewController.swift
//  ThesisTest
//
//  Created by Trent Callan on 9/9/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

/*import UIKit
import WebKit
import SwiftSoup

class ViewController: UIViewController {

    let webView = WKWebView()
    
    @IBOutlet weak var inputTxtField: UITextField!
    @IBOutlet weak var outputLbl: UILabel!
    @IBOutlet weak var index: UITextField!
    
    //bball names
    //event-date accent-bg
    //event-group
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mens - track and field, swimming, golf and cross country
        //womens - cross country, golf, rowing, track and field, swimming
        //these need a different algorithm to get their data
        
        //works for these
        //https://www.nwcsports.com/sports/bsb/2018-19/schedule - baseball
        //https://www.nwcsports.com/sports/sball/2018-19/schedule - softball
        //https://www.nwcsports.com/sports/mbkb/2018-19/schedule - mens bball
        //https://www.nwcsports.com/sports/wbkb/2018-19/schedule - womens bball
        //https://www.nwcsports.com/sports/msoc/2018-19/schedule - mens soccer
        //https://www.nwcsports.com/sports/wsoc/2018-19/schedule - womens soccer
        //https://www.nwcsports.com/sports/fball/2018-19/schedule - football
        //https://www.nwcsports.com/sports/mten/2018-19/schedule - mens tennis
        //https://www.nwcsports.com/sports/wten/2018-19/schedule - womens tennis
        //https://www.nwcsports.com/sports/wlax/2018-19/schedule - womens lax
        //https://www.nwcsports.com/sports/wvball/2018-19/schedule - volleyball
        
        let teamAbbreviations = ["bsb", "sball", "mbkb", "wbkb", "msoc", "wsoc", "fball", "mten", "wten", "wlax", "wvball"]
        let abbrDict: [String : String] = ["bsb" : "baseball", "sball" : "softball", "mbkb" : "men's basketball", "wbkb" : "women's basketball", "msoc" : "men's soccer", "wsoc" : "women's soccer", "fball" : "football", "mten" : "men's tennis", "wten" : "women's tennis", "wlax" : "women's lacrosse", "wvball" : "women's volleyball"]
        
        
        let url = URL(string: "https://www.nwcsports.com/sports/\(teamAbbreviations[6])/2018-19/schedule")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        guard let myURL = url else {
            print("Error: \(String(describing: url)) doesn't seem to be a valid URL")
            return
        }
        let html = try! String(contentsOf: myURL, encoding: .utf8)
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            //class:event-group contains all games for a day on most sports web page
            let eventGroups: Elements = try doc.select("[class=event-group]" ?? "")
            
            for eventDay in eventGroups {
                let multipleRows = try eventDay.select("[class^=event-row]" ?? "")
                if(multipleRows.size() != 0 ) {
                    for subEventDay in multipleRows {
                        cssQueryEvent(event: subEventDay)
                    }
                } else {
                    cssQueryEvent(event: eventDay)
                }
            }
            
            let jsonEncoder = JSONEncoder()
            let jsonData = try! jsonEncoder.encode(events)
            
            let testURL = Bundle.main.url(forResource: "Events", withExtension: "json")
            
            fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Events.json") // Your json file name
            try! jsonData.write(to: fileUrl)
            
            let testData: [Event] = loadJson(filename: "Events")!
            print("\n\n\ntest0")
            print(testData[0].date)
            print(testData[0].team1)
            print(testData[0].team2)
            
            print("\n\n\ntest1")
            print(testData[1].date)
            print(testData[1].team1)
            print(testData[1].team2)
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
        
        /*let url = URL(string: "https://www.nwcsports.com/sports/wbkb/2018-19/standings")
        let request = URLRequest(url: url!)
        webView.load(request)*/
        
    }
    
    var events: [Event] = []
    func cssQueryEvent(event: Element) {
    
        do {
        //css query calls for class names
        let date = try event.select("[class=date]" ?? "")
        let team = try event.select("[class^=team-name]" ?? "")
        let score = try event.select("[class=team-score]" ?? "")
        let status = try event.select("[class^=status]" ?? "")
        let notes = try event.select("[class^=notes]" ?? "")
        let links = try event.select("[class=links]" ?? "")
        
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
            
        let link = try links.select("[class=link]" ?? "")
        let text = try links.select("[class=text]" ?? "")
        var dict = [String : String]()
        if(link.size() != 0) {
            for idx in 0...link.size()-1 {
                let href = try link.get(idx)
                let linkHref: String = try href.attr("href")
                let txt = try text.get(idx).text()
                print("text: \(txt) link: \(linkHref)")
                dict = [txt : linkHref]
            }
        }
        //let event1 = Event(homeSchool: team1, awaySchool: team2, date: dateStr, status: statusStr, notes: notesStr, homeTeamScore: score1, awayTeamScore: score2, links: dict)
        //events.append(event1)
        
        print("date: \(dateStr)\nteam1: \(team1) score: \(score1)\nteam2: \(team2) score: \(score2)\nstatus: \(statusStr)\nnotes: \(notesStr)")
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
        
    }
    
    var fileUrl: URL!
    func loadJson(filename fileName: String) -> [Event]? {
        //if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([Event].self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
        //}
        return nil
    }
    
    @IBAction func EvaluateJS(_ sender: Any) {
        var txt = "event-date accent-bg"
        var position = 0;
        if let idx = index.text { position = Int(idx)! }
        if let temp = inputTxtField.text {
            txt = temp
        }
        webView.evaluateJavaScript("document.getElementsByClassName('\(txt)')[\(position)].innerHTML") { (value, error) in
            
            self.outputLbl.text = "\(value)"
            print("value: \(value)")
            print("error: \(error)")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
*/
