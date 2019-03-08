//
//  Schedule2TVC.swift
//  ThesisTest
//
//  Created by Trent Callan on 2/11/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit
import CoreData

class ScheduleTableViewController: UITableViewController {

    var events: [Event] = []
    var sport: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the first as selected
        imageArr[0].backgroundColor = UIColor.green
        self.navigationItem.title = "\(sport) Schedule"
        loadEvents()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(240)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedule2cell", for: indexPath) as! ScheduleTableViewCell
        let event = events[indexPath.row]
        cell.dateLabel.text = event.date
        cell.notesLabel.text = event.notes
        cell.team1Label.text = event.team1
        cell.team1ScoreLabel.text = event.team1Score
        cell.team2Label.text = event.team2
        cell.team2ScoreLabel.text = event.team2Score
        return cell
    }
    
    var imageArr: [UIImageView] = [UIImageView(), UIImageView(image: UIImage(named: "willametteLogo")), UIImageView(image: UIImage(named: "pacificLogo")), UIImageView(image: UIImage(named: "pluLogo")), UIImageView(image: UIImage(named: "whitmanLogo")), UIImageView(image: UIImage(named: "whitworthLogo")), UIImageView(image: UIImage(named: "lewisLogo")), UIImageView(image: UIImage(named: "georgefoxLogo")), UIImageView(image: UIImage(named: "pugetsoundLogo")), UIImageView(image: UIImage(named: "linfieldLogo")), ]
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let size: CGFloat = 60
        var xPosition: CGFloat = 5
        var contentSize: CGFloat = 0
        let scrollView = UIScrollView(frame: CGRect(x: 10, y: 5, width: (tableView.frame.width), height: size+10))
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = UIColor.lightGray
        
        for index in 0...imageArr.count-1 {

            let tempImgView = imageArr[index]
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTaps(_:)))
            tempImgView.isUserInteractionEnabled = true
            tempImgView.tag = index
            tempImgView.addGestureRecognizer(tapRecognizer)
            tempImgView.layer.borderWidth = 2
            tempImgView.layer.borderColor = UIColor.white.cgColor
            scrollView.addSubview(tempImgView)
            
            tempImgView.frame.size.height = size
            tempImgView.frame.size.width = size
            tempImgView.frame.origin.x = xPosition
            tempImgView.frame.origin.y = 5
            tempImgView.contentMode = .scaleAspectFit
            xPosition += size
            xPosition += 10
            contentSize += size
        }
        
        scrollView.contentSize = CGSize(width: contentSize + 100, height: size + 10)

        return scrollView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    @objc func handleTaps(_ sender: UITapGestureRecognizer) {
        for img in imageArr {
            img.backgroundColor = UIColor.clear
            img.setNeedsLayout()
            img.layoutIfNeeded()
        }
        
        let imgView: UIImageView = sender.view as! UIImageView
        let index = imgView.tag
        imgView.layer.borderColor = UIColor.black.cgColor
        imgView.backgroundColor = UIColor.green
        imgView.setNeedsLayout()
        imgView.layoutIfNeeded()
        
        var filter = ""
        switch index {
        case 0:
            filter = ""
        case 1:
            filter = "Willamette"
        case 2:
            filter = "Pacific (Ore.)"
        case 3:
            filter = "Pacific Lutheran"
        case 4:
            filter = "Whitman"
        case 5:
            filter = "Whitworth"
        case 6:
            filter = "Lewis & Clark"
        case 7:
            filter = "George Fox"
        case 8:
            filter = "Puget Sound"
        case 9:
            filter = "Linfield"
        default:
            filter = ""
        }
        if(filter == "") {
            loadEvents()
            self.tableView.reloadData()
        } else {
            loadSchoolEvents(schoolToGet: filter)
        }
    }
    
    func loadEvents() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<Event>(entityName: "Event")
        let commitPredicate = NSPredicate(format: "sport == %@", sport)
        request.predicate = commitPredicate
        do {
            events = try managedContext.fetch(request)
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
    }
    
    func loadSchoolEvents(schoolToGet: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Event>(entityName: "Event")
        let commitPredicate1 = NSPredicate(format: "sport == %@", sport)
        let commitPredicate2 = NSPredicate(format: "team1 == %@ OR team2 == %@", schoolToGet, schoolToGet)
        
        let commits = NSCompoundPredicate(andPredicateWithSubpredicates: [commitPredicate1, commitPredicate2])
        request.predicate = commits
        do {
            events = try managedContext.fetch(request)
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
}
