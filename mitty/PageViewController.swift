//
//  HogeViewController.swift
//  mitty
//
//  Created by gridscale on 2016/11/08.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit
import PureLayout

@objc(HogeViewController)
class PageViewController: MittyViewController {

    var pageIndex: Int = 0
    let backImage: UIImageView = {
        let i = UIImageView.newAutoLayout()
        return i
    } ()

    //開始ボータン
    var startButton: UIButton = {
        let b = UIButton.newAutoLayout()
        b.setTitle("START", for: UIControlState.normal)
        b.isUserInteractionEnabled = true
        b.backgroundColor = UIColor.red

        return b

    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        super.autoCloseKeyboard()

        self.view.addSubview(backImage)

        startButton.addTarget(self, action: #selector(PageViewController.start), for: .touchUpInside)
        self.view.addSubview(startButton)


        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()

    }

    // Autolayout済みフラグ
    var didSetupConstraints = false

    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {

        if (!didSetupConstraints) {

            backImage.image = UIImage(named: "Guide\(pageIndex + 1)")
            backImage.autoPinEdge(toSuperviewEdge: .top)
            backImage.autoPinEdge(toSuperviewEdge: .leading)
            backImage.autoPinEdge(toSuperviewEdge: .trailing)
            backImage.autoPinEdge(toSuperviewEdge: .bottom, withInset: 100)

            startButton.autoPinEdge(.top, to: .bottom, of: backImage)

            startButton.autoPinEdge(toSuperviewEdge: .leading)
            startButton.autoPinEdge(toSuperviewEdge: .trailing)
            startButton.autoPinEdge(toSuperviewEdge: .bottom)

            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }

    func start() {
        let vc = MainTabBarController()
        vc.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        self.present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
