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

        var row = newTitleRow()
        section <<< row
        row +++ MQForm.label(name: "activity-title", title: "計画中").layout {
            l in
            l.label.textColor = MittyColor.orange
            l.label.font = UIFont.boldSystemFont(ofSize: 17)
            l.height(20).verticalCenter().leftMargin(10)
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

            let l = MQForm.label(name: "activitylabel", title: t.title).width(200).height(30).layout{
                l in
                l.verticalCenter().leftMargin(15)
            }
            row +++ l

            // ラベルに紐つくactivityを保存
            (l.label as! TapableLabel).underlyObj = t

            row.layout() { r in
                r.fillHolizon(20).height(40)
            }
        }

        if outstandingActivity.count == 0 {
            let row = Row.LeftAligned()
            section <<< row

            row +++ MQForm.label(name: "activity-content", title: "予定なし").layout {
                l in
                l.verticalCenter().leftMargin(15)
                l.label.textColor = .gray
            }
            
            row.layout() { r in
                let w = UIScreen.main.bounds.size.width - 20
                r.leftMost().rightMost().height(40).width(w)
            }
            
            section <<< HL(UIColor.lightGray).fillHolizon().leftMargin(10).rightMargin(10)
        }

        row = newTitleRow()

        section <<< row
        row +++ MQForm.label(name: "activity-title", title: "活動予定一覧").layout {
            l in
            l.label.textColor = MittyColor.orange
            l.label.font = UIFont.boldSystemFont(ofSize: 17)
            l.height(20).leftMargin(10).verticalCenter()
        }

        for t in planedActivity {
            let row = Row.LeftAligned()
            section <<< row

            row +++ MQForm.label(name: "activityDate", title: t.monthDay).layout {
                d in
                d.label.textColor = MittyColor.black
                d.width(50).height(30).verticalCenter().leftMargin(15)
            }

            let l = MQForm.label(name: "activitylabel", title: t.title).width(200).height(30).layout{
                l in
                l.label.textColor = MittyColor.darkText
                l.verticalCenter().leftMargin(15)
            }

            row +++ l

            // ラベルに紐つくactivityを保存
            (l.label as! TapableLabel).underlyObj = t

            row +++ MQForm.img(name: "icon", url: t.logoUrl).width(20).height(20).layout{
                i in
                i.imageView.setMittyImage(url: t.logoUrl)
                i.verticalCenter()
            }

            row.layout() { r in
                let w = UIScreen.main.bounds.size.width - 20
                r.leftMost().rightMost().height(40).width(w)
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

        row = Row.LeftAligned()

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
            r.leftMost(withInset: 5).rightMost(withInset: 5).height(20).leftMargin(5)
//            r.view.backgroundColor = UIColor.orange.withAlphaComponent(0.8)
        }
        return row
    }
}
