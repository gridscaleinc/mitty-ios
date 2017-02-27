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

class ActivityInputForm : SmartForm {
    
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
        
        var page :Page = self
        page = page +++ Section(name: "Main-Event")
            +++ Section(name: "Location")
            +++ Section(name: "Contact-Info")
            +++ Section(name: "Price-Info")
            +++ Section(name: "Remarks")
        
        let mainSection = page["Main-Event"]
        
        var row = Row() +++ buildTitle("Title", fieldTitle: "タイトル")
            +++ buildTextField(name: "Title-Text", placeHolder: "タイトルを入力", left:90, width:150)
    
        mainSection! +++ row
        
        row = Row() +++ buildTitle("Date-Title", fieldTitle: "日程")
            +++ buildTextField(name: "From-Date", placeHolder: "", left:90, width:100)
            +++ buildTextField(name: "From-Time", placeHolder: "", left:200, width:60)

        
        mainSection! +++ row
        
        
        row = Row() +++ buildTitle("Date-To-Title", fieldTitle: "      ~")
            +++ buildTextField(name: "To-Date", placeHolder: "", left:90, width:100)
            +++ buildTextField(name: "To-Time", placeHolder: "", left:200, width:60)
        
        mainSection! +++ row
        for i in 2  ..< 30  {
            row = Row() +++ buildTitle("Date-Title-" + String(i), fieldTitle: "項目−" + String(i))
                +++ buildTextField(name: "From-Date-" + String(i), placeHolder: "", left:90, width:100)
                +++ buildTextField(name: "From-Time-" + String(i), placeHolder: "", left:200, width:60)
                
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
        
    }
    
    func  buildTitle (_ fieldName: String, fieldTitle: String) -> Control {
        let l = UILabel.newAutoLayout()
        l.text = fieldTitle
        return Control(fieldName, l).layout {
            l.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            l.autoPinEdge(toSuperviewEdge: .top)
            l.autoSetDimension(.height, toSize: 30)
            l.autoSetDimension(.width, toSize: 70)
        }
    }
    
    ///
    func buildTextField(name: String, placeHolder: String, left: CGFloat, width: CGFloat) -> Control {
        let t = UITextField.newAutoLayout()
        t.placeholder = placeHolder
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.layer.borderWidth = 0.5
        t.backgroundColor = .white
        return Control(name, t).layout {
            t.autoPinEdge(toSuperviewEdge: .left, withInset: left)
            t.autoPinEdge(toSuperviewEdge: .top)
            t.autoSetDimension(.height, toSize: 30)
            t.autoSetDimension(.width, toSize: width)
        }
    }

}
