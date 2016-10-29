//
//  Tab2ViewController.swift
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class IslandViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Mitty Tab2"

        self.view.backgroundColor = UIColor.white
        let lineButton = UIButton()
        lineButton.frame = CGRect(x: 150, y: 100, width: 100, height: 100)
        lineButton.tintColor = UIColor.blue
        lineButton.setTitle("Start LINE!", for: UIControlState.normal)
        lineButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        lineButton.addTarget(self, action: #selector(IslandViewController.postToLine), for: .touchUpInside)
        self.view.addSubview(lineButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func postToLine() {
        let text = "Hello!"
        let encodeMessage: String! = text.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let messageURL: NSURL! = NSURL( string: "line://msg/text/" + encodeMessage )
        if (UIApplication.shared.canOpenURL(messageURL as URL)) {
            UIApplication.shared.openURL( messageURL as URL)
        }
    }
}
