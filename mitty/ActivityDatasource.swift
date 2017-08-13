//
//  ActivityDatasource.swift
//  mitty
//
//  Created by gridscale on 2017/02/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class ActivitySelectionDatasource: NSObject, UICollectionViewDataSource {
    var controller: UIViewController

    init(controller: UIViewController) {
        self.controller = controller
    }

    let selectionList: [(label: String, type: String, icon: String)] = [
        ("空の旅", "Travel", "pengin1"),
        ("電車で出張", "Business Travel", "pengin1"),
        ("飲み会", "Drinking Party", "pengin1"),
        ("デート", "Dating", "pengin1"),
        ("運動", "Excersing", "pengin1"),
        ("買い物", "Shopping", "pengin1"),
        ("コンサート", "Concert", "pengin1"),
        ("映画鑑賞", "Cinema", "pengin1"),
        ("ペット", "Pet", "pengin1"),
        ("山・川", "Nature", "pengin1"),
        ("遊園地", "Lesure", "pengin1"),
        ("釣り", "Fishing", "pengin1"),
        ("ボランティア", "Volunteer", "pengin1"),
        ("部活", "School Club", "pengin1")
    ]

    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivitySelectionCell.id, for: indexPath) as? ActivitySelectionCell
            {
            let r = indexPath.row

            cell.configureView(activity: selectionList[r])
            cell.backgroundColor = UIColor(white: 0.99, alpha: 1)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(handler:)))
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
    var opTapHandler: ((_ cell: ActivitySelectionCell) -> Void)? = nil

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
