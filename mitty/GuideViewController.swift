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
    
    var mittyImage = UIImageView.newAutoLayout()
    var firLabel = UILabel.newAutoLayout()
    var baselabel = UILabel.newAutoLayout()
    var scrollView: UIScrollView!
    var imageView = UIImageView()
    var secLabel = UILabel.newAutoLayout()
    var thirLabel = UILabel.newAutoLayout()
    var startButton = UIButton.newAutoLayout()
    var pageContol = UIPageControl.newAutoLayout()

    let numOfPages = 3
    
    // Autolayout済みフラグ
    var didSetupConstraints = false
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        mittyImage = UIImageView(image: UIImage(named: "Guide1"))
        
        firLabel.text = "Mitty - May I talk to you ?"
        firLabel.textColor = .red
        
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
            imageView.frame = CGRect(x: self.view.bounds.size.width * CGFloat(index), y: self.view.bounds.size.height * 0.2, width: self.view.bounds.size.width, height: self.view.bounds.size.height * 0.5)
            scrollView.addSubview(imageView)
        }
        
        secLabel.text = "活動情報をシェアしよう！"
        secLabel.textColor = .red
        thirLabel.text = "Mittyはプライバシーを守ります。"
        startButton.setTitle("使用開始", for: UIControlState.normal)
        startButton.setTitleColor(.blue, for: UIControlState.normal)
        startButton.addTarget(self, action: #selector(self.startBtnDo), for: .touchUpInside)
        baselabel.text = "----------------------------------------"
        baselabel.textColor = .blue

        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        self.view.setNeedsUpdateConstraints()
    }
    //Viewの表示処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        self.view.addSubview(mittyImage)
        self.view.addSubview(firLabel)
        self.view.addSubview(baselabel)
        self.view.addSubview(secLabel)
        self.view.addSubview(thirLabel)
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
            
            mittyImage.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: 30)
            mittyImage.autoPinEdge(toSuperviewEdge: ALEdge.top, withInset: 30)
            mittyImage.autoSetDimension(.width, toSize:self.view.bounds.size.width * 0.3)
            mittyImage.autoSetDimension(.height, toSize:self.view.bounds.size.height * 0.1)
            
            firLabel.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: 20)
            firLabel.autoPinEdge(toSuperviewEdge: ALEdge.top, withInset: 65)
            firLabel.autoSetDimension(.width, toSize: 200)
            firLabel.autoSetDimension(.height, toSize: 30)

            baselabel.autoPinEdge(.top, to: .bottom, of: mittyImage, withOffset: 10)
            baselabel.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
            baselabel.autoSetDimension(.width, toSize: 320)
            baselabel.autoSetDimension(.height, toSize: 30)

            secLabel.autoPinEdge(.top, to: .bottom, of: baselabel, withOffset: self.view.bounds.size.height * 0.5)
            secLabel.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: 10)
            secLabel.autoSetDimension(.width, toSize:250)
            secLabel.autoSetDimension(.height, toSize:30)
            
            thirLabel.autoPinEdge(.top, to: .bottom, of: secLabel, withOffset: 20)
            thirLabel.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: 20)
            thirLabel.autoSetDimension(.width, toSize:300)
            thirLabel.autoSetDimension(.height, toSize:30)
            
            startButton.autoPinEdge(.top, to: .bottom, of: thirLabel, withOffset: 20)
            startButton.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
            startButton.autoSetDimension(.width, toSize:80)
            startButton.autoSetDimension(.height, toSize:30)
            
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
