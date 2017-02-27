//
//  ActivityListForm.swift
//  mitty
//
//  Created by gridscale on 2017/02/25.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

@objc(ActivityListForm)
class ActivityListForm : Form {
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
    
    let thisYear : UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("今年", for: UIControlState())
        ActivityListForm.setButtonStyle(button: button)
        return button
    } ()
    
    let nextYear:UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("来年", for: UIControlState())
        ActivityListForm.setButtonStyle(button: button)
        return button
    } ()
    
    let stepper:UIStepper = {
        let button = UIStepper.newAutoLayout()
        button.minimumValue = 2019
        button.maximumValue = 2049
        button.stepValue = 1
        button.tintColor = .lightGray
        button.value = 2019
        return button
    } ()
    
    
    let indicator : UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("2019", for: UIControlState())
        ActivityListForm.setButtonStyle(button: button)
        return button
    } ()
    
    
    static func setButtonStyle (button: UIButton) {
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.white, for: UIControlState.normal)
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configLayout () {
        
        self.addSubview(dummyLabel)
        dummyLabel.autoPinEdge(toSuperviewEdge: .top, withInset:10)
        dummyLabel.autoSetDimension(.height, toSize: 0)

        collectionView.backgroundColor = .white
        
        self.addSubview(collectionView)
        
        collectionView.autoPinEdge(.top, to: .top, of:dummyLabel)
        collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 200)
        
        let footerView = UIView()
        footerView.backgroundColor = .red
        
        self.addSubview(footerView)
        footerView.autoPinEdge(.top, to: .bottom, of:collectionView)
        
        footerView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        footerView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        footerView.autoSetDimension(.height, toSize: 1)
        
        self.addSubview(thisYear)
        self.addSubview(nextYear)
        
        let indicateYear = UIView()
        indicateYear.addSubview(stepper)
        indicateYear.addSubview(indicator)
        self.addSubview(indicateYear)
        
        
        let buttons = [thisYear, nextYear, indicateYear] as NSArray
        
        buttons.autoSetViewsDimension(.height, toSize: 70)
        buttons.autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: 10.0, insetSpacing: true, matchedSizes: true)
        thisYear.autoPinEdge(.top, to: .bottom, of:footerView, withOffset: 10)
        
        let indicators = [indicator, stepper] as NSArray
        indicators.autoDistributeViews(along: .vertical, alignedTo: .vertical, withFixedSpacing: 5, insetSpacing: true, matchedSizes: true)
        
        stepper.autoPinEdge(toSuperviewEdge: .left)
        stepper.autoPinEdge(toSuperviewEdge: .right)
        indicator.autoPinEdge(toSuperviewEdge: .left)
        indicator.autoPinEdge(toSuperviewEdge: .right)
        
//        stepper.addTarget(self, action: #selector(ActivityListForm.stepperOneChanged(stepper:)), for: UIControlEvents.valueChanged)
        
        registerHandler(stepper, .onChanged) {(v) in
            self.indicator.setTitle("\(Int((v as! UIStepper).value))年", for: UIControlState())
        }
        
        indicator.setTitle("\(Int(stepper.value))年", for: UIControlState())
    }
    
    func load () {
        collectionView.reloadData()
    }
}
