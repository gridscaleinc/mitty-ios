//
//  RequestViewController.swift
//  mitty
//
//  Created by gridscale on 2017/04/18.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class RequestViewController : UIViewController {
    
    let form : MQForm = MQForm.newAutoLayout()
    
    override func viewDidLoad() {
        
        buildForm()
        
        self.view.addSubview(form)
        self.view.backgroundColor = .white
        form.autoPinEdgesToSuperviewEdges()
        form.configLayout()

    }
    
    func buildForm() {
        
        let height_normal : CGFloat = 60.0
        let height_tall : CGFloat = 100.0
        let height_middle : CGFloat = 80.0
        
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:900)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        
        let loginContainer = Container(name: "Login-form", view: scroll)
        
        form +++ loginContainer
        
        loginContainer.layout() { (container) in
            container.upper().fillHolizon().down(withInset: 10)
        }

        let inputForm = Section(name: "Input-Form", view: UIView.newAutoLayout())
        loginContainer +++ inputForm
        
        inputForm.layout() { c in
            c.upper().width(UIScreen.main.bounds.size.width).height(900)
        }
        
        var row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(0).height(40)
            r.view.backgroundColor = .red
        }
        
        row +++ MQForm.label(name: "Postrequest", title: "Post request").layout {
            c in
            c.height(40).width(300)
            c.leftMost(withInset: 20)
            let l = c.view as! UILabel
            l.textColor = .white
            l.font = .systemFont(ofSize: 18)
        }
        
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_normal)
        }
        
        row +++ MQForm.label(name: "Title", title: "タイトル").layout {
            c in
            c.height(height_normal).width(70)
            c.leftMost(withInset: 20)
        }
        
        row +++ MQForm.text(name: "title-text", placeHolder: "タイトルを入力").width(350).layout {
            t in
            t.height(height_normal).rightMost()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(120)
        }
        
        row +++ MQForm.label(name: "detail", title: "内容").layout {
            c in
            c.height(height_middle).width(70)
            c.leftMost(withInset: 20)
        }
        
        row +++ MQForm.text(name: "desciption", placeHolder: "体験したいこと、目的地などを").width(350).layout {
            t in
            t.height(height_tall).rightMost(withInset: 20)
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_tall)
        }
        
        row +++ MQForm.label(name: "lacation", title: "場所").layout {
            c in
            c.height(height_middle).width(70)
            c.leftMost(withInset: 20)
        }
        
        row +++ MQForm.text(name: "lationInfo", placeHolder: "エリア、場所").width(350).layout {
            t in
            t.height(height_tall).rightMost(withInset: 20)
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_normal)
        }
        row +++ MQForm.label(name: "Title", title: "希望日程").layout {
            c in
            c.height(height_normal).width(65)
            c.leftMost(withInset: 20)
        }
        row +++ MQForm.text(name: "startDate", placeHolder: "この日から").width(120).layout {
            t in
            t.height(height_normal)
        }
        row +++ MQForm.text(name: "endDate", placeHolder: "この日の間").width(120).layout {
            t in
            t.height(height_normal)
        }
        
        let dp = UIDatePicker.newAutoLayout()
        (row["startDate"]?.view as! UITextField).inputView = dp
        (row["endDate"]?.view as! UITextField).inputView = dp
        
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_normal)
        }
        row +++ MQForm.label(name: "priceTitle", title: "価格範囲").layout {
            c in
            c.height(height_normal).width(65)
            c.leftMost(withInset: 20)
        }
        row +++ MQForm.text(name: "startPrice", placeHolder: "ここから").width(90).layout {
            t in
            t.height(height_normal)
        }
        row +++ MQForm.text(name: "limitedPrice", placeHolder: "このまままで").width(120).layout {
            t in
            t.height(height_normal)
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_middle)
        }
        row +++ MQForm.label(name: "title2", title: "人数").layout {
            c in
            c.height(height_normal).width(65)
            c.leftMost(withInset: 20)
        }
        row +++ MQForm.text(name: "numOfPerson", placeHolder: "人数").width(70).layout {
            t in
            t.height(height_normal)
        }
        row +++ MQForm.label(name: "title3", title: "締切").layout {
            c in
            c.height(height_normal).width(40)
        }
        row +++ MQForm.text(name: "expiryDate", placeHolder: "提案締切日").width(120).layout {
            t in
            t.height(height_normal)
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_middle)
        }
        row +++ MQForm.button(name: "Post", title: "Post Request").layout { button in
            button.width(90).height(height_normal).holizontalCenter()
            let b = button.view as! UIButton
            b.backgroundColor = .orange
        }
        
        row["Post"]?.bindEvent(.touchUpInside) { [weak self] btn in
            self?.navigationController?.popViewController(animated: true)
        }
        
        inputForm <<< row
        
    }
    
    
}
