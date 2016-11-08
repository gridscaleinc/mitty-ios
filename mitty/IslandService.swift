//
//  IslandService.swift
//  mitty
//
//  Created by gridscale on 2016/11/08.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation

// シングルトンサービスクラス。
class IslandService {
    static var instance : IslandService = {
        let instance = IslandService()
        return instance
    }()
    
    private init() {
        
    }
    
    // サーバーからイベントを検索。
    func search(keys : [String]) -> [Island] {
        
        // ダミーコード、本当はサーバーから検索する。
        var islands = [Island]()
        islands.append(buildIsland(1))
        islands.append(buildIsland(2))
        islands.append(buildIsland(3))
        islands.append(buildIsland(4))
        islands.append(buildIsland(5))
        
        return islands
        
    }
    
    // イベントを生成する
    func buildIsland(_ n:Int) ->Island! {
        
        let names: [String] = ["go-Lang勉強会","フィンテック展示会","IoTフォーラム","タイムスクエアニューイヤカウントダウン","タイムセール","年末飲み会"]
        
        let a = Island()
        
        a.islandId = "id" + String(n)
        a.islandName = names[n]
        return a;
    }
    
}
