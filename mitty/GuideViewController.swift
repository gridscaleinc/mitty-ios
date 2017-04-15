//
//  GuideViewController.swift
//  mitty
//
//  Created by tyori on 2016/11/03.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

@objc (GuideViewController)
class GuideViewController: UIViewController {
    
    var mittyLogo = UIImageView.newAutoLayout()
    var slogan = UILabel.newAutoLayout()
    var scrollView: UIScrollView!
    var imageView = UIImageView()
    var usageLabel = UILabel.newAutoLayout()
    var message = UILabel.newAutoLayout()
    var startButton = UIButton.newAutoLayout()
    var pageContol = UIPageControl.newAutoLayout()

    let numOfPages = 3
    
    // Autolayout済みフラグ
    var didSetupConstraints = false
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        mittyLogo = UIImageView(image: UIImage(named: "applogo"))
        mittyLogo.alpha = 0.7
        
        slogan.text = "Mitty-May I talk to you?"
        slogan.textColor = .white
        slogan.font=UIFont.boldSystemFont(ofSize: 25)
        slogan.layer.shadowColor = UIColor.black.cgColor
        
        
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width * 3, height: self.view.bounds.size.height)
        for index  in 0..<numOfPages {
            imageView = UIImageView(image: UIImage(named: "Guide\(index + 1)"))
            imageView.frame = CGRect(x: self.view.bounds.size.width * CGFloat(index), y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height )
            scrollView.addSubview(imageView)
        }
        
        usageLabel.text = "生活の知恵をシェアしましょう"
        usageLabel.textColor = .white
        usageLabel.font=UIFont.systemFont(ofSize: 20)
        usageLabel.layer.shadowColor = UIColor.black.cgColor
        
        startButton.setTitle("開始", for: UIControlState.normal)
        startButton.backgroundColor = .orange
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        startButton.setTitleColor(.white, for: UIControlState.normal)
        startButton.layer.cornerRadius = 5
        
        message.text = "Mitty.co, Produced by Gridscale Inc."
        message.textColor = .lightGray
        message.layer.shadowColor = UIColor.black.cgColor
        
        startButton.addTarget(self, action: #selector(self.startBtnDo), for: .touchUpInside)


        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        self.view.setNeedsUpdateConstraints()
    }
    //Viewの表示処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        self.view.addSubview(mittyLogo)
        self.view.addSubview(slogan)
        self.view.addSubview(usageLabel)
        self.view.addSubview(message)
        self.view.addSubview(startButton)
        self.view.addSubview(pageContol)
    }
    
    //Go to the mainbar 
    func startBtnDo() {
        // let mainTabBarController: MainTabBarController = MainTabBarController()
        // present(mainTabBarController, animated:true, completion:nil)
         let signinViewController = SigninViewController()
         present(signinViewController, animated:true, completion:nil)
    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            
            mittyLogo.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: 20)
            mittyLogo.autoPinEdge(toSuperviewEdge: ALEdge.top, withInset: 40)
            mittyLogo.autoSetDimension(.width, toSize:80)
            mittyLogo.autoSetDimension(.height, toSize:80)
            
            slogan.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: 20)
            slogan.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: 20)
            slogan.autoPinEdge(.top, to: .bottom, of: mittyLogo, withOffset: 5)
            
            slogan.autoSetDimension(.width, toSize: 200)
            slogan.autoSetDimension(.height, toSize: 30)

            usageLabel.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: 20)
            usageLabel.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: 20)
            usageLabel.autoPinEdge(toSuperviewEdge: ALEdge.bottom, withInset: 120)
            usageLabel.autoSetDimension(.height, toSize:30)

            
            startButton.autoPinEdge(.top, to: .bottom, of: usageLabel, withOffset: 20)
            startButton.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
            startButton.autoSetDimension(.width, toSize:90)
            startButton.autoSetDimension(.height, toSize:40)
            
            message.autoPinEdge(toSuperviewEdge: ALEdge.bottom, withInset: 10)
            message.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: 20)
            message.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: 20)
            message.autoSetDimension(.height, toSize:30)

            
            pageContol.autoPinEdge(.top, to: .bottom, of: startButton, withOffset: 10)
            pageContol.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
            pageContol.autoSetDimension(.width, toSize: 80)
            pageContol.autoSetDimension(.height, toSize: 30)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    //メモリ障害警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
