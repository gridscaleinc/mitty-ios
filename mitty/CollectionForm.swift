//
//  SmartForm.swift
//  mitty
//
//  Created by gridscale on 2017/02/27.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit
import PureLayout


@objc(CollectionForm)
class CollectionForm : MQForm {
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionFootersPinToVisibleBounds = false
        
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        return v
    } ()
    
    init () {
        super.init(frame: CGRect.zero)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RowCell.self, forCellWithReuseIdentifier: RowCell.id)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CollectionForm : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        let width = ( screenSize.width - 20 )
        let cellSize: CGSize = CGSize( width: width, height:30 )
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch(section){
        case 0:
            return CGSize(width: 300, height: 20)
        default:
            return CGSize(width: 300, height: 20)
        }
    }
    
}

extension CollectionForm: UICollectionViewDataSource {
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    // あるセクションから行を取得。
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RowCell.id, for: indexPath)
        var cell = collectionViewCell as! RowCell
        
        let s = indexPath.section
        let r = indexPath.row
        let row = sections[s][r]
        
        return cell <<< row
    }
    
}

@objc(RowCell)
class RowCell : UICollectionViewCell {
    static let id : String = "SMART-CELL"
    override func prepareForReuse() {
        for f in subviews {
            f.removeFromSuperview()
        }
    }
    
    @discardableResult
    static func <<< (left: inout RowCell, right: Container) -> RowCell {
        for (control) in right.children {
            left.addSubview(control.view)
        }
        right.configLayout()
        left.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        return left
    }
    
}

