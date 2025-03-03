//
//  MeetingCell.swift
//  mitty
//
//  Created by gridscale on 2017/06/04.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MeetingCell : UICollectionViewCell {
    static let id = "Event-Meeting-cell"
    
    // MARK: - View Elements
    var meetingInfo : MeetingInfo?
    
    let name: UILabel
    
    let icon: UIImageView
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        name = UILabel.newAutoLayout()
        icon = UIImageView.newAutoLayout()
        
        super.init(frame: frame)
        
        addSubviews()
        configureSubviews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(name)
        contentView.addSubview(icon)
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        
        name.autoPinEdge(toSuperviewEdge: .top)
        name.autoPinEdge(toSuperviewEdge: .left)
        name.autoPinEdge(toSuperviewEdge: .bottom)
        name.autoPinEdge(toSuperviewEdge: .right, withInset: 70)
        
        icon.autoPinEdge(toSuperviewEdge: .top)
        icon.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        icon.autoPinEdge(toSuperviewEdge: .bottom)
        icon.autoSetDimension(.width, toSize: 50)
        
        
    }
    
    func configureView(meeting: MeetingInfo) {
        
        self.meetingInfo = meeting
        
        name.numberOfLines = 2
        name.text = "#" + (meeting.title )
        name.textColor = MittyColor.labelColor
        
        if (meeting.logoUrl != "") {
            DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
            icon.af_setImage(withURL: URL(string: meeting.logoUrl)!, placeholderImage: UIImage(named: "timesquare"), completion : { image in
                if (image.result.isSuccess) {
                    self.icon.image = image.result.value
                }
            }
            )
        } else {
            icon.image = UIImage(named: "timesquare")
        }
        icon.contentMode = .scaleAspectFit
        
    }

}
