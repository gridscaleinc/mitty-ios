//
//  MittyViewController.swift
//  mitty
//
//  Created by gridscale on 2017/05/14.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class MittyViewController : UIViewController {
    
    var error : Control?
    var lock = NSLock()
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            if let c = self.navigationController  {
                if c.viewControllers.count > 1 {
                    return true
                }
            }
            return super.hidesBottomBarWhenPushed
        }
        set (v) {
            super.hidesBottomBarWhenPushed = v
        }
    }
  
    func showError(_ errorMsg: String ) {
        lock.lock()
        defer {lock.unlock()}
        
        if error != nil {
            return
        }
        let message = UILabel.newAutoLayout()
        message.backgroundColor = .yellow
        message.text = errorMsg
        message.textAlignment = .center
        self.view.addSubview(message)
        
        error = Control(name: "error", view: message).layout{
            e in
            e.upper(withInset: 80).fillHolizon().height(40)
        }
        error?.configLayout()
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(clearMessage), userInfo: nil, repeats: true)
    }
    
    func clearMessage() {
        lock.lock()
        defer {lock.unlock()}
        
        if (error != nil) {
            error?.view.removeFromSuperview()
            error = nil
        }
    }
    
}
