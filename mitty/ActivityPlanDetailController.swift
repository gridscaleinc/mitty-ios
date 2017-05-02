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
    
    var activityTitle = "活動計画詳細"
    var form = ActivityPlanDetailsForm()
    
    var status = 2
    
    override func loadView() {
        
        // navigation bar の初期化をする
        
        // activityList を作成する
        
        // 線を引いて、対象年のフィルタボタンを設定する
        
        super.loadView()
        
        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(form)
        
        
        form.loadForm(status)
        
        
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
        
        if (status == 1) {
            form.mainEventButton.bindEvent(.touchUpInside) { [weak self]
                v in
                let vc = ActivitySelectionViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.status = 3
            }
        } else {
            
            form.eventTitle.bindEvent(.touchUpInside) {
                v in
                let e = EventService.instance.buildEvent(1)
                let c = EventDetailViewController(event: e!)
                
                self.navigationController?.pushViewController(c, animated: true)
                
            }
        }
    }
    
}
