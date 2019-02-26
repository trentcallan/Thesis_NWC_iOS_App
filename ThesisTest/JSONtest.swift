//
//  JSONtest.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/28/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

/*import UIKit

class JSONtest: UIViewController {
    
    var fileUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let sport1 = Sport(type: "Men's Basketball", NWCwins: 4, NWClosses: 4, overallWins: 8, overallLosses: 6)
        let sport2 = Sport(type: "Women's Basketball", NWCwins: 3, NWClosses: 1, overallWins: 2, overallLosses: 6)
        let school1 = School(name: "Willamette University", logo: "willametteLogo", sports: [sport1, sport2])
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(school1)
        
        fileUrl = Bundle.main.url(forResource: "JSONData", withExtension: "json")
        /*fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Sample.json") // Your json file name*/
        try! jsonData.write(to: fileUrl)
        
        print(fileUrl)
        print(String(data: jsonData, encoding: .utf8)!)
        
        let testData = loadJson(filename: "JSONData")
        print("test")
        print(testData?.name)
        print(testData?.logo)
        
    }
    
    func loadJson(filename fileName: String) -> School? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(School.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}*/
