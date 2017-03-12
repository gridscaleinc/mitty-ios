//
//  Traveler.swift
//  mitty
//
//  Created by gridscale on 2017/03/05.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class ViewTraveler {
    
    func travel(_ v: UIView) -> Mitty {
        let m = Mitty()
        
        let c = ControlManager.retrieveOrCreateControl(linkedTo: v);
        
        m.controls.insert(c)
        
        for vx in v.subviews {
            travel(vx, m)
        }
        return m
    }
    
    @discardableResult
    func travel(_ v: UIView, _ mitty: Mitty) -> Mitty {
        let c = ControlManager.retrieveOrCreateControl(linkedTo: v);
        mitty.controls.insert(c)
        for vx in v.subviews {
            travel(vx, mitty)
        }
        
        return mitty
        
    }
}
