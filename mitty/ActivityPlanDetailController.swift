//
//  ActivityPlanDetailController.swift
//  mitty
//
//  Created by gridscale on 2017/03/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class ActivityPlanDetailsController: MittyViewController {

    var activityTitle = "活動計画詳細"
    var form = ActivityPlanDetailsForm()

    var status = 2

    var activityInfo: ActivityInfo
    var shouldReloadView = false
    init(_ activity: ActivityInfo) {
        activityInfo = activity
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var constrainsInited = false
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !shouldReloadView {
            form.autoPin(toTopLayoutGuideOf: self, withInset: 20)
            form.autoPinEdge(toSuperviewEdge: .top)
            form.autoPinEdge(toSuperviewEdge: .left)
            form.autoPinEdge(toSuperviewEdge: .right)
            form.autoPinEdge(toSuperviewEdge: .bottom)
        }
        
        if (!constrainsInited) {
            if (activityLoaded) {
                form.configLayout()
            }
            constrainsInited = true
        }
    }

    override func viewDidLoad() {

        super.autoCloseKeyboard()

        self.navigationItem.title = activityTitle

        self.view.backgroundColor = UIColor.white

        
    }

    
    /// <#Description#>
    ///
    /// - Parameter animated: <#animated description#>
    override func loadView() {
        super.loadView()
        view.addSubview(form)
        loadActivity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
        if shouldReloadView {
            loadActivity()
        }
        
    }
    
    // activity item tapped
    func itemTapped (_ item: ActivityItem) {
        let vc = EditItemViewController(item)
        self.navigationController?.pushViewController(vc, animated: true)
        shouldReloadView = true
    }

    // activity taped
    func activityTapped () {
        let vc = EditViewController(activityInfo)
        vc.onEditComplete = {
            info in
            self.form.title.label.text = info.title
            self.form.memo.label.text = info.memo
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func openEvent(_ eventId: String) {
        EventService.instance.fetch(id: self.activityInfo.mainEventId!) {
            event in
            let c = EventDetailViewController(event: event)
            self.navigationController?.pushViewController(c, animated: true)
        }
    }
    
    var activityLoaded = false
    func loadActivity() {

        ActivityService.instance.fetch(id: activityInfo.id) { [weak self]
            activityDetail in
            let a = (self?.activityInfo)!
            activityDetail.info.logoUrl = a.logoUrl
            activityDetail.info.startDateTime = a.startDateTime
            self?.activityInfo = activityDetail.info
            
            if (self?.activityLoaded)! {
                self?.form.reset()
            } else {
                self?.bindEvents()
            }
            
            self?.constrainsInited = false
            self?.form.loadForm(activityDetail)
            self?.view.setNeedsUpdateConstraints() // bootstrap Auto Layout
            
            self?.activityLoaded = true
            
        }
    }
    
    func bindEvents() {
        if (activityInfo.mainEventId == nil || activityInfo.mainEventId == "" || activityInfo.mainEventId == "0") {
            form.mainEventButton.bindEvent(.touchUpInside) { [weak self]
                v in
                let vc = ActivityPlanViewController((self?.activityInfo)!)
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.status = 3
            }
        } else {
            form.eventTitle.bindEvent(.touchUpInside) {
                v in
                self.openEvent(self.activityInfo.mainEventId!)
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
        form.openEventHandler = openEvent
        
        form.quest("[name=addItem]").bindEvent(for: .touchUpInside) { [weak self]
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
