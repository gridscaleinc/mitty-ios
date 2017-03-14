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
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionFootersPinToVisibleBounds = false
        
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    } ()
    
    let addButton : UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("+", for: UIControlState())
        MittyForm.setButtonStyle(button: button)
        button.backgroundColor = .red
        return button
    } ()
    
    let loadFromCalButton:UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("カレンダーから", for: UIControlState())
        MittyForm.setButtonStyle(button: button)
        button.backgroundColor = .orange
        
        return button
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
        
        let redLine = MittyForm.HL(parent:self, bottomOf: collectionView, UIColor.red)
        
        self.addSubview(addButton)
        addButton.autoPinEdge(.top, to: .bottom, of:redLine, withOffset:10)
        addButton.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        addButton.autoSetDimension(.height, toSize: 50)
        addButton.autoSetDimension(.width, toSize: 60)
        
        self.addSubview(loadFromCalButton)
        loadFromCalButton.autoPinEdge(.top, to: .bottom, of:redLine, withOffset:10)
        loadFromCalButton.autoPinEdge(.left, to: .right, of: addButton, withOffset: 10)
        loadFromCalButton.autoSetDimension(.height, toSize: 50)
        loadFromCalButton.autoSetDimension(.width, toSize: 140)
    }
    
    func load () {
        collectionView.reloadData()
    }
    
}
