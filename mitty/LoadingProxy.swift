//
//  LoadingProxy.swift
//  mitty
//
//  Created by D on 2017/04/11.
//  Copyright © 2017 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

struct LoadingProxy{
    
    static var myActivityIndicator: UIActivityIndicatorView!
    
    static func set(_ v:UIViewController){
        self.myActivityIndicator = UIActivityIndicatorView()
        self.myActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.myActivityIndicator.center = v.view.center
        self.myActivityIndicator.hidesWhenStopped = false
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.myActivityIndicator.backgroundColor = UIColor.clear
        self.myActivityIndicator.layer.masksToBounds = true
        self.myActivityIndicator.layer.cornerRadius = 5.0;
        self.myActivityIndicator.layer.opacity = 0.8;
        v.view.addSubview(self.myActivityIndicator);
        self.off();
    }
    static func on(){
        myActivityIndicator.startAnimating();
        myActivityIndicator.isHidden = false;
    }
    static func off(){
        myActivityIndicator.stopAnimating();
        myActivityIndicator.isHidden = true;
    }
    
}

