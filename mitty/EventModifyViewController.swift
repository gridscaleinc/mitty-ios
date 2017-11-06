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
        
        modifyForm.modifyButton.bindEvent(.touchUpInside) { [weak self]
            c in
            self?.saveChanges()
        }
        
    }
    
    override func setForm() {
        super.form = EventModifyForm()
    }
    
    func saveChanges() {
        
    }
}
