//
//  MittyNavigatorViewController.swift
//  mitty
//
//  Created by gridscale on 2017/10/25.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class MittyNavigatorViewController : UINavigationController {
    override func viewDidLoad() {
        self.pushViewController(CenterViewController(), animated: true)
    }
}
