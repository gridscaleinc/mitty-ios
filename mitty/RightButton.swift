//
//  RightButton.swift
//  mitty
//
//  Created by gridscale on 2016/11/11.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class RightButton : UIView {
    
    let arSwitch : UISwitch = {
        let arswitch = UISwitch.newAutoLayout()
        return arswitch
    } ()
    
    
    let navLabel : UILabel = {
        let l = UILabel.newAutoLayout()
        l.text = "AR"
        l.textColor = UIColor.red
        l.font = l.font.withSize(12.0)
        return l
    } ()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Setup
    private func addSubviews() {
        self.addSubview(navLabel)
        self.addSubview(arSwitch)
    }
    
    private func addConstraints() {
        navLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        navLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        navLabel.autoSetDimension(.height, toSize:15)
        navLabel.autoSetDimension(.width, toSize: 10)
        navLabel.autoCenterInSuperview()
        
        arSwitch.autoPinEdge(.left, to: .right , of : navLabel, withOffset: 0)
        arSwitch.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        arSwitch.autoSetDimension(.height, toSize:15)
        arSwitch.autoSetDimension(.width, toSize:20)
        arSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//        arSwitch.autoCenterInSuperview()
    }

    
}
