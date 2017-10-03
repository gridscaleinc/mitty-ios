//
//  InvitationListForm.swift
//  mitty
//
//  Created by gridscale on 2017/09/22.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//


import Foundation
import UIKit
import PureLayout

@objc(InvitationListForm)
class InvitationListForm: MQForm {

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    var section: Section!
    var scrollView: UIScrollView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var invitationList: [InvitationInfo] = []

    var showHandler : ((_ inv: InvitationInfo) -> Void)?
    var acceptHandler : ((_ inv: InvitationInfo) -> Void)?
    var rejectHandler : ((_ inv: InvitationInfo) -> Void)?
    
    func loadForm () {

        self.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)

        var page = self as MQForm

        let header = Header()
        page += header

        header.layout() { (v) in
            v.view.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            v.view.autoSetDimension(.height, toSize: 0)
        }


        let data = buildInvitationData()
        page +++ data
        data.layout() { (main) in
            main.view.autoPinEdgesToSuperviewEdges()
        }

    }

    func load () {

        //collectionView.reloadData()
    }

    func buildInvitationData() -> Control {

        self.scrollView = UIScrollView.newAutoLayout()
        scrollView.isScrollEnabled = true
        scrollView.flashScrollIndicators()
        scrollView.canCancelContentTouches = false

        var container = Container(name: "Scroll-View", view: scrollView)
        self.section = Section(name: "section-req-data", view: UIView.newAutoLayout())
        container += section

        var row = newTitleRow()
        section <<< row
        row +++ MQForm.label(name: "invi-title", title: "招待リスト").layout {
            l in
            l.label.textColor = .orange
            l.label.textAlignment = .center
            l.height(20).fillHolizon().verticalCenter()
        }

        for i in invitationList {
            let row = Row.LeftAligned()
            row.layout() { r in
                r.fillHolizon().height(40)
            }

            section <<< row

            let title = MQForm.label(name: "invitationlabel", title: i.invitationTitle).width(200).height(30).layout {
                l in
                l.label.textColor = UIColor.lightGray
                l.verticalCenter().fillHolizon().rightMost(withInset: 27)
            }

            row +++ title
            
            let forward = MQForm.tapableImg(name: "forward", url: "forward").layout {
                f in
                f.rightMost(withInset: 5).width(22).height(25).verticalCenter()
                
            }.bindEvent(.touchUpInside) {
                f in
                self.showHandler?(i)
            }
            
            row +++ forward

            
            let messageRow = Row.LeftAligned()
            section <<< messageRow
            
            let msg = MQForm.label(name: "message", title: i.message).layout {
                m in
                m.fillHolizon().taller(than: 50).leftMargin(10)
                m.label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            }
            
            messageRow.layout{
                row in
                row.bottomAlign(with: msg).topAlign(with: msg)
            }
            
            messageRow +++ msg

            let buttonRow = Row.Intervaled().height(40)
            buttonRow.upMargin(5)
            buttonRow.spacing = 60
            
            section <<< buttonRow
            
            let accept = MQForm.button(name: "accept", title: "受け入れ").layout {
                b in
                b.height(30).leftMargin(10)
                b.button.backgroundColor = MittyColor.healthyGreen
            }.bindEvent(.touchUpInside) {
                _ in
                self.acceptHandler?(i)
                    
            }
            buttonRow +++ accept
            let reject = MQForm.button(name: "reject", title: "遠慮").layout {
                b in
                b.height(30).leftMargin(10)
                b.button.backgroundColor = MittyColor.lightYellow
            }
            
            buttonRow +++ reject
            
            // 招待を受け入れ拒否
            reject.bindEvent(.touchUpInside) {_ in
                // 承認
                InvitationService.instance.accept(i, status: "REJECT")
            }
            
        }

        if invitationList.count == 0 {
            let row = Row.LeftAligned().height(30)
            section <<< row

            row +++ MQForm.label(name: "invitation-content", title: "受付処理待ちの招待はありません。").layout {
                l in
                l.verticalCenter()
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
