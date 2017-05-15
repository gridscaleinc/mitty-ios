//
//  ActivityCell.swift
//  mitty
//
//  Created by gridscale on 2017/02/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class ActivityListHeaderCell : UICollectionReusableView {
    static let id = "activity-header-cell"
    let titleLabel : UILabel = {
        let l = UILabel.newAutoLayout()
        l.text = "活動予定一覧"
        return l
    } ()
    
    let hl : UILabel = {
        let l = UILabel.newAutoLayout()
        l.text = ""
        l.backgroundColor = .red
        return l
    } ()
    
    func config () {
        self.addSubview(titleLabel)
        self.addSubview(hl)
        titleLabel.autoPinEdgesToSuperviewEdges()

        hl.autoPinEdge(.bottom, to: .bottom, of: titleLabel)
        hl.autoPinEdge(.left, to: .left, of: titleLabel)
        hl.autoPinEdge(.right, to: .right, of: titleLabel)
        hl.autoSetDimension(.height, toSize: 1)
        
    }
    
}
