//
//  RequestListForm.swift
//  mitty
//
//  Created by gridscale on 2017/08/27.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

@objc(RequestListForm)
class RequestListForm: MQForm {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var section: Section!
    var scrollView: UIScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var requestList: [RequestInfo] = []
    
    func loadForm () {
        
        self.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)
        
        var page = self as MQForm
        
        let header = Header()
        page += header
        
        header.layout() { (v) in
            v.view.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            v.view.autoSetDimension(.height, toSize: 0)
        }
        
        
        let data = buildRequestData()
        page +++ data
        data.layout() { (main) in
            main.view.autoPinEdgesToSuperviewEdges()
        }
        
    }
    
    func load () {
        
        //collectionView.reloadData()
    }
    
    func buildRequestData() -> Control {
        
        self.scrollView = UIScrollView.newAutoLayout()
        scrollView.isScrollEnabled = true
        scrollView.flashScrollIndicators()
        scrollView.canCancelContentTouches = false
        
        var container = Container(name: "Scroll-View", view: scrollView)
        self.section = Section(name: "section-req-data", view: UIView.newAutoLayout())
        container += section
        
        var row = newTitleRow()
        section <<< row
        row +++ MQForm.label(name: "req-title", title: "リクエスト中").layout {
            l in
            l.label.textColor = .orange
            l.height(20).fillHolizon()
        }
        
        for r in requestList {
            let row = Row.LeftAligned()
            section <<< row
            
            let l = MQForm.label(name: "requestlabel", title: r.title).width(200).height(30)
            row +++ l
            
            // ラベルに紐つくreqを保存
            (l.label as! TapableLabel).underlyObj = r
            
            row.layout() { r in
                r.fillHolizon(20).height(40)
            }
        }
        
        if requestList.count == 0 {
            let row = Row.LeftAligned().height(30)
            section <<< row
            
            row +++ MQForm.label(name: "req-content", title: "リクエストなし").layout {
                l in
                l.label.textColor = .gray
            }
        }
        
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
            r.fillHolizon().height(20)
            r.view.backgroundColor = UIColor(white: 0.96, alpha: 1)
        }
        return row
    }
}
