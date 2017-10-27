//
//  GuidanceForm.swift
//  mitty
//
//  Created by gridscale on 2017/10/25.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class GuidanceForm: MQForm {
    let showA = false
    let showB = false
    
    let section = Section()
    var loaded = false
    func load() {
        self.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        if loaded {
            self.configLayout()
            return
        }
        
        self +++ section.layout {
            s in
            s.fillHolizon().upper()
        }
        
        let row = Row.LeftAligned().layout {
            r in
            r.height(40).fillHolizon()
        }
        
        section <<< row
        
        let searchBox = MQForm.text(name: "search-box", placeHolder: "今日は何をしましょうか?")
        
        row +++ searchBox.layout() {
            l in
            l.height(30).fillHolizon().verticalCenter().leftMargin(5)
        }
        
        searchBox.bindEvent(.editingDidBegin) {
            s in
            s.resignFirstResponder()
            self.searchHandler()
        }
        
        loaded = true
    }
    
    override func configLayout() {
        super.configLayout()
        self.autoPinEdge(.bottom, to: .bottom, of: section.view)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowOpacity = 0.4
        self.autoSetDimension(.width, toSize: 250)
        self.autoAlignAxis(toSuperviewAxis: .vertical)
        
    }
    
    var searchHandler : (()->Void)!
    
    
}
