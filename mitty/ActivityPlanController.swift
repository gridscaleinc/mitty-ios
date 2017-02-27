//
//  ActivityPlanViewController.swift
//  mitty
//
//  Created by gridscale on 2017/01/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class ActivityPlanViewController : UIViewController {
    
    var activityTitle = "活動"
    var form = ActivityInputForm()
    
    override func viewDidLoad() {
        
        
        // navigation bar の初期化をする
        
        // activityList を作成する
        
        // 線を引いて、対象年のフィルタボタンを設定する
        
        super.viewDidLoad()
        
        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(form)
        form.autoPin(toTopLayoutGuideOf: self, withInset:0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        form.loadPage()
        
        self.navigationItem.title = activityTitle
        
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 1.0)
        
        self.view.setNeedsLayout()
        
        
    }
}
