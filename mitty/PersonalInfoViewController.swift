//
//  SampleViewController.swift
//  mitty
//
//  Created by gridscale on 2016/10/31.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class PersonalInfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "個人情報詳細表示"
        
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.9)
        let label = UILabel()
        label.frame = CGRect(x: 100, y: 100, width: 300, height: 100)
        label.text = "ここで個人情報の詳細を表示お願いします"
        self.view.addSubview(label)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
