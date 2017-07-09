//
//  ProposalViewController.swift
//  mitty
//
//  Created by gridscale on 2017/07/09.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ProposalViewController : MittyViewController {

    var relatedRequest: RequestInfo!
    
    let form : MQForm = MQForm.newAutoLayout()
    
    let priceInput = MQForm.button(name: "priceInput" , title: "価格を入力" )
    let price1 = MQForm.label(name: "price1", title: "")
    var price1Row : Row? = nil
    
    let price2 = MQForm.label(name: "price2", title: "")
    var price2Row : Row? = nil
    
    let priceDetail = MQForm.label(name: "priceDetail", title: "")
    var priceDetailRow : Row? = nil

    
    override func viewDidLoad() {
        
        buildForm()
        
        self.view.addSubview(form)
        self.view.backgroundColor = .white
        
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        form.configLayout()
        
    }
    
    func buildForm() {
        
        let row_height = CGFloat(50)
        let line_height = CGFloat(48)
        
        
        form.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)
        let anchor = MQForm.label(name: "dummy", title: "").layout {
            a in
            a.height(0).leftMost().rightMost()
        }
        form +++ anchor
        
        // スクロールViewを作る
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:900)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        let scrollContainer = Container(name: "Detail-form", view: scroll).layout() { (container) in
            container.fillParent()
        }
        
        form +++ scrollContainer
        
        let detailForm = Section(name: "Content-Form", view: UIView.newAutoLayout())
        
        scrollContainer +++ detailForm
        
        var row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(0).height(25)
        }
        
        let titleLabel = MQForm.label(name: "Title", title: relatedRequest.title).layout {
            l in
            l.fillHolizon(10).height(25)
            l.view.backgroundColor = MittyColor.healthyGreen
            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 24)
            (l.view as! UILabel).textColor = .white
            (l.view as! UILabel).numberOfLines = 0
        }
        
        row +++ titleLabel
        
        detailForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(0).height(25)
        }
        let tagLabel = MQForm.label(name: "tag", title: "🏷 " + relatedRequest.tag).layout {
            l in
            l.width(35).height(35).fillHolizon(10)
            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 15)
            (l.view as! UILabel).textColor = .gray
            (l.view as! UILabel).numberOfLines = 1
        }
        row +++ tagLabel
        detailForm <<< row
        
        row = Row.LeftAligned()
        
        let actionLabel = MQForm.label(name: "action", title: (relatedRequest.desc)).layout {
            c in
            c.fillHolizon(10)
            let l = c.view as! UILabel
            l.numberOfLines = 3
            l.textColor = .black
            l.font = .systemFont(ofSize: 15)
            l.layer.cornerRadius = 2
            l.layer.borderWidth = 0.8
            l.layer.borderColor = UIColor.gray.cgColor
            l.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
        }
        row.layout {
            r in
            r.fillHolizon(0).bottomAlign(with: actionLabel).topAlign(with: actionLabel)
        }
        
        row +++ actionLabel
        detailForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(0).height(35)
            r.view.backgroundColor = .orange
        }
        
        row +++ MQForm.label(name: "title-main-proposal", title: "提案情報登録").layout {
            c in
            c.height(40)
            c.leftMost(withInset: 20)
            let l = c.view as! UILabel
            l.textColor = .white
            l.font = .systemFont(ofSize: 16)
        }
        detailForm <<< row
        
        row = Row.LeftAligned()
        
        
        seperator(section: detailForm, caption: "価格")
        row = Row.LeftAligned().height(row_height)
        row +++ MQForm.label(name: "price", title: "価格").height(line_height).width(60)
        row +++ priceInput.layout{
            line in
            line.button.setTitleColor(MittyColor.healthyGreen, for: .normal)
            line.button.backgroundColor = .white
            line.button.layer.borderWidth = 0
            
            line.height(line_height).rightMost(withInset: 10)
        }
        
        detailForm <<< row
        
        price1Row = Row.LeftAligned().height(20)
        price1Row! +++ price1.layout {
            p in
            p.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            p.label.textColor = .gray
            p.fillHolizon(20)
        }
        
        detailForm <<< price1Row!
        
        price2Row = Row.LeftAligned().height(20)
        price2Row! +++ price2.layout {
            p in
            p.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            p.label.textColor = .gray
            p.fillHolizon(20)
            
        }
        
        detailForm <<< price2Row!
        
        priceDetailRow = Row.LeftAligned().height(30)
        priceDetailRow! +++ priceDetail.layout {
            p in
            p.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            p.label.textColor = .gray
            p.fillHolizon(20)
        }
        
        detailForm <<< priceDetailRow!



        //reply_to_request_id		int8
        //contact_tel		varchar	(20),
        //proposed_island_id		int8
        //priceName1		varchar	(1000),
        //price1		int
        //priceName2		varchar	(1000),
        //price2		int
        //priceCurrence		varchar	(1000),
        //priceInfo		varchar	(1000),
        //proposed_datetime1		timestamp
        //proposed_datetime2		timestamp
        //additionalInfo		varchar	(1000),
        //proposer_id		int8
        //proposed_date		timestamp
        //accept_status		varchar	(1000),
        //accept_date		timestamp
        //confirm_tel		varchar	(1000),
        //confirm_mail_address		varchar	(50),
        //approval_status		varchar	(1000),
        //approval_date		timestamp
        
        let bottom = Row.LeftAligned().layout {
            r in
            r.fillHolizon().upper(withInset: 100)
        }
        
        detailForm +++ bottom
        
        
        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }

    }
    
    func seperator(section : Section, caption: String) {
        let row = Row.Intervaled().layout() {
            r in
            r.height(23).fillHolizon()
        }
        
        let c = MQForm.label(name: "caption", title: caption).layout {
            c in
            c.height(20)
            c.label.backgroundColor = MittyColor.light
            c.label.textColor = .gray
            c.label.textAlignment = .center
            c.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
        row +++ c
        section <<< row
    }
    
    func updateLayout () {
        
        price1Row?.heightConstraints?.autoRemove()
        price1.heightConstraints?.autoRemove()
        price2Row?.heightConstraints?.autoRemove()
        price2.heightConstraints?.autoRemove()
        priceDetailRow?.heightConstraints?.autoRemove()
        priceDetail.heightConstraints?.autoRemove()
        
        
        if price1.label.text != "" {
            price1Row?.height(15)
            price1.height(15)
        } else {
            price1Row?.height(0)
            price1.height(0)
        }
        
        if price2.label.text != "" {
            price2Row?.height(15)
            price2.height(15)
        } else {
            price2Row?.height(0)
            price2.height(0)
        }
        
        if priceDetail.label.text != "" {
            priceDetailRow?.height(60)
            priceDetail.height(60)
        } else {
            priceDetailRow?.height(0)
            priceDetail.height(0)
        }
        
        
    }

}
