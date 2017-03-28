//
//  ActivityPlanDetailController.swift
//  mitty
//
//  Created by gridscale on 2017/03/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class ActivityPlanDetailsController : UIViewController {
    
    var activityTitle = "活動"
    var form = ActivityPlanDetailsForm()
    
    override func loadView() {
        
        // navigation bar の初期化をする
        
        // activityList を作成する
        
        // 線を引いて、対象年のフィルタボタンを設定する
        
        super.loadView()
        
        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(form)
        
        
        form.loadForm()
        
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
        
    }
    
    
    override func updateViewConstraints() {
        form.autoPin(toTopLayoutGuideOf: self, withInset:0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        form.configLayout()
        super.updateViewConstraints()
        
    }
    
    override func viewDidLoad() {
        
        self.navigationItem.title = activityTitle
        
        self.view.backgroundColor = UIColor.white
    }
    
}
