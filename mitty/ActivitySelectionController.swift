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

class ActivitySelectionViewController : MittyUIViewController {
    
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
        self.navigationItem.title = "活動種類選択"
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(form)
        configConstraints()
        form.configLayout()
        
        // Closure を利用して、イベント処理をする。
        dataSource.onCellTapped () {  (cell) in
            print(cell.activity?.label ?? "")
            let vc = ActivityPlanViewController()
            vc.activityTitle = (cell.activity?.label)!
            
            self.navigationItem.title = "戻る"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        form.collectionView.dataSource = self.dataSource
        form.collectionView.delegate = self.delegate
        
        form.collectionView.register(ActivitySelectionCell.self, forCellWithReuseIdentifier:ActivitySelectionCell.id)
        self.form.collectionView.register(ActivityListHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ActivityListHeaderCell.id)
        self.form.load()
        
        
        self.view.setNeedsLayout()
        
        let _ = mitty()
        
    }
    
    override init () {
        form = ActivitySelectionForm.newAutoLayout()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 子画面からモドたら、tabバーを戻す。
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "活動種類選択"
    }
    
    func configConstraints() {
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom, withInset:0)
        form.backgroundColor = UIColor.white
    }

}


