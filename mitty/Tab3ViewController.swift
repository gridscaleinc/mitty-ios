//
//  Tab3ViewController.swift
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class Tab3ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Mitty Tab3"
        
        self.view.backgroundColor = UIColor.yellow
        let label = UILabel()
        label.frame = CGRect(x: 200, y: 100, width: 100, height: 100)
        label.text = "Tab3"
        self.view.addSubview(label)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
