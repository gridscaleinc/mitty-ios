//
//  Tab3ViewController.swift
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class SocialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LS(key: "social_resource_manage")
        
        self.view.backgroundColor = UIColor.yellow
        let label = UILabel()
        label.frame = CGRect(x: 200, y: 100, width: 100, height: 100)
        label.text = LS(key: "social_resource_manage")
        self.view.addSubview(label)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
