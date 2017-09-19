//
//  SocialMirror.swift
//  mitty
//
//  Created by gridscale on 2017/09/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class SocialMirror: Observable {
    var event: String = ""
    var todaysEvent: String = ""
    var eventInvitation: String = ""
    var businesscardOffer: String = ""
    var request: String = ""
    var proposal: String = ""

    var description: String {
        return "イベント:" + event + ", 本日の予定:" + todaysEvent + ", 招待:" + eventInvitation
            + ", 名刺交換:" + businesscardOffer + ", リクエスト:" + request + ", 提案:" + proposal
    }
}
