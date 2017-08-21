//
//  NameCard.swift
//  mitty
//
//  Created by gridscale on 2017/07/02.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class NameCard: Observable {
    
    var id: Int64 = 0
    var mittyId: Int = 0
    var name: String = ""
    var businessName: String = ""
    var businessLogoId : Int64 = 0
    var businessSubName: String = ""
    var businessTitle: String = ""
    var addressLine1: String = ""
    var addressLine2: String = ""
    var phone: String = ""
    var fax: String = ""
    var mobilePhone: String = ""
    var webpage: String = ""
    var email: String = ""
    var created: Date = .nulldate
    var updated: Date = .nulldate

    func notify() {
        for o in observers {
            o(self)
        }
    }
    
    private var observers: [Observer] = []

    func addObserver (handler: @escaping Observer) {
        observers.append(handler)
    }
}
