//
//  ProposalDetailsViewController.swift
//  mitty
//
//  Created by gridscale on 2017/08/24.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class ProposalDetailsViewController: MittyViewController {
    var proposalInfo : ProposalInfo!
    
    let form = MQForm.newAutoLayout()
    
    override func viewDidLoad() {
        self.view.addSubview(form)
        
        form +++ MQForm.label(name: "TODO", title: "作成中").layout{
            l in
            l.upper(withInset: 60).leftMost()
        }
        
        self.view.backgroundColor = .white
        
        form.configLayout()
        
    }
    
}
