//
//  HomeViewController.swift
//  mitty
//
//  Created by gridscale on 2016/10/30.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit

//Auto layout kit
import PureLayout

// 個人情報を管理するView
//

@objc(HomeViewController)
class HomeViewController: UIViewController {

    //
    // Purelayout流の画面パーツ作り方、必ずnewAutoLayoutを一度呼び出す。
    // 画面を構成するパーツだから、methoの中ではなく、インスタンス変数として持つ。
    //
    let scrollView  = UIScrollView.newAutoLayout()
    let contentView = UIView.newAutoLayout()
    
    //
    let queryTextBox : UITextField = {
        let textBox = UITextField.newAutoLayout()
        textBox.borderStyle = UITextBorderStyle.roundedRect
        return textBox;
    } ()
    
    //
    let queryButton : UIButton = {
        let button = UIButton.newAutoLayout()
        let im = UIImage(named: "search")
        button.setImage(im, for: UIControlState.normal)
        return button;
    } ()
    
    // Label
    let blueLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.2, alpha: 0.9)
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
        label.textColor = .white
        label.text = NSLocalizedString("検索結果：", comment: "何かがコメントがありましたら、どうぞ")
        return label
    }()
    
    // Autolayout済みフラグ
    var didSetupConstraints = false
    
    // ここまではメンバー変数定義
    
    // ビューがよもこまれた際に実行するメソッド。
    // ：Purelayoutの拡張ではない。
    override func loadView() {
        
        view = UIView()
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(queryTextBox)
        contentView.addSubview(queryButton)

        contentView.addSubview(blueLabel)

        self.navigationItem.title = "これはホームビューです"

        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()
    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            scrollView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
            
            contentView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
            contentView.autoMatch(.width, to: .width, of: view)
            
            queryTextBox.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            queryTextBox.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            queryTextBox.autoPinEdge(toSuperviewEdge: .trailing, withInset: 90)
            queryTextBox.autoSetDimension(.height, toSize:30)

            queryButton.autoPinEdge(.bottom, to: .bottom, of: queryTextBox)
            queryButton.autoPinEdge(.left, to: .right, of: queryTextBox, withOffset: 10)
            queryButton.autoSetDimension(.width, toSize:32)
            queryButton.autoSetDimension(.height, toSize:32)
            
            
            blueLabel.autoPinEdge(.top, to: .bottom, of: queryTextBox, withOffset: 10)
            blueLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            blueLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
            blueLabel.autoSetDimension(.height, toSize:30)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
