//
//  NamecardOffersViewController.swift
//  mitty
//
//  Created by gridscale on 2017/09/01.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class NamecardOffersViewController : MittyViewController {
    let form = MQForm.newAutoLayout()
    let labelControl = MQForm.label(name: "aaa", title: "Underconstruction!")
    
    override func viewDidLoad() {
        self.view.addSubview(form)
        form +++ labelControl.layout {
            a in
            a.upper(withInset: 100).fillHolizon()
            a.label.textAlignment = .center
        }
        form.configLayout()
        self.view.backgroundColor = .white
        form.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top:10,left:10,bottom:10,right:10))
        self.view.setNeedsUpdateConstraints()
    }
}
