//
//  MeetingStatusForm.swift
//  mitty
//
//  Created by gridscale on 2017/10/23.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class MeetingStatusForm : Section {
    private var statusRow = Row.LeftAligned().layout {
        l in
        l.fillHolizon().height(40)
    }
    
    private var notificationRow = Row.LeftAligned().layout {
        l in
        l.fillHolizon().height(40)
    }
    
    var teleportButton = MQForm.button(name: "teleport", title: "Teleport")
    func loadForm () {
        self.view.backgroundColor = UIColor(white: 0.92, alpha: 0.8)
        
        self +++ statusRow
        statusRow +++ teleportButton.layout {
            b in
            b.verticalCenter().rightMost(withInset: 10).width(120)
        }
        self <<< statusRow
    }
}
