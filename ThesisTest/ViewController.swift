//
//  ViewController.swift
//  ThesisTest
//
//  Created by Trent Callan on 9/9/18.
//  Copyright © 2018 Trent Callan. All rights reserved.
//

import UIKit
import WebKit

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
        
        let url = URL(string: "https://www.nwcsports.com/sports/wbkb/2018-19/standings")
        let request = URLRequest(url: url!)
        webView.load(request)
        
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

