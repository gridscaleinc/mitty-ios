//
//  NameCardViewController.swift
//  mitty
//
//  Created by gridscale on 2017/06/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

/// <#Description#>
class NameCardViewController: MittyViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let form: MQForm = MQForm.newAutoLayout()
    
    var nameCard = NameCard()
    var cardform = NameCardForm()
    var inputForm = NameCardInputForm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.autoCloseKeyboard()
        
        self.view.backgroundColor = UIColor.white
        
    
        self.view.addSubview(form)
        self.view.backgroundColor = .white
        
        buildForm()
    
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        self.view.setNeedsUpdateConstraints()
        
        for c in inputForm.selectAll().controls {
            if c.view is UITextField {
                c.bindEvent(.editingChanged) {
                    t in
                    
                    let n = c.name
                    let label = self.cardform[n]?.label
                    if (label == nil) {
                        return
                    }
                    label?.text = c.textField.text
                    
                }
                c.view.backgroundColor = MittyColor.lightYellow
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        form.configLayout()
    }
    
    func buildForm() {
        
        form.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)

        cardform.load()
        cardform.layout {
            c in
            c.fillHolizon().upper().height(220)
        }
        
        form +++ cardform
        
        // スクロールViewを作る
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 900)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        let scrollContainer = Container(name: "Detail-form", view: scroll).layout() { (container) in
            container.fillHolizon().putUnder(of: self.cardform).down()
        }
        
        form +++ scrollContainer
        
        let detailForm = Section(name: "Content-Form", view: UIView.newAutoLayout())
        scrollContainer +++ detailForm
        detailForm <<< Row.LeftAligned().layout{
            r in
            r.fillHolizon().height(20)
            r.view.backgroundColor = .black
        }
        
        let titleRow = Row.Intervaled().layout {
            r in
            r.fillHolizon()
        }
        
        titleRow +++ MQForm.label(name: "title", title: "名刺データを入力").layout{
            l in
            l.label.textAlignment = .center
            l.label.textColor = MittyColor.lightYellow
        }
        
        detailForm <<< titleRow
        
        inputForm.load()
        inputForm.view.backgroundColor = .black
        let row = Row.LeftAligned()
        row +++ inputForm.layout {
            c in
            c.fillHolizon().upper().bottomAlign(with: self.inputForm.fax, withOffset: 20)
        }
        row.layout{
            r in
            r.fillHolizon().topAlign(with: self.inputForm).bottomAlign(with: self.inputForm)
        }
        detailForm <<< row
        
        let bottom = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }
        
        detailForm <<< bottom
        
        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height - 220, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }
        
    }
}

