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
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionFootersPinToVisibleBounds = false
        
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    } ()
    
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadForm () {
        
        var page = self as MQForm
        
        let header = Header()
        page += header
        
        header.layout() { (v) in
            v.view.autoPinEdge(toSuperviewEdge: .top, withInset:10)
            v.view.autoSetDimension(.height, toSize: 0)
        }
        
        let data = Control(name:"activity-data", view:collectionView)
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
        let thisYearButton :Control = button (name: "thisYear", "今年").layout() { (button) in
            button.width(80).height(50)
        }
        
        buttons +++ thisYearButton
    
        let nextYearButton : Control = button (name: "nextYear", "来年").layout() { (button) in
            button.width(80).height(50)
        }
        nextYearButton.margin.left = 10
        buttons +++ nextYearButton
        
        let stepperCtl :Control = stepper(name: "stepper", 2019, 2049).layout() { (stepper) in
            stepper.width(40).height(28)
        }
        
        let indicatorCtl : Control = button (name: "indicator", "2019").layout() { (button) in
            button.width(80).height(28)
        }
        indicatorCtl.margin.bottom = 10
        
        let indicateYear = Col.UpDownAligned().width(80).height(60)
        indicateYear.margin.left = 10
        indicateYear +++ indicatorCtl
        indicateYear +++ stepperCtl
        
        
        buttons +++ indicateYear
   
        buttons.layout() { (buttons) in
            buttons.height(65)
            //buttons.view.backgroundColor = UIColor.gray
            buttons.leftMost().rightMost().putUnder(of: redLine, withOffset: 2)
        }
        
        page +++ buttons
        
        
    }
    
    func load () {
        
        collectionView.reloadData()
    }
}
