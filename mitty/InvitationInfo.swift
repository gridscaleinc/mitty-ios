//
//  InvitationInfo.swift
//  mitty
//
//  Created by gridscale on 2017/09/22.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class InvitationInfo {

    var id: Int64 = 0          //`db:"id" json:"id"`
    var invitaterID: Int = 0   //      `db:"invitater_id" json:"invitater_id"`
    var forType: String = ""   //`db:"for_type" json:"for_type"`
    var idOfType: Int64 = 0    //`db:"id_of_type" json:"id_of_type"`
    var invitationTitle: String = "" // `db:"invitation_title" json:"invitation_title"`
    var message: String = ""   //`db:"message" json:"message"`
    var timeOfInvitation: Date = .nulldate //`db:"time_of_invitation" json:"time_of_invitation"`
    var inviteesID: Int64 = 0              // `db: "invitees_id" json: "invitees_id"`
    var replyStatus: String = ""           // `db: "reply_status" json: "reply_status"`
}
