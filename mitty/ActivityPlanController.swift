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
    
    override func viewDidLoad() {
        
        
        // navigation bar の初期化をする
        
        // activityList を作成する
        
        // 線を引いて、対象年のフィルタボタンを設定する
        
        super.viewDidLoad()
        self.navigationItem.title = "活動内容入力画面"
        
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 1.0)
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 100, width: 300, height: 100)
        label.text = "工事中。。。。。誰かがやってよ。"
        label.textColor = .white
        
        self.view.addSubview(label)
        
        self.view.setNeedsLayout()
        
        
    }
}
