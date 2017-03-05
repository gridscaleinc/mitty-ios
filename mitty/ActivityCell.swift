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

typealias ActivityTuple = (label:UILabel, icon:UIImageView)
class ActivityCell: UICollectionViewCell {
    static let id = "activity-cell"
    
    var activity : ActivityTuple? = nil
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        activity = nil
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(activity!.label)
        contentView.addSubview(activity!.icon)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for v in contentView.subviews {
            v.removeFromSuperview()
        }
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        
        activity!.label.autoPinEdge(toSuperviewEdge: .top)
        activity!.label.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        activity!.label.autoSetDimension(.height, toSize: 30)
        activity!.label.autoSetDimension(.width, toSize: 250)
        
        activity!.icon.autoPinEdge(.top, to: .top, of: activity!.label)
        activity!.icon.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
        activity!.icon.autoSetDimension(.height, toSize: 20)
        activity!.icon.autoSetDimension(.width, toSize: 30)
        
    }
    
    func configureView(info: (label:String, imgName: String)) {
        
        self.activity = buildCell(label: info.label, imgName: info.imgName)
        
        addSubviews()
        configureSubviews()
        addConstraints()
        
    }
    
    func buildCell (label: String, imgName: String? = nil, imgUrl: URL?=nil ) -> ActivityTuple {
        let l = UILabel.newAutoLayout()
        l.text = label
        l.textColor = UIColor(red: 0.3, green: 0.6, blue: 0.4, alpha: 0.9)
        l.font = UIFont(name:"AppleGothic", size: 12)
        
        let img = UIImageView.newAutoLayout()
        img.contentMode = UIViewContentMode.scaleAspectFit
        
        if (imgName != nil) {
            img.image = UIImage(named: imgName!)
        }
        
        return (l,img)
        
    }
}

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
