//
//  NewProposalReq.swift
//  mitty
//
//  Created by gridscale on 2017/08/12.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class NewProposalReq: JSONRequest {
    enum KeyNames: String {

        case ReplyToRequestID = "reply_to_request_id"
        case ContactTel = "contact_tel"
        case ContactEmail = "contact_email"
        case ProposedIslandID = "proposed_island_id"
        case ProposedIslandID2 = "proposed_island_id2"
        case GalleryID = "gallery_id"
        case PriceName1 = "priceName1"
        case Price1 = "price1"
        case PriceName2 = "priceName2"
        case Price2 = "price2"
        case PriceCurrency = "price_currency"
        case PriceInfo = "price_info"
        case ProposedDatetime1 = "proposed_datetime1"
        case ProposedDatetime2 = "proposed_datetime2"
        case AdditionalInfo = "additional_info"
        case ProposerInfo = "proposer_info"
        case ConfirmTel = "confirm_tel"
        case ConfirmEmail = "confirm_email"

    }

    func setStr(_ key: KeyNames, _ value: String?) {
        setStr(named: key.rawValue, value: value)
    }

    func setBool(_ key: KeyNames, _ value: Bool?) {
        setBool(named: key.rawValue, value: value!)
    }

    func setDate(_ key: KeyNames, _ value: Date?) {
        setDate(named: key.rawValue, date: value!)
    }

    func setInt(_ key: KeyNames, _ value: String) {
        setInt(named: key.rawValue, value: value)
    }

    func setDouble(_ key: KeyNames, _ value: String) {
        setDouble(named: key.rawValue, value: value)
    }
}
