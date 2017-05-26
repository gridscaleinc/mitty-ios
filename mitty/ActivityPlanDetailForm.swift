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
    
    var requestButton = MQForm.button(name: "request", title: "聞いてみる")
    
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
    
    var addressRow : Row? = nil
    
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
    
    func loadForm(_ activity: Activity) {
        self.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)
        
        var page = self as MQForm
        
        let header = Header()
        header.title = "Title"
        page += header
        
        header.layout() { (v) in
            v.upper().height(1)
        }
        
        let scroll = UIScrollView.newAutoLayout()
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        
        let inputContainer = Container(name: "Details-Container", view: scroll)
        
        self +++ inputContainer
        
        let inputForm = Section(name: "Details-Form", view: UIView.newAutoLayout())
        inputContainer +++ inputForm
        
        inputForm.layout() { c in
            c.upper().width(UIScreen.main.bounds.size.width).height(1400)
        }
        
        // title
        var row = Row.LeftAligned().layout() {
            r in
            r.height(35).fillHolizon()
        }
        
        title.label.text = activity.info.title
        row +++ title.layout {
            t in
            t.fillHolizon(10).height(35)
        }
        inputForm <<< row

        // memo
        row = Row.LeftAligned().layout() {
            r in
            r.height(80).fillHolizon(10)
            r.view.backgroundColor = UIColor(white: 0.99, alpha: 0.99)
        }
        
        memo.label.text = activity.info.memo
        
        row +++ memo.layout {
            t in
            t.fillHolizon(10)
        }
        
        inputForm <<< row

        
        if activity.info.mainEventId == nil || activity.info.mainEventId == "0" {
            row = Row.Intervaled().layout {
                r in
                r.height(60).fillHolizon()
            }
            
            row +++ mainEventButton.layout {
                b in
                b.height(40)
            }
            row.spacing = 30
            
            inputForm <<< row
            
            row = Row.Intervaled().layout {
                r in
                r.height(60).fillHolizon()
            }
            
            row +++ requestButton.layout {
                b in
                b.height(40)
                b.button.backgroundColor = UIColor.gray
            }
            
            row.spacing = 30
            
            inputForm <<< row
            
            row = Row.Intervaled()
            inputForm <<< row
            
            inputContainer.layout() { (main) in
                main.fillVertical().width(UIScreen.main.bounds.width - 5).bottomAlign(with: row)
            }
            return
        }
        
         // event title
        row = Row.LeftAligned().layout() {
            r in
            r.height(60).fillHolizon()
        }
        
        eventTitle.label.text = activity.mainItem?.eventTitle
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
        
        eventTime.label.text = activity.mainItem?.start

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
 
        row +++ MQForm.label(name: "location" , title: "📍 \((activity.mainItem?.islandName) ?? "")" ).layout {
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
        

        row = Row.Intervaled()
        row.layout() {
            r in
            r.height(40).fillHolizon(0)

        }
        
        let button = MQForm.button(name: "label", title: "＋").height(40)
        button.button.backgroundColor = .white
        button.button.setTitleColor(.black, for: .normal)

        row +++ button
        
        let buttons = ["✈️", "🏩", "🚗","🍴"]
        for b in buttons {
            let button = MQForm.button(name: "addItem", title: b).height(40)
            button.button.backgroundColor = .white
            row +++ button
        }
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

        
        for item in activity.items {
            
            row = Row.LeftAligned()
            inputForm <<< row
            
            row +++ MQForm.label(name: "activityDate", title: item.start).layout {
                d in
                d.label.textColor = .orange
                d.label.font = UIFont.boldSystemFont(ofSize: 14)
                d.width(50).height(30)
            }
            
            let l = MQForm.label(name: "activitylabel", title: item.eventTitle).layout {
                l in
                l.width(200).height(30)
                l.label.textColor = MittyColor.healthyGreen
                l.label.font = UIFont.boldSystemFont(ofSize: 14)
            }
            
            row +++ l
            
            // ラベルに紐つくactivityを保存
            (l.label as! TapableLabel).underlyObj = item
            
            row +++ MQForm.img(name:"icon", url: "timesquare").width(30).height(20)
            
            row.layout(){ r in
                let w = UIScreen.main.bounds.size.width - 20
                r.leftMost().rightMost().height(40).width(w)
            }
            
            row = Row.LeftAligned()
            row.layout() {
                r in
                r.height(30).leftMost(withInset: 5).rightMost(withInset: 5)
            }
            
            let labelNoti = UILabel.newAutoLayout()
            labelNoti.text = "知らせ時間：\(item.notifyTime)"
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
            labelMemo.text = item.memo
            labelMemo.font = UIFont.systemFont(ofSize: 14)
            labelMemo.backgroundColor = UIColor(white: 0.93, alpha: 0.7)
            
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

        row = Row.Intervaled().layout {
            r in
            r.height(40).fillHolizon()
        }
        
        row +++ requestButton.layout {
            b in
            b.height(40).fillHolizon(90)
        }
        inputForm <<< row
        
        
        row = Row.Intervaled()
        row.spacing = 40
        
        let bt = MQForm.button(name: "delete", title: "活動計画を削除")
        bt.layout() {
            c in
            c.view.backgroundColor = UIColor.red
            c.view.layer.cornerRadius = 8
            c.height(28).fillHolizon(60)
            
        }
        
        row +++ bt

        row.layout() {
            r in
            r.height(90).fillHolizon()
        }
        
        inputForm <<< row
        
        row = Row.Intervaled()
        inputForm <<< row

        
        inputContainer.layout() { (main) in
            main.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: row)
            main.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            main.view.backgroundColor = UIColor.white
        }
    }
    
}
