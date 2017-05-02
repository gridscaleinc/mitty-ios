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
    
    //  Title
    var title : Control = {
        let t = UILabel.newAutoLayout()
        t.text = ".新年の鐘を聞きに行く"
        t.font = UIFont.boldSystemFont(ofSize: 18)
        t.textColor = .orange
        
        let c = Control(name:"title", view: t)
        return c
    } ()
    
    //  Memo
    var memo : Control = {
        let t = UILabel.newAutoLayout()
        t.text = "休みを取ることは忘れなく。引き継ぎ事情もあるかもしれないから、早めにリーダに相談する。航空券、ホテル。。。。"
        t.font = UIFont.systemFont(ofSize: 14)
        t.textColor = UIColor.black
        t.numberOfLines = 0
//        t.layer.borderColor = UIColor.black.cgColor
//        t.layer.borderWidth = 0.8
        t.layer.cornerRadius = 3
        let c = Control(name:"memo", view: t)
        return c
    } ()
    
    var mainEventButton = MQForm.button(name: "mainEvent", title: "メインベント登録へ")
    
    //  Main event
    //    Title                         Logo
    var eventTitle : Control = {
        let t = TapableLabel.newAutoLayout()
        t.text = "ニューヨークタイムスクエア　New year count down！"
        t.font = UIFont.boldSystemFont(ofSize: 18)
        t.numberOfLines = 0
        t.textColor = MittyColor.healthyGreen
        
        let c = Control(name:"eventTitle", view: t)
        return c
    } ()
    var eventLogo : Control = {
        let l = UIImageView.newAutoLayout()
        l.image = UIImage(named: "timesquare")
        let c = Control(name:"eventTitle", view: l)
        return c
    } ()
    //     From date time -> date time
    var eventTime : Control = {
        let t = UILabel.newAutoLayout()
        t.text = "⏰  2017/12/31  〜　2018/01/01"
        t.textColor = UIColor.gray
        let c = Control(name:"eventTitle", view: t)
        return c
    } ()
    
    //  Action list Title
    //  Action addition tool bar
    //  Action list (Loop)
    //  1) Title         Event logo (of type)
    //     Notification Flag, Notification Date time
    //     Memo
    //     from date time - date time   (link)
    //  2) Title         Event logo (of type)
    //     Notification Flag, Notification Date time
    //     Memo
    //     from date time - date time   (link)
    //  3) Title         Event logo (of type)
    //     Notification Flag, Notification Date time
    //     Memo
    //     from date time - date time   (link)
    //
    
    func loadForm(_ status: Int) {
        
        var page = self as MQForm
        
        let header = Header()
        header.title = "Title"
        page += header
        
        header.layout() { (v) in
            v.upper().height(1)
        }
        
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:1230)
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
            c.upper().width(UIScreen.main.bounds.size.width).height(1230)
        }
        
        // title
        var row = Row.LeftAligned().layout() {
            r in
            r.height(35).fillHolizon()
        }
        
        row +++ title.layout {
            t in
            t.fillHolizon(10).height(35)
        }
        inputForm <<< row

        // memo
        row = Row.LeftAligned().layout() {
            r in
            r.height(80).fillHolizon()
        }
        
        row +++ memo.layout {
            t in
            t.fillHolizon(10)
        }
        inputForm <<< row

        
        if status == 1 {
            row = Row.LeftAligned().layout {
                r in
                r.height(60).fillHolizon()
            }
            
            row +++ mainEventButton.layout {
                b in
                b.height(50).fillHolizon(50)
            }
            inputForm <<< row
            
            return
        }
        
         // event title
        row = Row.LeftAligned().layout() {
            r in
            r.height(60).fillHolizon()
        }
        
        row +++ eventTitle.layout {
            t in
            t.leftMost(withInset: 10).rightMost(withInset: 50).height(50)
        }
        row +++ eventLogo.layout {
            logo in
            logo.height(30).width(30).rightMost(withInset: 10).upMargin(5)
        }
        
        inputForm <<< row

        
        row = Row.LeftAligned().layout() {
            r in
            r.height(30).fillHolizon()
        }
        
        row +++ eventTime.layout {
            t in
            t.label.textColor = UIColor.gray
            t.label.font = UIFont.systemFont(ofSize: 14)
            t.leftMost(withInset: 10).rightMost(withInset: 10)
        }
        inputForm <<< row
        
        
        row = Row.LeftAligned().layout() {
            r in
            r.height(30).fillHolizon()
        }
 
        row +++ MQForm.label(name: "location" , title: "📍 ニューヨークタイムスクエア" ).layout {
            l in
            l.label.textColor = UIColor.gray
            l.label.font = UIFont.systemFont(ofSize: 14)
            l.leftMost(withInset:10).rightMost(withInset: 50).height(35)
        }
        
        row +++ MQForm.img(name: "icon" , url:"timesquare").layout{
            img in
            img.height(30).width(30).rightMost(withInset: 10)
        }
        inputForm <<< row
        

        row = Row.LeftAligned()
        row.layout() {
            r in
            r.height(40).fillHolizon(0)

        }
        
        let buttons : Control = {
            let l = TapableLabel.newAutoLayout()
            l.text = "＋　 ✈️　 🏩　 🚗　 🍴　 🏥　 🚚"
            return Control(name: "line", view: l).height(40)
        }()
        
        buttons.layout() {
            b in
            b.height(30).fillHolizon(10)
        }
        row +++ buttons
        inputForm <<< row

        row = Row.LeftAligned().layout() {
            r in
            
            r.height(5).fillHolizon(10)
            let layer = MittyColor.gradientLayer()
            layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2)
            r.view.layer.insertSublayer(layer, at: 0)
        }
        
        
        inputForm <<< row
        
        row = Row.LeftAligned().layout() {
            r in
            r.height(20).fillHolizon()
        }

        
        for n in 1...5 {
            row = Row.LeftAligned()
            row.layout() {
                r in
                r.height(35).fillHolizon(20)
            }
            
            let line : Control = {
                let l = TapableLabel.newAutoLayout()
                l.text = "2017/8/19 12:34 イベント名         🚗"
                l.textColor = MittyColor.healthyGreen
                l.font = UIFont.boldSystemFont(ofSize: 14)
                l.backgroundColor = UIColor.white
                return Control(name: "line", view: l).height(30)
            }()
            line.layout() {
                line in
                line.height(30).rightMost()
            }
            
            row +++ line
            inputForm <<< row
            row = Row.LeftAligned()
            row.layout() {
                r in
                r.height(30).leftMost(withInset: 5).rightMost(withInset: 5)
            }
            
            let swch = UISwitch.newAutoLayout()
            if (n == 2) {
                swch.isOn = true
            }
            let swchControl = Control(name: "notificationFlag", view: swch)
            row +++ swchControl.layout {
                w in
                w.leftMost(withInset:10).height(20).upMargin(5)
            }
            
            let labelNoti = UILabel.newAutoLayout()
            labelNoti.text = "知らせ時間：2018/01/01 12:00"
            labelNoti.font = UIFont.systemFont(ofSize: 14)
            let notification = Control(name:"notification", view: labelNoti)
            row +++ notification.layout {
                n in
                n.rightMost(withInset: 10).height(30)
            }
 
            inputForm <<< row
            
            row = Row.LeftAligned()
            row.layout() {
                r in
                r.height(50).leftMost(withInset: 5).rightMost(withInset: 5)
            }

            let labelMemo = UILabel.newAutoLayout()
            labelMemo.text = "忘れないためのメモ"
            labelMemo.font = UIFont.systemFont(ofSize: 14)
            
            labelMemo.textColor = .gray
            
            let labelMemoCtl = Control(name:"labelMemo", view: labelMemo)
            row +++ labelMemoCtl.layout {
                n in
                n.rightMost(withInset:20).height(45).leftMost(withInset:20)
            }
            row +++ labelMemoCtl

            inputForm <<< row


        }
        
        inputForm <<< Row.LeftAligned().height(50)

        row = Row.Intervaled()
        row.spacing = 40
        
        let bt = MQForm.button(name: "delete", title: "活動計画を削除").width(80).height(28)
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
        
    }
    
}
