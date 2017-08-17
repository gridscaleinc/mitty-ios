//
//  Profile.swift
//  mitty
//
//  Created by gridscale on 2017/07/02.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class Profile: Observable {
    var id: Int64 = 0
    var mittyId: Int = 0
    var gender: String = ""
    var oneWordSpeech: String = ""
    var constellation: String = ""
    var homeIslandId: Int64 = 0
    var birthIslandId: Int64 = 0
    var ageGroup: String = ""
    var appearanceTag: String = ""
    var occupationTag1: String = ""
    var occupationTag2: String = ""
    var occupationTag3: String = ""
    var hobbyTag1: String = ""
    var hobbyTag2: String = ""
    var hobbyTag3: String = ""
    var hobbyTag4: String = ""
    var hobbyTag5: String = ""
    
    func notify() {
        for o in observers {
            o(self)
        }
    }
    
    
    private var observers : [Observer] = []
    
    func addObserver (handler : @escaping Observer) {
        observers.append(handler)
    }
}
