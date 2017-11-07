//
//  ActivityPlanEditController.swift
//  mitty
//
//  Created by gridscale on 2017/10/10.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import AlamofireImage

class EventModifyViewController : ActivityPlanViewController {
    
    var event: Event!
    
    override init(_ info: ActivityInfo) {
        super.init(info)
    }
    
    //
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modifyForm = super.form as! EventModifyForm
        
        setEvent(event)
        
        
        modifyForm.modifyButton.bindEvent(.touchUpInside) { [weak self]
            c in
            self?.saveChanges()
        }
        
    }
    
    func setEvent(_ event: Event) {
        form.eventTitle.textField.text = event.title
        form.tagList.textField.text = event.tag
        form.action.textView.text = event.action
        
        let islandPick = IslandPick()
        islandPick.id = Int64(event.islandId) ?? 0
        islandPick.name = event.isLandName
        
        pickedIsland(landInfo: islandPick)
        
        
        let picker1 = form.startDate.textField.inputView as! UIDatePicker
        let picker2 = form.endDate.textField.inputView as! UIDatePicker
        
        
        picker1.date = event.startDate
        setFromDateTime(picker1)
        
        if (event.endDate != .nulldate) {
            picker2.date = event.endDate
            setToDateTime(picker2)
        }
        
        form.setImageUrl(event.coverImageUrl)
        
        form.detailDescription.textView.text = event.description
        form.infoSource.textView.text = event.sourceName
        form.infoUrl.textField.text = event.sourceUrl
        form.contactTel.textField.text = event.contactTel
        form.contactEmail.textField.text = event.contactMail
        
        form.officialUrl.textField.text = event.officialUrl
        form.organizer.textField.text = event.organizer
        
    }
    
    override func setForm() {
        super.form = EventModifyForm()
    }
    
    
    func saveChanges() {
        
    }
}
