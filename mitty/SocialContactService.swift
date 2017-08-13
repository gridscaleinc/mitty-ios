//
//  SocialContactService.swift
//  mitty
//
//  Created by gridscale on 2016/11/13.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation

// シングルトンサービスクラス。
class SocialContactService {
    static var instance: SocialContactService = {
        let instance = SocialContactService()
        return instance
    }()

    private init() {

    }

    // サーバーからイベントを検索。
    func search(keys: [String]) -> [SocialContactInfo] {

        // ダミーコード、本当はサーバーから検索する。
        var list = [SocialContactInfo]()
        list.append(buildContact(1))
        list.append(buildContact(2))
        list.append(buildContact(3))
        list.append(buildContact(4))

        return list

    }

    // イベントを生成する
    func buildContact(_ n: Int) -> SocialContactInfo! {

        let imagenames: [String] = ["pengin", "pengin1", "pengin2", "pengin3", "pengin1", "pengin2"]
        let names: [String] = ["Domanthan", "Dongri", "Yang", "Choii", "Lee", "Jack Ma"]

        let a = SocialContactInfo()
        a.name = names[n]
        a.imageUrl = imagenames[n]

        return a
    }

}
