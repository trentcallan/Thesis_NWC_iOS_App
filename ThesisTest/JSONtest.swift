//
//  JSONtest.swift
//  ThesisTest
//
//  Created by Trent Callan on 1/28/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class JSONtest: UIViewController {
    
    var fileUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sport1 = Sport(type: "Men's Basketball", NWCwins: 4, NWClosses: 4, overallWins: 8, overallLosses: 6)
        let school1 = School(name: "Willamette University", logo: "willametteLogo", sport: sport1)
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(school1)
        
        fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Sample.json") // Your json file name
        try! jsonData.write(to: fileUrl)
        
        print(fileUrl)
        print(String(data: jsonData, encoding: .utf8)!)
        
        let testData = loadJson(filename: "Sample")
        print("test")
        print(testData?.name)
        print(testData?.logo)
        
    }
    
    func loadJson(filename fileName: String) -> School? {
        //if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(School.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        //}
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
