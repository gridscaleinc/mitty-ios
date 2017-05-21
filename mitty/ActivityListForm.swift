//
//  ActivityListForm.swift
//  mitty
//
//  Created by gridscale on 2017/02/25.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

@objc(ActivityListForm)
class ActivityListForm : MQForm {
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var activityList : [ActivityInfo] = [ ]
    
    func loadForm () {
        
        var page = self as MQForm
        
        let header = Header()
        page += header
        
        header.layout() { (v) in
            v.view.autoPinEdge(toSuperviewEdge: .top, withInset:10)
            v.view.autoSetDimension(.height, toSize: 0)
        }
        
        
        let data = buildActivityData()
        page +++ data
        data.layout() { (main) in
            main.putUnder(of: header).fillHolizon().down(withInset: 3)
        }
        
    }
    
    func load () {
        
        //collectionView.reloadData()
    }
    
    func buildActivityData() -> Control {
        
        let scrollView = UIScrollView.newAutoLayout()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat((activityList.count + 3) * 50))
        scrollView.isScrollEnabled = true
        scrollView.flashScrollIndicators()
        scrollView.canCancelContentTouches = false


//        scrollView.backgroundColor = UIColor.blue

        var container = Container(name:"Scroll-View", view:scrollView)
        let section = Section(name: "section-activity-data", view: UIView.newAutoLayout())
        container += section
        
        var row = newTitleRow()
        section <<< row
        row +++ MQForm.label(name: "activity-title", title: "計画中").layout {
            l in
            l.label.textColor = .orange
            l.height(20).fillParent()
        }
        
        var outstandingActivity = [ActivityInfo]()
        var planedActivity = [ActivityInfo]()
        
        for t in activityList {
            if t.hasEvent {
                planedActivity.append(t)
            } else {
                outstandingActivity.append(t)
            }
        }
        
        for t in outstandingActivity {
            let row = Row.LeftAligned()
            section <<< row
            
            let l = MQForm.label(name: "activitylabel", title: t.title).width(200).height(30)
            row +++ l
            
            // ラベルに紐つくactivityを保存
            (l.label as! TapableLabel).underlyObj = t
            
            row.layout(){ r in
                r.fillHolizon(20).height(40)
            }
        }
        
        if outstandingActivity.count == 0 {
            let row = Row.LeftAligned()
            section <<< row
            
            row +++ MQForm.label(name: "activity-content", title: "予定なし").layout {
                l in
                l.label.textColor = .gray
            }
        }
        
        row = newTitleRow()
        
        section <<< row
        row +++ MQForm.label(name: "activity-title", title: "活動予定一覧").layout {
            l in
            l.label.textColor = .orange
            l.fillParent().height(20)
        }

        for t in planedActivity {
            let row = Row.LeftAligned()
            section <<< row
            
            row +++ MQForm.label(name: "activityDate", title: t.monthDay).layout {
                 d in
                 d.label.textColor = .orange
                 d.width(50).height(30)
            }

            let l = MQForm.label(name: "activitylabel", title: t.title).width(200).height(30)
            row +++ l
            
            // ラベルに紐つくactivityを保存
            (l.label as! TapableLabel).underlyObj = t
                
            row +++ MQForm.img(name:"icon", url: t.logoUrl).width(30).height(20)

            row.layout(){ r in
                let w = UIScreen.main.bounds.size.width - 20
                r.leftMost().rightMost().height(40).width(w)
            }
        }
        if planedActivity.count == 0 {
            let row = Row.LeftAligned()
            section <<< row
            
            row +++ MQForm.label(name: "activity-content", title: "予定なし").layout {
                l in
                l.label.textColor = .gray
            }
        }
        
        row = newTitleRow()
        
        section <<< row
        row +++ MQForm.label(name: "activity-title", title: "招待一覧").layout {
            l in
            l.label.textColor = .orange
            l.height(20).fillParent()
        }
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(30)
        }
        
        section <<< row
        
        row +++ MQForm.label(name: "activity-content", title: "予定なし").layout {
            l in
            l.label.textColor = .gray
        }
        
        
        row = newTitleRow()
        
        section <<< row
        row +++ MQForm.label(name: "activity-title", title: "リクエスト一覧").layout {
            l in
            l.label.textColor = .orange
            l.height(20).fillParent()
        }
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(30)
        }

        
        section <<< row
        
        row +++ MQForm.label(name: "activity-content", title: "予定なし").layout {
            l in
            l.label.textColor = .gray
        }
        section.layout() { [weak self]s in
            let height = 40.0*(CGFloat((self?.activityList.count)!) + 6)
            s.upper().width(UIScreen.main.bounds.size.width).height(height)
        }
        
        
        return container
    }
    
    func newTitleRow() -> Row {
        let row =  Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(20)
            r.view.backgroundColor = UIColor(white: 0.96, alpha: 1)
        }
        return row
    }
}
