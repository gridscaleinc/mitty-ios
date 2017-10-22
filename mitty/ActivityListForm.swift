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
class ActivityListForm: MQForm {



    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    var section: Section!
    var scrollView: UIScrollView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var activityList: [ActivityInfo] = []

    func loadForm () {

        self.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)

        var page = self as MQForm

        let header = Header()
        page += header

        header.layout() { (v) in
            v.view.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            v.view.autoSetDimension(.height, toSize: 0)
        }


        let data = buildActivityData()
        page +++ data
        data.layout() { (main) in
            main.view.autoPinEdgesToSuperviewEdges()
        }

    }

    func load () {

        //collectionView.reloadData()
    }

    func buildActivityData() -> Control {

        self.scrollView = UIScrollView.newAutoLayout()
        scrollView.isScrollEnabled = true
        scrollView.flashScrollIndicators()
        scrollView.canCancelContentTouches = false

        var container = Container(name: "Scroll-View", view: scrollView)
        self.section = Section(name: "section-activity-data", view: UIView.newAutoLayout())
        container += section

        section <<< MQForm.titleRow(name: "activity-title", caption: "計画中", color: MittyColor.healthyGreen, lineColor: MittyColor.sunshineRed)
        
        var outstandingActivity = [ActivityInfo]()
        var planedActivity = [ActivityInfo]()

        for t in activityList {
            if t.hasEvent {
                planedActivity.append(t)
            } else {
                outstandingActivity.append(t)
            }
        }

        for t in outstandingActivity.sorted(by: {(a1,a2) in return a1.title < a2.title}) {
            let row = Row.LeftAligned()
            section <<< row

            let l = MQForm.label(name: "activitylabel", title: t.title).height(30).layout{
                l in
                l.verticalCenter().leftMargin(15).rightMost(withInset: 20)
            }
            row +++ l
            
            row +++ MQForm.label(name: "anchor", title: ">").layout {
                l in
                l.label.font = UIFont.systemFont(ofSize: 15)
                l.label.textColor = MittyColor.lightGray
                l.label.textAlignment = .right
                l.verticalCenter().rightMost(withInset: 5)
            }

            // ラベルに紐つくactivityを保存
            (l.label as! TapableLabel).underlyObj = t

            row.layout() { r in
                r.fillHolizon().height(50)
            }
            
            section <<< HL(UIColor.lightGray, 0.5).leftMargin(10).rightMargin(10)
        }

        if outstandingActivity.count == 0 {
            let row = Row.LeftAligned()
            section <<< row

            row +++ MQForm.label(name: "activity-content", title: "予定なし").layout {
                l in
                l.down(withInset: 3).leftMargin(15)
                l.label.textColor = .gray
            }
            
            row.layout() { r in
                let w = UIScreen.main.bounds.size.width - 20
                r.leftMost().rightMost().height(40).width(w)
            }
        }

        section <<< MQForm.titleRow(name: "activity-title", caption: "活動予定一覧", color:MittyColor.healthyGreen, lineColor: MittyColor.sunshineRed)

        for t in planedActivity.sorted(by: {(a1,a2) in return a1.startDateTime < a2.startDateTime}) {
            let row = Row.LeftAligned()
            section <<< row

            row +++ MQForm.label(name: "activityDate", title: t.monthDay).layout {
                d in
                d.label.textColor = MittyColor.sunshineRed.withAlphaComponent(0.8)
                d.width(50).height(30).verticalCenter().leftMargin(15)
            }

            let l = MQForm.label(name: "activitylabel", title: t.title).layout{
                l in
                l.label.numberOfLines = 0
                l.verticalCenter().leftMargin(15).rightMost(withInset: 50)
            }

            row +++ l

            // ラベルに紐つくactivityを保存
            (l.label as! TapableLabel).underlyObj = t

            row +++ MQForm.img(name: "icon", url: t.logoUrl).width(20).height(20).layout{
                i in
                i.imageView.setMittyImage(url: t.logoUrl)
                i.verticalCenter()
            }

            row +++ MQForm.label(name: "anchor", title: ">").layout {
                l in
                l.label.font = UIFont.systemFont(ofSize: 15)
                l.label.textColor = MittyColor.lightGray
                l.label.textAlignment = .right
                l.verticalCenter().rightMost(withInset: 5)
            }

            row.layout() { r in
                let w = UIScreen.main.bounds.size.width - 20
                r.leftMost().rightMost().height(50).width(w)
            }
            
            section <<< HL(MittyColor.lightGray, 0.5).leftMargin(10).rightMargin(10)
        }
        
        if planedActivity.count == 0 {
            let row = Row.LeftAligned().height(30)
            section <<< row

            row +++ MQForm.label(name: "activity-content", title: "予定なし").layout {
                l in
                l.verticalCenter()
                l.label.textColor = .gray
            }
        }

        var row = Row.LeftAligned()

        section <<< row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }

        section <<< row

        // スクロールviewの対応。
        // sectionはコンテンツViewの役割とする。
        // content-viewの高さはサブビューの一番下のViewの底辺に合わせる。
        // content-viewの四辺はscrollviewにPinする。
        section.layout() { s in
            s.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: row)
            s.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            s.view.backgroundColor = UIColor.white
        }

        return container
    }

    func newTitleRow() -> Row {
        let row = Row.LeftAligned().layout {
            r in
            r.leftMost(withInset: 5).rightMost(withInset: 5).height(35).leftMargin(5)
//            r.view.backgroundColor = MittyColor.sunshineRed.withAlphaComponent(0.8)
        }
        return row
    }
}
