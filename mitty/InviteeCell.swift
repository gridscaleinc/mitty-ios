//
//  InviteeCell.swift
//  mitty
//
//  Created by gridscale on 2017/09/16.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import UIKit
import PureLayout

class InviteeCell: UICollectionViewCell {
    static let id = "invitee-info-cell"
    
    // MARK: - View Elements
    var contact : Contactee?
    
    let selectedLabel = MQForm.label(name: "selected", title: "")
    let itemImageView = MQForm.img(name: "icon", url: "")
    let name = MQForm.label(name: "selected", title: "")
    var selectedStatus = false
    var container = Row.LeftAligned()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        itemImageView.imageView.clipsToBounds=true
        itemImageView.imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        super.init(frame: frame)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter contact: <#contact description#>
    func configureView(contact: Contactee) {
        
        self.contact = contact
        
        container = Row.LeftAligned().layout {
            r in
            r.fillParent()
        }
        self.addSubview(container.view)
        
        selectedStatus = false
        container +++ selectedLabel.layout {
            l in
            l.height(25).width(40).leftMargin(10).verticalCenter()
            l.label.text = "☑️"
        }
        
        container +++ itemImageView.layout {
            i in
            i.height(30).width(30).verticalCenter().leftMargin(15)
            i.imageView.setMittyImage(url: contact.contactee_icon)
        }
        
        container +++ name.layout {
            n in
            n.height(25).rightMost(withInset:10).verticalCenter().leftMargin(30)
            n.label.numberOfLines = 1
            n.label.font = UIFont.boldSystemFont(ofSize: 15)
            n.label.text = contact.contactee_name
        }
        
        container.configLayout()
    }
    
    func toogleSelected () {
        selectedStatus = !selectedStatus
        if (selectedStatus) {
            selectedLabel.label.text = "✅"
        } else {
            selectedLabel.label.text = "☑️"
        }
    }
}
