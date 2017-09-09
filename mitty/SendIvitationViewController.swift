//
//  SendInitationViewController.swift
//  mitty
//
//  Created by gridscale on 2017/08/07.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class SendInvitationViewController: MittyViewController {
    
    let form : MQForm = MQForm.newAutoLayout()
    
    let invitationTitle = MQForm.label(name: "invitation-title", title: "")
    let message = MQForm.textView(name: "invitation-message")
    
    var event : Event!
    
    var searchBar : UISearchBar = UISearchBar.newAutoLayout()

    
    override func viewDidLoad() {
        
        super.autoCloseKeyboard()
        
        
        self.view.addSubview(form)
        self.view.backgroundColor = .white
        
        buildForm()
        
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        self.view.setNeedsUpdateConstraints()
        
        searchBar.delegate = self
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
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
        
        seperator(section: detailForm, caption: "招待")
        
        
        var row = Row.LeftAligned().layout() {
            r in
            r.fillHolizon(0).height(60)
        }
        
        row +++ MQForm.label(name: "event-title", title: "イベント：").layout{
            l in
            l.width(120).height(line_height).verticalCenter()
            l.label.adjustsFontSizeToFitWidth = true
        }
        
        invitationTitle.label.text = event.title
        row +++ invitationTitle.layout {
            m in
            m.height(line_height).rightMost(withInset: 10).verticalCenter()
        }
        
        detailForm <<< row
        
        row = Row.LeftAligned().layout() {
            r in
            r.fillHolizon(0).height(65)
        }
        
        row +++ MQForm.label(name: "title-memo", title: "メッセージ").layout{
            l in
            l.width(120).verticalCenter()
            l.label.adjustsFontSizeToFitWidth = true
        }
        
        row +++ message.layout {
            m in
            m.height(60).rightMost(withInset: 10)
        }
        
        detailForm <<< row
        
        
        
        seperator(section: detailForm, caption:  "招待メンバーリスト")
        row = Row.LeftAligned().layout() {
            r in
            r.fillHolizon(0).height(65)
        }
        
        row +++ Control(name:"", view: searchBar).layout{
            l in
            l.fillHolizon().height(40).verticalCenter()
            
        }
        
        detailForm <<< row
        
        
        let bottom = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }
        
        detailForm <<< bottom
        
        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }
        
    }
    
}

// MARK: - UISearchBarDelegate
extension SendInvitationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
        if (searchBar.text == "") {
            return
        }
        
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
