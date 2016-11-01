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
    //
    // Purelayout流の画面パーツ作り方、必ずnewAutoLayoutを一度呼び出す。
    // 画面を構成するパーツだから、methoの中ではなく、インスタンス変数として持つ。
    //
    let scrollView  = UIScrollView.newAutoLayout()
    let contentView = UIView.newAutoLayout()
    
    let blueLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.backgroundColor = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
        label.textColor = .white
        label.text = NSLocalizedString("このビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。¥n繰り返し、このビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。¥nこのビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。このビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。このビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。このビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。このビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。このビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。このビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。このビューはPureLayout フレームワークにより画面を整列しています。上には一つのスクロールビューを設定し、スクロールビューにコンテンツビューを入れる。コンテンツビューにはこのラベルを表示している構造となっている。", comment: "何かがコメントがありましたら、どうぞ")
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
        contentView.addSubview(blueLabel)
        
        self.navigationItem.title = "これは島ビューです"
        
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
            
            blueLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            blueLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            blueLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
            blueLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }}
