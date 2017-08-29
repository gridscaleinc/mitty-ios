//
//  ContacteeNamecard.swift
//  mitty
//
//  Created by gridscale on 2017/08/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class ContacteeNamecard {
    var namecardID: Int64 = 0          // `db:"name_card_id" json:"name_card_id"`
    var contactID: Int64 = 0           // `db:"contact_id" json:"contact_id"`
    var businessName: String = ""      // `db:"business_name" json:"business_name"`
    var businessLogoUrl: String = ""   //  json business_logo_url
    var relatedEventID: Int64 = 0      // `db:"related_event_id" json:"related_event_id"`
    var contctedDate: Date = .nulldate // `contacted_date:"id" json:"contacted_date"`
}
