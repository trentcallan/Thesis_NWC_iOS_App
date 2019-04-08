//
//  InitialScreenViewController.swift
//  ThesisTest
//
//  Created by Trent Callan on 3/11/19.
//  Copyright © 2019 Trent Callan. All rights reserved.
//

import UIKit

class InitialScreenViewController: UIViewController {

    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let size = UIScreen.main.bounds.size
        let indicator = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        indicator.alpha = 1.0
        indicator.style = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let webScraper = WebScraper()
        webScraper.downloadSchoolData()
        
        indicator.stopAnimating()
        self.performSegue(withIdentifier: "toTabBar", sender: self)
    }

}
