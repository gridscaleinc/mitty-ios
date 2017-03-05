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
        
        var page :MittyForm = self
        +++ Section1(name: "Main-Event")
        page += Section1(name: "Location")
        page += Section1(name: "Contact-Info")
        page += Section1(name: "Price-Info")
        page += Section1(name: "Remarks")
        
        var mainSection = page["Main-Event"]
        
        var row = Row1.LeftAlignedRow()
            +++ buildTitle("Title", fieldTitle: "タイトル")
            +++ buildTextField(name: "Title-Text", placeHolder: "タイトルを入力", left:90, width:150)
    
        mainSection! += row
        
        row = Row1.LeftAlignedRow()
           +++ buildTitle("Date-Title", fieldTitle: "日程")
           +++ buildTextField(name: "From-Date", placeHolder: "", left:90, width:100)
           +++ buildTextField(name: "From-Time", placeHolder: "", left:200, width:60)
        
        mainSection! +++ row
        
        
        row = Row1.LeftAlignedRow()
           +++ buildTitle("Date-To-Title", fieldTitle: "      ~")
           +++ buildTextField(name: "To-Date", placeHolder: "", left:90, width:100)
           +++ buildTextField(name: "To-Time", placeHolder: "", left:200, width:60)
        
        mainSection! +++ row
        for i in 2  ..< 30  {
            row = Row1.LeftAlignedRow()
                +++ buildTitle("Date-Title-" + String(i), fieldTitle: "項目−" + String(i))
            let subRow = Row1.RightAlignedRow()
                +++ buildTextField(name: "From-Date-" + String(i), placeHolder: "", left:90, width:120)
                +++ buildTextField(name: "From-Time-" + String(i), placeHolder: "", left:200, width:40)
                +++ buildTitle("Anchor" + String(i), fieldTitle: "    >" )
            
            subRow.size(w:250, h:30)
            row +++ subRow
            
            mainSection! +++ row
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
    
    func  buildTitle (_ fieldName: String, fieldTitle: String) -> Control1 {
        let l = UILabel.newAutoLayout()
        l.text = fieldTitle
        return Control1(name: fieldName, view: l).layout { (control) in
            control.size(w:70, h:30)
        }
    }
    
    ///
    func buildTextField(name: String, placeHolder: String, left: CGFloat, width: CGFloat) -> Control1 {
        let t = UITextField.newAutoLayout()
        t.placeholder = placeHolder
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.layer.borderWidth = 0.5
        t.backgroundColor = .white
        return Control1(name: name, view: t).layout { (control) in
            control.size(w:width, h: 30).leftMargin(10).rightMargin(10)
        }
    }

}
