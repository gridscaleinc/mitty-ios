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

class ActivityPlanDetailsForm: MQForm {

    //  Title
    var title = MQForm.label(name: "title", title: "").layout {
        t in
        t.label.font = UIFont.boldSystemFont(ofSize: 18)
        t.label.textColor = .black
    }

    //  Memo
    var memo = MQForm.label(name: "memo", title: "", pad: 5).layout {
        l in
        l.label.numberOfLines = 0
        l.label.layer.cornerRadius = 3
    }

    var mainEventButton = MQForm.button(name: "mainEvent", title: "メインベント登録へ")

    var requestButton = MQForm.button(name: "request", title: "聞いてみる")

    //  Main event
    //    Title                         Logo
    var eventTitle = MQForm.label(name: "eventTitle", title: "").layout {
        t in
        t.label.numberOfLines = 0
        t.label.textColor = MittyColor.sunshineRed
    }
    
    var eventLogo: Control = {
        let l = UIImageView.newAutoLayout()
        l.image = UIImage(named: "")
        let c = Control(name: "eventTitle", view: l)
        return c
    } ()

    //     From date time -> date time
    var eventTime: Control = {
        let t = UILabel.newAutoLayout()
        t.text = "⏰  2017/12/31  〜　2018/01/01"
        t.textColor = UIColor.darkText
        let c = Control(name: "eventTitle", view: t)
        return c
    } ()

    var addressRow: Row? = nil

    //
    // item tap event handler
    var itemTapped: ((_ item: ActivityItem) -> Void)? = nil

    var activityTapped: (() -> Void)? = nil

    // eventをクリックした際のハンドラー
    var openEventHandler: ((_ eventId: String) -> Void)? = nil

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
//
//        let anchor = MQForm.label(name: "dummy", title: "").layout {
//            a in
//            a.height(0).leftMost().rightMost()
//        }
//
//        self +++ anchor
//
        let scroll = UIScrollView.newAutoLayout()
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 900)

        
        let inputContainer = Container(name: "Details-Container", view: scroll)
        
        inputContainer.layout() { (main) in
            main.fillParent()
            main.view.backgroundColor = UIColor.white
        }

        self +++ inputContainer

        let inputForm = Section(name: "Details-Form", view: UIView.newAutoLayout())
        inputContainer +++ inputForm

        // title
        var row = Row.LeftAligned().layout() {
            r in
            r.height(35).fillHolizon()
        }

        title.label.text = activity.info.title
        row +++ title.layout {
            t in
            t.rightMost(withInset:30).verticalCenter().leftMargin(10)
        }

        row +++ MQForm.label(name: "anchor", title: ">").layout {
            l in
            l.label.font = UIFont.systemFont(ofSize: 15)
            l.label.textColor = MittyColor.lightGray
            l.label.textAlignment = .right
            l.verticalCenter().rightMost(withInset: 5)
        }

        row.bindEvent(.touchUpInside) {
            a in
            if self.activityTapped != nil {
                self.activityTapped!()
            }
        }
        inputForm <<< row

        // memo
        row = Row.LeftAligned()
        memo.label.text = activity.info.memo

        row +++ memo.layout {
            t in
            t.fillHolizon(10).leftMargin(10)
            t.taller(than: 30)
        }
        row.layout() {
            r in
            r.fillHolizon(10).bottomAlign(with: self.memo).topAlign(with: self.memo)
            r.view.backgroundColor = UIColor(white: 0.99, alpha: 0.99)
        }

        row.bindEvent(.touchUpInside) {
            a in
            if self.activityTapped != nil {
                self.activityTapped!()
            }
        }
        inputForm <<< row
        
        // mainEvetがなければ表示しない内容がある。　TODO

        if activity.info.mainEventId == nil || activity.info.mainEventId == "0" {
            row = Row.Intervaled().layout {
                r in
                r.height(60).fillHolizon()
            }
            
            row.spacing = 60
            
            row +++ mainEventButton.layout {
                b in
                b.button.setTitleColor(MittyColor.sunshineRed, for: .normal)
                b.button.backgroundColor = .white
                b.height(40)
            }
            
            inputForm <<< row
            
        } else {
            
            row = newTitleRow()
            inputForm <<< row
            row +++ MQForm.label(name: "main-title", title: "メインイベント").layout {
                l in
                l.label.textColor = MittyColor.healthyGreen
                l.label.font = UIFont.boldSystemFont(ofSize: 17)
                l.height(20).down(withInset: 3).leftMargin(10)
            }
            
            inputForm <<< HL(UIColor.lightGray, 0.5).leftMargin(10).rightMargin(10)
            
            // event title
            row = Row.LeftAligned().layout() {
                r in
                r.height(60).fillHolizon()
            }
            
            eventTitle.label.text = activity.mainItem?.eventTitle
            row +++ eventTitle.layout {
                t in
                t.leftMargin(10).rightMost(withInset: 40).height(50).verticalCenter()
            }
            
            eventLogo.imageView.setMittyImage(url: activity.info.logoUrl)
            row +++ eventLogo.layout {
                logo in
                logo.height(30).width(30).rightMost(withInset: 10).verticalCenter()
            }
            
            inputForm <<< row
            
            
            row = Row.LeftAligned().layout() {
                r in
                r.height(30).fillHolizon()
            }
            
            eventTime.label.text = "⏰ \(activity.mainItem?.start ?? "")"
            row +++ eventTime.layout {
                t in
                t.label.textColor = UIColor.darkText
                t.leftMargin(10).rightMost(withInset: 10).verticalCenter()
            }
            inputForm <<< row
            
            row = Row.LeftAligned().layout() {
                r in
                r.height(30).fillHolizon()
            }
            
            row +++ MQForm.label(name: "location", title: "📍 \((activity.mainItem?.islandName) ?? "")").layout {
                l in
                l.label.textColor = UIColor.gray
                l.leftMargin(10).rightMost(withInset: 50).height(35).verticalCenter()
            }
            
            row +++ MQForm.img(name: "icon", url: "").layout {
                img in
                img.height(30).width(30).rightMost(withInset: 10).verticalCenter()
                img.imageView.setMittyImage(url: activity.mainItem?.islandLogoUrl ?? "")
            }
            
            inputForm <<< row
        }

        if (activity.items.count > 0) {
            row = newTitleRow()
            inputForm <<< row
            row +++ MQForm.label(name: "main-title", title: "予定一覧").layout {
                l in
                l.label.textColor = MittyColor.healthyGreen
                l.label.font = UIFont.boldSystemFont(ofSize: 17)
                l.height(20).down(withInset: 3).leftMargin(10)
            }
            
            inputForm <<< HL(UIColor.lightGray, 0.5).leftMargin(10).rightMargin(10)
            
            for item in activity.items {
                
                loadItem(inputForm, item)
                
            }
            
            
            row = Row.LeftAligned()
            row.layout() {
                r in
                r.height(40).fillHolizon(0)
                r.view.backgroundColor = .white
            }
            
            let button = MQForm.button(name: "label", title: "＋").height(40)
            button.button.backgroundColor = .clear
            button.button.setTitleColor(.black, for: .normal)
            
            row +++ button.layout {
                b in
                b.verticalCenter().leftMargin(20)
            }
            
            let addEventTitle = "イベント"

            let addEventButton = MQForm.button(name: "addEvent", title: addEventTitle).height(40)
            addEventButton.button.backgroundColor = .clear
            addEventButton.button.setTitleColor(MittyColor.sunshineRed, for: .normal)
            addEventButton.layout {
                b in
                b.verticalCenter().leftMargin(20).width(100)
            }
            row +++ addEventButton
            
            inputForm <<< row
        }

        

        inputForm <<< Row.LeftAligned().height(50)

        row = Row.Intervaled().layout {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< HL(UIColor.lightGray, 0.5).leftMargin(10).rightMargin(10)
        
        row +++ requestButton.layout {
            b in
            b.button.setTitleColor(MittyColor.healthyGreen, for: .normal)
            b.button.backgroundColor = .white
            b.height(40).fillHolizon(90).verticalCenter()
        }
        inputForm <<< row
        
        
        row = Row.LeftAligned()
        inputForm <<< row

        inputForm.layout() { c in
            c.fillParent().width(UIScreen.main.bounds.width).bottomAlign(with: row)
            c.taller(than: UIScreen.main.bounds.height + 10)
            c.view.backgroundColor = .white
        }

    }


    func loadItem(_ detail: Section, _ item: ActivityItem) {

        var row = Row.LeftAligned()
        row +++ MQForm.label(name: "activityDate", title: item.start).layout {
            d in
            d.width(60).height(30).verticalCenter().leftMargin(10)
        }

        let l = MQForm.label(name: "activitylabel", title: item.eventTitle).layout {
            l in
            l.leftMargin(10).verticalCenter().rightMost(withInset: 50)
            l.label.textColor = MittyColor.sunshineRed
            l.label.numberOfLines = 0
        }

        l.bindEvent(.touchUpInside) { label in
            if (self.openEventHandler != nil) {
                self.openEventHandler!(item.eventId)
            }
        }

        row +++ l

        // ラベルに紐つくactivityを保存
        (l.label as! TapableLabel).underlyObj = item

        row +++ MQForm.img(name: "icon", url: "").width(30).height(30).layout {
            i in
            i.verticalCenter()
            i.imageView.setMittyImage(url: item.eventLogoUrl)
        }
        
        row +++ MQForm.label(name: "anchor", title: ">").layout {
            l in
            l.label.font = UIFont.systemFont(ofSize: 15)
            l.label.textColor = MittyColor.lightGray
            l.label.textAlignment = .right
            l.verticalCenter().rightMost(withInset: 5)
        }
        
        row.layout() { r in
            r.leftMost().rightMost().taller(than: 50).fillHolizon().bottomAlign(with: l)
        }

        detail <<< row

        // todo func 作成。
        // 1 itemを1 sectionとして処理し、イベントハンドラーを作成。
        // tap するとitem編集VCを開く。
        let itemRow = Row.LeftAligned()
        detail <<< itemRow

        let itemSection = Section(name: "itemSection", view: UIView.newAutoLayout())
        itemSection.layout {
            s in
            s.fillHolizon()
        }
        itemRow +++ itemSection
        
        itemRow.layout() {
            r in
            r.fillHolizon().topAlign(with: itemSection).bottomAlign(with: itemSection)
        }


        itemSection.bindEvent(.touchUpInside) {
            s in
            if self.itemTapped != nil {
                self.itemTapped!(item)
            }
        }

        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon().height(30)
        }

        let title = MQForm.label(name: "title", title: item.title).layout {
            l in
            l.width(200).height(30).verticalCenter().leftMargin(10)
            l.label.textColor = UIColor.darkText
            l.label.font = UIFont.boldSystemFont(ofSize: 17)
        }

        row +++ title

        itemSection <<< row

        row = Row.LeftAligned()
        row.layout() {
            r in
            r.height(25).leftMost(withInset: 5).rightMost(withInset: 5)
        }

        let labelNoti = UILabel.newAutoLayout()
        labelNoti.text = "知らせ時間：\(item.notifyTime)"
        labelNoti.font = UIFont.systemFont(ofSize: 14)
        let notification = Control(name: "notification", view: labelNoti)
        row +++ notification.layout {
            n in
            n.rightMost(withInset: 10).height(25).verticalCenter().leftMargin(10)
        }

        itemSection <<< row

        row = Row.LeftAligned()
        let labelMemoCtl = MQForm.label(name: "labelMemo", title: item.memo, pad:3)
        row +++ labelMemoCtl.layout {
            n in
            n.label.numberOfLines = 0
            n.label.textColor = .darkText
            n.rightMost(withInset: 20).leftMargin(10).taller(than: 30)
        }
        row +++ labelMemoCtl

        row +++ MQForm.label(name: "anchor", title: ">").layout {
            l in
            l.label.font = UIFont.systemFont(ofSize: 15)
            l.label.textColor = MittyColor.lightGray
            l.label.textAlignment = .right
            l.verticalCenter().rightMost(withInset: 5)
        }
        
        row.layout() {
            r in
            r.bottomAlign(with: labelMemoCtl).topAlign(with: labelMemoCtl).leftMost(withInset: 5).rightMost(withInset: 5)
        }

        itemSection <<< row
        itemSection <<< Row.LeftAligned().height(10)
        itemSection <<< HL(UIColor.lightGray, 0.5).leftMargin(10).rightMargin(10)

    }
    func newTitleRow() -> Row {
        let row = Row.LeftAligned().layout {
            r in
            r.leftMost(withInset: 5).rightMost(withInset: 5).height(35).leftMargin(5)
        }
        return row
    }
    
    func reset() {
        
        for c in controls {
            c.view.removeFromSuperview()
        }
        controls = [Control]()
        
    }
}
