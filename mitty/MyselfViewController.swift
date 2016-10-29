//
//  MyselfViewController.swift
//
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

// 個人情報を管理するView
//
class MyselfViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "個人情報を管理"
        
        self.view.backgroundColor = UIColor.red
        let label = UILabel()
        label.frame = CGRect(x: 200, y: 100, width: 100, height: 100)
        label.text = "Tab4"
        self.view.addSubview(label)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
