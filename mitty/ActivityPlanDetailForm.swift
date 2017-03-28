//
//  ActivityPlanDetailForm.swift
//  mitty
//
//  Created by gridscale on 2017/03/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class ActivityPlanDetailsForm : MQForm {
    
    func loadForm() {
        
        var page = self as MQForm
        
        let header = Header()
        header.title = "Title"
        page += header
        
        header.layout() { (v) in
            v.upper().height(30)
        }
        
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:620)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        
        let inputContainer = Container(name: "Details-Container", view: scroll)
        
        self +++ inputContainer
        
        inputContainer.layout() { (main) in
            main.putUnder(of: header).fillHolizon().down(withInset: 10)
        }
        
        let inputForm = Section(name: "Details-Form", view: UIView.newAutoLayout())
        inputContainer +++ inputForm
        
        inputForm.layout() { c in
            c.upper().width(UIScreen.main.bounds.size.width).height(620)
        }
        
        var row = Row.LeftAligned().layout() {
            r in
            r.height(20).fillHolizon()
        }
        
        var title : Control = {
            let l = TapableLabel.newAutoLayout()
            l.text = "メインイベント"
            l.textColor = UIColor.white
            l.backgroundColor = UIColor.purple
            return Control(name: "sectionTitle", view: l)
            
        }()
        title.layout() { t in
            t.margin = ControlMargin(10)
            t.height(20).fillHolizon(10)
        }
        
        row +++ title
        inputForm <<< row
        
        row = Row.LeftAligned().layout() {
            r in
            r.height(40).fillHolizon()
        }
        
        row +++ label(name: "title" , title: "タイムスクエア新年カウントダウン" ).width(250).height(35)
        row +++ img(name: "icon" , url:"timesquare").height(35).width(35)
       
        inputForm <<< row
        
        row = Row.LeftAligned().layout() {
            r in
            r.height(35).fillHolizon()
        }
        
        row +++ label(name: "time" , title: "２０１７年１月１日 ０：００" ).width(250).height(30)
        inputForm <<< row
        
        
        row = Row.LeftAligned().layout() {
            r in
            r.height(40).fillHolizon()
        }
 
        row +++ label(name: "location" , title: "📍 ニューヨークタイムスクエア" ).width(250).height(35)
        
        row +++ img(name: "icon" , url:"timesquare").height(35).width(35)
        
        inputForm <<< row
        
        row = Row.LeftAligned().layout() {
            r in
            r.height(20).fillHolizon()
        }

        title  = {
            let l = TapableLabel.newAutoLayout()
            l.text = "関連計画"
            l.textColor = UIColor.white
            l.backgroundColor = UIColor.gray
            return Control(name: "relatedActivities", view: l)
            
        }()
        
        title.layout() { t in
            t.margin = ControlMargin(10)
            t.height(20).fillHolizon(10)
        }
        
        row +++ title
        inputForm <<< row
        
        for _ in 1...5 {
            row = Row.LeftAligned()
            row.layout() {
                r in
                r.height(40).fillHolizon(20)
            }
            let line : Control = {
                let l = TapableLabel.newAutoLayout()
                l.text = "2017/8/19 12:34 イベント名          🚗"
                l.backgroundColor = UIColor.white
                return Control(name: "line", view: l).height(30)
            }()
            line.layout() {
                line in
                line.height(30).fillHolizon(10)
            }
            
            row +++ line
//            let subRow = Row.RightAligned()
//            subRow +++ label(name: "icon", title: "🚗").width(50).height(35)
//            row +++ subRow
            inputForm <<< row

        }
        
        row = Row.LeftAligned()
        row.layout() {
            r in
            r.height(20).fillHolizon()
        }
        let plus : Control = {
            let l = TapableLabel.newAutoLayout()
            l.text = "　 ➕"
            l.backgroundColor = UIColor.white
            return Control(name: "line", view: l).height(20)
        }()
        plus.layout() {
            plus in
            plus.height(20).width(80)
        }
        row +++ plus
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout() {
            r in
            r.height(1).fillHolizon(10)
        }

        let line : Control = {
            let l = HL()
            l.backgroundColor = UIColor.red
            return Control(name: "line", view: l).height(1)
        }()
        
        line.layout() {
            line in
            line.height(1).fillHolizon(10)
        }
        row +++ line
        inputForm <<< row

        row = Row.LeftAligned()
        row.layout() {
            r in
            r.height(30).fillHolizon(10)
        }
        
        let buttons : Control = {
            let l = TapableLabel.newAutoLayout()
            l.text = "　 ✈️　 🏩　 🚗　 🍴　 🏥　 🚚"
            return Control(name: "line", view: l).height(40)
        }()
        
        buttons.layout() {
            b in
            b.height(30).fillHolizon(10)
        }
        row +++ buttons
        inputForm <<< row

        
        inputForm <<< Row.LeftAligned().height(50)

        row = Row.Intervaled()
        row.spacing = 40
        
        let bt = button(name: "delete", title: "活動計画を削除").width(80).height(28)
        bt.layout() {
            c in
            c.view.backgroundColor = UIColor.red
            c.view.layer.cornerRadius = 8
            
        }
        
        row +++ bt

        row.layout() {
            r in
            r.height(55).fillHolizon()
        }
        
        inputForm <<< row
        
        
        
        //    self +++ thisYearButton
        //    thisYearButton.event(.touchUpInside) { [weak self]
        //        c in
        //        self?.quest().forEach() {
        //            ct in
        //            print(ct.name)
        //            print(ct.view.bounds)
        //            print(ct.view.frame)
        //        }
        //  }
        
    }
    
}
