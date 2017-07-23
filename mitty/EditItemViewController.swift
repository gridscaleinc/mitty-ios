//
//  EditItemViewController.swift
//  mitty
//
//  Created by gridscale on 2017/07/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class EditItemViewController: MittyViewController {

    var form = MQForm.newAutoLayout()
    
    
    var activityItem : ActivityItem
    
    let itemTitle = MQForm.text(name: "title", placeHolder: "タイトルを入力してください")
    
    let itemMemo = MQForm.textView(name: "memo")

    
    init(_ item: ActivityItem) {
        activityItem = item
        itemTitle.textField.text = item.title
        itemMemo.textView.text = item.memo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    var updateButton = MQForm.button(name: "update", title: "保存")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        super.loadView()
        
        self.form.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(form)
        
        form +++ itemTitle.layout {
            t in
            t.upper(withInset: 10).leftMost(withInset: 10).rightMost(withInset: 10).height(50)
            
        }
        
        form +++ itemMemo.layout {
            m in
            m.putUnder(of: self.itemTitle, withOffset: 2)
                .leftMost(withInset: 10).rightMost(withInset: 10).height(100)
        }
        
        form +++ updateButton.layout { [ weak self] b in
            b.holizontalCenter().width(130).height(45).putUnder(of: (self?.itemMemo)!, withOffset: 10)
        }
        
        let deleteButton = MQForm.button(name: "delete", title: "アイテムを削除")
        form +++ deleteButton
        deleteButton.layout() {
            c in
            c.view.backgroundColor = UIColor.red
            c.view.layer.cornerRadius = 8
            c.height(28).fillHolizon(60).putUnder(of: self.updateButton, withOffset: 40)
        }
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout

    }
    
    
    override func updateViewConstraints() {
        form.autoPin(toTopLayoutGuideOf: self, withInset:0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        form.configLayout()
        super.updateViewConstraints()
        
    }
    
    override func viewDidLoad() {
        
        super.autoCloseKeyboard()
        
        self.navigationItem.title = "活動アイテム編集"
        
        self.view.backgroundColor = UIColor.white
        
        updateButton.bindEvent(.touchUpInside) {
            [weak self] b in
            
            self?.updateActivityItem()
            
        }
        
        LoadingProxy.set(self)

    }
    
    func updateActivityItem() {
        
    }

}
