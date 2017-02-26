//
//  ActivitySelectionForm.swift
//  mitty
//
//  Created by gridscale on 2017/02/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//


import Foundation
import UIKit
import PureLayout

@objc(ActivitySelectionForm)
class ActivitySelectionForm : UIView {
    
    let dummyLabel : UILabel = {
        let l = UILabel.newAutoLayout()
        l.backgroundColor = .clear
        return l
    } ()
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = false
        layout.sectionFootersPinToVisibleBounds = false
        
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    } ()
    
    func configLayout () {
        
        self.addSubview(dummyLabel)
        dummyLabel.autoPinEdge(toSuperviewEdge: .top, withInset:10)
        dummyLabel.autoSetDimension(.height, toSize: 0)
        
        collectionView.backgroundColor = .white
        
        self.addSubview(collectionView)
        
        collectionView.autoPinEdge(.top, to: .top, of:dummyLabel)
        collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 120)
        
        let footerView = UIView()
        footerView.backgroundColor = .red
        
        self.addSubview(footerView)
        footerView.autoPinEdge(.top, to: .bottom, of:collectionView)
        
        footerView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        footerView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        footerView.autoSetDimension(.height, toSize: 1)
    }
    
    func load () {
        collectionView.reloadData()
    }
    
}
