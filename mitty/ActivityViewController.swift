//
//  Tab1ViewController.swift
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class ActivityViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Mitty"
        
        self.view.backgroundColor = UIColor.white
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 100, width: 400, height: 100)
        label.text = "活動予定管理"
        self.view.addSubview(label)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
