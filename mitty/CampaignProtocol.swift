//
//  Campaign.swift
//  mitty
//
//  Created by gridscale on 2017/01/27.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

protocol CampaignProtocol {
    func offer(campaign: Campaign)
    func join(campaign: Campaign, date: Date, numberOfAttendee : Int)
}
