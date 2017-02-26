//
//  ActivitySelectionViewController.swift
//  mitty
//
//  Created by gridscale on 2017/01/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit
import PureLayout

class ActivitySelectionViewController : UIViewController {
    
    // activityList を作成する
    let form : ActivitySelectionForm
    
    let dataSource = ActivitySelectionDatasource()
    let delegate = ActivitySelectionDelegate()
    
    
    override func viewDidLoad() {
        
        // navigation bar の初期化をする
        
        // activityList を作成する
        
        // 線を引いて、対象年のフィルタボタンを設定する
        
        super.viewDidLoad()
        
        super.viewDidLoad()
        self.navigationItem.title = "活動追加"
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(form)
        configConstraints()
        form.configLayout()
        
        form.collectionView.dataSource = self.dataSource
        form.collectionView.delegate = self.delegate
        
        form.collectionView.register(ActivitySelectionCell.self, forCellWithReuseIdentifier:ActivitySelectionCell.id)
        self.form.collectionView.register(ActivityListHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ActivityListHeaderCell.id)
        self.form.load()
        
        self.view.setNeedsLayout()
        
    }
    
    init () {
        form = ActivitySelectionForm.newAutoLayout()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configConstraints() {
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom, withInset:0)
        form.backgroundColor = UIColor.white
    }

}


