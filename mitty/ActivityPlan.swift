//
//  ActivityPlan.swift
//  mitty
//
//  Created by gridscale on 2017/01/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class ActivityPlan {
    var title: String = ""
    var date: NSDate? = nil
    
    init (title: String) {
        self.title = title
        date = nil
    }
    
}
