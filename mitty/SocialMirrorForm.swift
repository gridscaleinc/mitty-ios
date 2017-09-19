//
//  SocialMirrorForm.swift
//  mitty
//
//  Created by gridscale on 2017/08/30.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout


// 汎用的なフォームを作成し、どのタブからもポップアップできるようにする。

class SocialBar: Row {

    var labelItem = MQForm.label(name: "title", title: "")
    var numberItem = MQForm.label(name: "number", title: "0")

    init(text: String) {
        super.init(name: text, view: UIView.newAutoLayout())
        super.distribution = .left
        self +++ labelItem.layout {
            l in
            l.height(40).width(150).leftMargin(5).verticalCenter()
            l.label.adjustsFontSizeToFitWidth = true
            l.label.textColor = MittyColor.healthyGreen

        }

        self +++ numberItem.layout {
            nu in
            nu.label.textAlignment = . right
            nu.rightMost(withInset: 10).height(40).width(100).verticalCenter()
            nu.label.textColor = UIColor.red
        }

        self.layout {
            l in
            l.fillHolizon(10).height(40)
        }

        labelItem.label.text = text
    }
    
    var num : String {
        get{ return numberItem.label.text ?? ""}
        set(v) {
            numberItem.label.text = v
        }
    }    
}

class SocialMirrorForm: Container {

    var eventLine = SocialBar(text: "イベント")
    var todaysEventLine = SocialBar(text: "本日の予定")
    var weeklyEventLine = SocialBar(text: "一週間以内の予定")
    var invitationLine = SocialBar(text: "イベント招待")
    var namecardOfferLine = SocialBar(text: "名刺交換")
    var requestLine = SocialBar(text: "リクエスト")
    var proposalLine = SocialBar(text: "提案")

    weak var navigator: UINavigationController?
    
    public init(_ navi: UINavigationController ) {
        self.navigator = navi
        
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width: 280, height: 300)
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.canCancelContentTouches = false


        super.init(name: "Social-Mirror", view: scroll)
        self.layout {
            m in
            m.width(300).height(280)
            m.verticalCenter().holizontalCenter()
        }

        let detailForm = Section(name: "Content-Form", view: UIView.newAutoLayout())
        detailForm.lineSpace = 10
        self +++ detailForm

        detailForm <<< eventLine
        sep(detailForm, under: eventLine)
        
        detailForm <<< todaysEventLine
        sep(detailForm, under: todaysEventLine)
        
        detailForm <<< invitationLine
        sep(detailForm, under: invitationLine)
        
        detailForm <<< namecardOfferLine
        sep(detailForm, under: namecardOfferLine)
        
        detailForm <<< requestLine
        sep(detailForm, under: requestLine)
        
        detailForm <<< proposalLine
        
        let nop = Row.LeftAligned()

        detailForm <<< nop


        detailForm.layout {
            f in
            f.fillParent(withInset:10).width(300).bottomAlign(with: nop)
            f.view.autoSetDimension(.height, toSize: 300, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.black
        }
        
        detailForm.bindEvent(.touchUpInside) {
            d in
            self.view.isHidden = true
        }
        
        namecardOfferLine.bindEvent(.touchUpInside) {
            line in
            let vc = OffersViewController()
            self.navigator?.pushViewController(vc, animated: true)
        }
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - section: <#section description#>
    ///   - control: <#control description#>
    func sep(_ section: Section, under control: Control) {
        let seperator = Row.LeftAligned().layout() {
            r in
            r.height(5).fillHolizon(2).putUnder(of: control, withOffset: 10)
            let layer = MittyColor.gradientLayer(.black, MittyColor.healthyGreen, .black)
            layer.frame = CGRect(x: 0, y: 0, width: 295, height: 1)
            r.view.layer.insertSublayer(layer, at: 0)
        }
        section +++ seperator
    }
    
    
    func load(_ m: SocialMirror) {
        eventLine.num = m.event
        todaysEventLine.num = m.todaysEvent
        namecardOfferLine.num = m.businesscardOffer
        invitationLine.num = m.eventInvitation
        requestLine.num = m.request
        proposalLine.num = m.proposal
        
    }
    

}
