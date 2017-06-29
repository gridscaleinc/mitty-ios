//
//  UserInfo.swift
//  mitty
//
//  Created by gridscale on 2017/06/29.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation


class UserInfo {
    var id            : Int  = 0      // `db:"id" json:"id"`
    var name          : String  = ""  // `db:"name" json:"name"`
    var userName      : String  = ""  // `db:"user_name" json:"user_name"`
    var mailAddress   : String  = ""  // `db:"mail_address" json:"mail_address"`
    var status        : String  = ""  // `db:"status" json:"status"`
    var icon          : String  = ""  // `db:"icon" json:"icon"`
}
