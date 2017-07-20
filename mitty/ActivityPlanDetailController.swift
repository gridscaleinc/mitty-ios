//
//  ActivityPlanDetailController.swift
//  mitty
//
//  Created by gridscale on 2017/03/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class ActivityPlanDetailsController : MittyViewController {
    
    var activityTitle = "活動計画詳細"
    var form = ActivityPlanDetailsForm()
    
    var status = 2
    
    var activityInfo : ActivityInfo
    
    init(_ activity: ActivityInfo) {
        activityInfo = activity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        // navigation bar の初期化をする
        
        // activityList を作成する
        
        // 線を引いて、対象年のフィルタボタンを設定する
        
        super.loadView()
        
        self.form.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(form)
        
        ActivityService.instance.fetch(id: activityInfo.id) { [weak self]
            activityDetail in
            self?.form.loadForm(activityDetail)
            self?.view.setNeedsUpdateConstraints() // bootstrap Auto Layout

            self?.form.quest("[name=addItem]").bindEvent(for: .touchUpInside) { [weak self]
                c in
                let vc = ActivityPlanViewController((self?.activityInfo)!)
                let t = (c as! UIButton).titleLabel?.text
                if t == "✈️" {
                    vc.activityTitle = "航空券計画"
                    vc.type = "FLIGHT"
                } else if t == "🏩" {
                    vc.activityTitle = "ホテル"
                    vc.type = "HOTEL"
                } else if t == "🚗" {
                    vc.activityTitle = "電車・車の移動"
                    vc.type = "MOVING"
                } else if t == "🍴" {
                    vc.activityTitle = "食事・休憩"
                    vc.type = "FOOD"
                } else {
                    vc.activityTitle = "任意"
                    vc.type = "ANY"
                    
                }
                
                self?.navigationController?.pushViewController(vc, animated: true)
            }

        }
        
        
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
        
        super.autoCloseKeyboard()
        
        self.navigationItem.title = activityTitle
        
        self.view.backgroundColor = UIColor.white
        
        if (activityInfo.mainEventId == nil || activityInfo.mainEventId == "" || activityInfo.mainEventId == "0") {
            form.mainEventButton.bindEvent(.touchUpInside) { [weak self]
                v in
                let vc = ActivitySelectionViewController((self?.activityInfo)!)
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.status = 3
            }
        } else {
            form.eventTitle.bindEvent(.touchUpInside) {
                v in
                EventService.instance.fetch(id: self.activityInfo.mainEventId!) {
                    event in
                    let c = EventDetailViewController(event: event)
                    self.navigationController?.pushViewController(c, animated: true)
                }
            }
            
        }
        
        form.requestButton.bindEvent(.touchUpInside) {
            v in
            let c = RequestViewController()
            c.relatedActivity = self.activityInfo
            self.navigationController?.pushViewController(c, animated: true)
        }
        
        form.itemTapped = self.itemTapped
        form.activityTapped = self.activityTapped
    }
    
    // activity item tapped
    func itemTapped (_ item: ActivityItem) {
        let vc = EditItemViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // activity taped
    func activityTapped () {
        let vc = EditViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
