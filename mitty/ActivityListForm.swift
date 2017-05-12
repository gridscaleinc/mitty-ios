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
            main.putUnder(of: header).fillHolizon().down(withInset: 125)
        }
        
        let redLine = Control(view:HL(UIColor.red))
        page +++ redLine
        
        redLine.layout() { (hl) in
            hl.fillHolizon()
            hl.putUnder(of: data)
        }
        
        
        let buttons = Row()
        buttons.distribution = .atIntervals
        
//        let buttons = Row.LeftAligned()
        let thisYearButton :Control = MQForm.button(name: "thisYear", title: "今年").layout() { (button) in
            button.width(80).height(50)
        }
        
        buttons +++ thisYearButton
    
        let nextYearButton : Control = MQForm.button(name: "nextYear", title: "来年").layout() { (button) in
            button.width(80).height(50)
        }
        
        nextYearButton.margin.left = 10
        buttons +++ nextYearButton
        
        let stepperCtl :Control = MQForm.stepper(name: "stepper", min: 2019, max: 2049).layout() { (stepper) in
            stepper.width(50).height(28)
        }
        
        let indicatorCtl : Control = MQForm.button (name: "indicator", title: "2019").layout() { (button) in
            button.width(80).height(28)
        }
        indicatorCtl.margin.bottom = 10
        
        let indicateYear = Col.UpDownAligned().width(80).height(60)
        indicateYear.margin.left = 10
        indicateYear +++ indicatorCtl
            +++ stepperCtl
        
        
        buttons +++ indicateYear
   
        buttons.layout() { (buttons) in
            buttons.height(65)
            //buttons.view.backgroundColor = UIColor.gray
            buttons.leftMost().rightMost().putUnder(of: redLine, withOffset: 2)
        }
        
        page +++ buttons
        
        
    }
    
    func load () {
        
        //collectionView.reloadData()
    }
    
    func buildActivityData() -> Control {
        
        let scrollView = UIScrollView.newAutoLayout()
        scrollView.contentSize = UIScreen.main.bounds.size
        scrollView.isScrollEnabled = true
        scrollView.flashScrollIndicators()
        scrollView.canCancelContentTouches = false


//        scrollView.backgroundColor = UIColor.blue

        var container = Container(name:"Scroll-View", view:scrollView)
        let section = Section(name: "section-activity-data", view: UIView.newAutoLayout())
        container += section
        
        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(20)
        }
        section <<< row
        row +++ MQForm.label(name: "activity-title", title: "計画中").layout {
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
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(20)
        }
        section <<< row
        row +++ MQForm.label(name: "activity-title", title: "活動予定一覧").layout {
            l in
            l.label.textColor = .orange
            l.fillParent().height(20)
        }

        for t in activityList {
            let row = Row.LeftAligned()
            section <<< row
            
            row +++ MQForm.label(name: "activityDate", title: t.startDateTime).layout {
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
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(20)
        }
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
        
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(20)
        }
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
//            s.view.backgroundColor = UIColor.brown
            s.upper().width(UIScreen.main.bounds.size.width).height(height)
        }
        
        
        return container
    }
}
