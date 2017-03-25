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
    
//    let collectionView : UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionHeadersPinToVisibleBounds = true
//        layout.sectionFootersPinToVisibleBounds = false
//        
//        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .white
//        return v
//    } ()
//    
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let activityList : [(label:String, imgName:String)] = [
        (label: "2/18 平和島公園", imgName: "timesquare"),
        (label: "2/19 フィンテック＠ビグサイト", imgName: "pengin1"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/18 Iot どこかで", imgName: "pengin3"),
        (label: "2/18 島祭り", imgName: "pengin"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/18 島祭り", imgName: "pengin"),
        (label: "2/18 平和島公園", imgName: "timesquare"),
        (label: "2/19 フィンテック＠ビグサイト", imgName: "pengin1"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/18 Iot どこかで", imgName: "pengin3"),
        (label: "2/18 島祭り", imgName: "pengin"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/19 フィンテック＠ビグサイト", imgName: "pengin1"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/18 Iot どこかで", imgName: "pengin3"),
        (label: "2/18 島祭り", imgName: "pengin"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/18 島祭り", imgName: "pengin")
    ]
    
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
        let thisYearButton :Control = button (name: "thisYear", title: "今年").layout() { (button) in
            button.width(80).height(50)
        }
        
        buttons +++ thisYearButton
    
        let nextYearButton : Control = button (name: "nextYear", title: "来年").layout() { (button) in
            button.width(80).height(50)
        }
        
        nextYearButton.margin.left = 10
        buttons +++ nextYearButton
        
        let stepperCtl :Control = stepper(name: "stepper", min: 2019, max: 2049).layout() { (stepper) in
            stepper.width(50).height(28)
        }
        
        let indicatorCtl : Control = button (name: "indicator", title: "2019").layout() { (button) in
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
        
        for t in activityList {
            let row = Row.LeftAligned()
            section <<< row
            
            row +++ label(name: "activitylabel", title: t.label).width(250).height(30)
                +++ img(name:"icon", url: t.imgName).width(30).height(20)

                
            row.layout(){ r in
                let w = UIScreen.main.bounds.size.width - 20
                r.leftMost().rightMost().height(40).width(w)
            }
        }

        section.layout() { [weak self]s in
            let height = 40.0*(CGFloat((self?.activityList.count)!))
//            s.view.backgroundColor = UIColor.brown
            s.upper().width(UIScreen.main.bounds.size.width).height(height)
        }
        
        
        return container
    }
}
