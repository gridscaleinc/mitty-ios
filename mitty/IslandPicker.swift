//
//  IslandPicker.swift
//  mitty
//
//  Created by gridscale on 2017/04/22.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import MapKit

// 島選択ユーティリティを実装
// 1.名称やアドレスから島を検索
// 2.存在しない場合、新規登録する。
// 3.検索しながら、地図を更新する。
// 4.地図を動かしたら、地図の住所を逆引きしてテキストボックスに反映する。

@available(iOS 9.3, *)
class IslandPicker : UIViewController {
    
    var selectedIsland : IslandInfo? = nil
    
    var candidates : [IslandInfo] = []
    var islandForm : IslandPickForm = IslandPickForm.newAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(islandForm)
        
        islandForm.autoPin(toTopLayoutGuideOf: self, withInset: 10)
        islandForm.autoPinEdge(toSuperviewEdge: .left)
        islandForm.autoPinEdge(toSuperviewEdge: .right)
        islandForm.autoPinEdge(toSuperviewEdge: .bottom)
        
        islandForm.buildForm(islandInfo: IslandInfo())
        islandForm.configLayout()

        self.navigationItem.title = "島選択"
        
    }
}
