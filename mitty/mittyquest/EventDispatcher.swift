//
//  EventDispatcher.swift
//  mitty
//
//  Created by gridscale on 2017/03/06.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


// MittyEventDispatcherはViewControllerごとに生成し、
// 一つの画面(Formの集まり）を範囲とした画面系イベント及びモーション、リモートコントロラーイベントを対応。
// ライフサイクルはViewControllerのライフサイクルと整合性をとる。
// 複数のイベント源があることを考慮し、マルチスレッドの対応を備える。
//
class MittyEventDispatcher {
    
    // View<->Cotnrollマッピングデータ
    // Mittyフォームへのリファレンス
    //　RawイベントとFormEventのマッピング
    
    func dispatchRemoteControllerEvent() {
         // configに応じて、処理する
    }
    
    func dispatchGestureEvent () {
        
        
        
    }
    
    func dispatchTouchEvent () {
        
        
    }
    
    
    func dispatchMotionEvent() {
        
    }
}

extension MittyEventDispatcher  {
    // map Raw Event to Form Event 
    // using Form Event to dispach event to the Closure Event Hook
    
    // if no FormEvent (It shoud not be occure)
    // cance this event handle
    
    
}
