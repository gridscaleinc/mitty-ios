//
//  ActivitySelectionCell.swift
//  mitty
//
//  Created by gridscale on 2017/02/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class ActivitySelectionCell: UICollectionViewCell {
    static let id = "activity-selection-cell"
    
    var activitySelection : (label:UILabel, icon:UIImageView)? = nil
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    let iconView :UIView = {
        let v = UIView ()
        v.backgroundColor = UIColor(red: 0.95, green: 0.9, blue: 0.9, alpha: 0.9)
        v.layer.borderColor = UIColor.lightGray.cgColor
        v.layer.borderWidth = 0.5
        
        return v
    } ()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for v in contentView.subviews {
            v.removeFromSuperview()
        }
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(activitySelection!.label)
        contentView.addSubview(iconView)
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        iconView.autoPinEdgesToSuperviewEdges()
        iconView.autoPinEdge(toSuperviewEdge: .top)
        iconView.autoPinEdge(toSuperviewEdge: .left)
        iconView.autoPinEdge(toSuperviewEdge: .right)
        iconView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 35)
        
        activitySelection!.icon.autoCenterInSuperview()
        activitySelection!.icon.autoSetDimension(.height, toSize: 20)
        activitySelection!.icon.autoSetDimension(.width, toSize: 20)
        
        activitySelection!.label.autoPinEdge(.top, to: .bottom, of: iconView, withOffset:1)
        activitySelection!.label.autoPinEdge(toSuperviewEdge: .left, withInset: 3)
        activitySelection!.label.autoPinEdge(toSuperviewEdge: .right, withInset: 3)
        activitySelection!.label.autoPinEdge(toSuperviewEdge: .bottom, withInset: 3)
        
    }
    
    func configureView(activity: (label:String, icon:String)) {
        
        let l : UILabel = {
            return UILabel.newAutoLayout()
        }()
        l.text = activity.label
        l.textColor = UIColor(red: 0.5, green: 0.8, blue: 0.5, alpha: 1.0)
        l.font = UIFont(name:"AppleGothic", size: 12)
        
        let img : UIImageView = {
            return UIImageView.newAutoLayout()
        }()
        
        img.image = UIImage(named: activity.icon)
        
        iconView.addSubview(img)
        
        img.contentMode = UIViewContentMode.scaleAspectFit
        
        self.activitySelection = (l, img)
        
        addSubviews()
        configureSubviews()
        addConstraints()
        
    }
}
