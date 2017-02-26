//
//  ActivityDatasource.swift
//  mitty
//
//  Created by gridscale on 2017/02/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class ActivitySelectionDatasource : NSObject, UICollectionViewDataSource {
    
    let selectionList : [(label:String, icon:String)] = [
        ("空の旅", "pengin1"), ("電車で出張", "pengin1"),("飲み会", "pengin1"),
        ("デート", "pengin1"), ("運動", "pengin1"),("買い物", "pengin1"),
        ("コンサート", "pengin1"), ("映画鑑賞", "pengin1"),("ペット", "pengin1"),
        ("山・川", "pengin1"), ("遊園地", "pengin1"),("釣り", "pengin1"),
        ("ボランティア", "pengin1"), ("部活", "pengin1")
    ]
    
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivitySelectionCell.id, for: indexPath ) as? ActivitySelectionCell
        {
            let r = indexPath.row
            
            cell.configureView(activity: selectionList[r])
            cell.backgroundColor = UIColor(white: 0.99, alpha: 1)
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        }
        return ActivitySelectionCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ActivityListHeaderCell.id, for: indexPath) as? ActivityListHeaderCell
        {
            header.backgroundColor = UIColor.init(red: 0.7, green: 0.8, blue: 0.7, alpha: 1.0)
            header.config()
            header.titleLabel.text = "定義済活動一覧"
            return header
        }
        return ActivityListHeaderCell()
    }
    
    // Tapイベントハンドラー
    var opTapHandler : ((_ cell: ActivitySelectionCell) -> Void)? = nil
    
    /// CellがTapされたら、ハンドラーを呼び出し。
    func cellTapped(handler: UITapGestureRecognizer) {
        let cell = handler.view as! ActivitySelectionCell
        print(cell.activity?.label ?? "")
        opTapHandler?(cell)
    }
    
    /// ViewControllerよりイベントハンドラーを登録。
    func onCellTapped(handler: @escaping (_ cell: ActivitySelectionCell) -> Void) {
        self.opTapHandler = handler
    }
}

// MARK: - UITableViewDataSource
class ActivityListDataSource:NSObject, UICollectionViewDataSource {
    let activityList : [(label:String, imgName:String)] = [
        (label: "2/18 平和島公園", imgName: "timesquare"),
        (label: "2/19 フィンテック＠ビグサイト", imgName: "pengin1"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/18 Iot どこかで", imgName: "pengin3"),
        (label: "2/18 島祭り", imgName: "pengin"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/18 島祭り", imgName: "pengin"),
        (label: "2/18 平和島公園", imgName: "timesquare"),
        (label: "2/19 フィンテック＠ビグサイト", imgName: "pengin1"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/18 Iot どこかで", imgName: "pengin3"),
        (label: "2/18 島祭り", imgName: "pengin"),
        (label: "2/18 沖縄ペンギン島", imgName: "pengin2"),
        (label: "2/18 島祭り", imgName: "pengin")
    ]
    
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.id, for: indexPath ) as? ActivityCell
        {
            let r = indexPath.row
            cell.configureView(info: activityList[r])
            cell.backgroundColor = UIColor(white: 0.99, alpha: 1)
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        }
        return ActivityCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ActivityListHeaderCell.id, for: indexPath) as? ActivityListHeaderCell
        {
            header.backgroundColor = UIColor.init(red: 0.7, green: 0.8, blue: 0.7, alpha: 1.0)
            header.config()
            return header
        }
        return ActivityListHeaderCell()
    }
    
    ///
    func cellTapped(handler: UITapGestureRecognizer) {
        print("Heeey")
    }
    
    //TODO セクションのヘッダーをつける
    
}
