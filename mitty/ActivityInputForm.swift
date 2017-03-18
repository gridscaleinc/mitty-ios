//
//  ActivityInputForm.swift
//  mitty
//
//  Created by gridscale on 2017/02/27.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit
import PureLayout

class ActivityInputForm : CollectionForm {
    
    let dummyLabel : UILabel = {
        let l = UILabel.newAutoLayout()
        l.backgroundColor = .clear
        return l
    } ()
    
    override init () {
       // ページのスタイルを設定。
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadPage() {
        
        var page : CollectionForm = self
        
        page += Section(name: "Main-Event")
        page += Section(name: "Location")
        page += Section(name: "Contact-Info")
        page += Section(name: "Price-Info")
        page += Section(name: "Remarks")
        
        var mainSection : Section = page["Main-Event"]!
        
        var row = Row.LeftAligned()
            +++ label("Title", fieldTitle: "タイトル")
            +++ textField(name: "Title-Text", placeHolder: "タイトルを入力", width:150)
    
        mainSection += row
        
        row = Row.LeftAligned()
           +++ label("Date-Title", fieldTitle: "日程")
           +++ textField(name: "From-Date", placeHolder: "", width:100)
           +++ textField(name: "From-Time", placeHolder: "", width:60)
        
        mainSection <<< row
        
        
        row = Row.LeftAligned()
           +++ label("Date-To-Title", fieldTitle: "      ~")
           +++ textField(name: "To-Date", placeHolder: "", width:100)
           +++ textField(name: "To-Time", placeHolder: "", width:60)
        
        mainSection <<< row

        for i in 2  ..< 30  {
            row = Row.LeftAligned()
                +++ label("Date-Title-" + String(i), fieldTitle: "項目−" + String(i))
            let subRow = Row.RightAligned()
                +++ textField(name: "From-Date-" + String(i), placeHolder: "", width:120)
                +++ textField(name: "From-Time-" + String(i), placeHolder: "", width:40)
                +++ label("Anchor" + String(i), fieldTitle: "    >" )
            
            subRow.size(w:250, h:30)
            row +++ subRow
            
            mainSection <<< row
        }
        
        self.addSubview(dummyLabel)
        dummyLabel.autoPinEdge(toSuperviewEdge: .top, withInset:1)
        dummyLabel.autoSetDimension(.height, toSize: 0)
        
        collectionView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)

        self.addSubview(collectionView)
        
        collectionView.autoPinEdge(.top, to: .top, of:dummyLabel)
        collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        
        collectionView.reloadData()
        
//        let m = mitty(self).forEach({ (c) -> Bool in
//            let t = type(of: c.view)
//            if (t is UITextField.Type) {
//                return true
//            }
//            return false
//        }) { (c) in
//            (c.view as! UITextField).text = "T#" + String(c.view.tag)
//            return
//        }
//        print(m.controls.count)
        
    }

}
