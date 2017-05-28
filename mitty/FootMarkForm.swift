//
//  FootMarkForm.swift
//  mitty
//
//  Created by gridscale on 2017/05/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class FootMarkForm : MQForm {
    
    
    let entryTime = MQForm.label(name: "name", title: "入島時刻：\(Date().dateTime)")
    let islandName = MQForm.label(name: "islandName", title: "羽田空港　ANA2290便")
    let addInfo = MQForm.text(name: "addInfo", placeHolder: "部屋・席番号を書いてください")
    
    func load () {
        
        let form = self
        
        form +++ entryTime.layout {
            b in
            b.upper(withInset: 10).leftMost(withInset: 0).height(20)
            b.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.label.textColor = MittyColor.healthyGreen
        }
        
        form +++ islandName.layout {
            b in
            b.putUnder(of: self.entryTime).leftMost(withInset: 0).height(20)
            b.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.label.textColor = MittyColor.healthyGreen
        }
        
        form +++ addInfo.layout {
            b in
            b.putUnder(of: self.islandName).leftMost(withInset: 0).height(30)
            b.textField.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.textField.textColor = MittyColor.healthyGreen
        }
        
    }
}
