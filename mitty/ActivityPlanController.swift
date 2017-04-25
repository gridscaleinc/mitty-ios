//
//  ActivityPlanViewController.swift
//  mitty
//
//  Created by gridscale on 2017/01/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class ActivityPlanViewController : UIViewController {
    
    var activityTitle = "活動"
    var form = ActivityInputForm()
    
    override func loadView() {
        
        // navigation bar の初期化をする
        
        // activityList を作成する
        
        // 線を引いて、対象年のフィルタボタンを設定する
        
        super.loadView()
        
        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(form)

        
        form.loadForm()
        
        
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
        
        self.navigationItem.title = activityTitle
        
        self.view.backgroundColor = UIColor.white
        form.quest("[name=fromDateTime]").forEach() { (c) in
            let textField = c.view as! UITextField
            let picker = UIDatePicker()
            textField.inputView = picker
            picker.addTarget(self, action: #selector(setFromDateTime(_:)), for: .valueChanged)
        }
        
        form.quest("[name=toDateTime]").forEach() { (c) in
            
            let textField = c.view as! UITextField
            let picker = UIDatePicker()
            textField.inputView = picker
            picker.addTarget(self, action: #selector(setToDateTime(_:)), for: .valueChanged)
        
        }
        
        form.quest("[name=contact-Tel]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.keyboardType = .numberPad
        }
        
        form.quest("[name=contact-mail]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.keyboardType = .emailAddress
        }
        
        form.quest("[name=infoUrl]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.keyboardType = .URL
        }
        
        form.quest("[name=location]").bindEvent(for: .editingDidBegin) {
            c in
            c.resignFirstResponder()
            let controller = IslandPicker()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        manageKeyboard()
    }
    
    func setFromDateTime(_ picker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        form.quest("[name=fromDateTime]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.text = dateFormatter.string(from: picker.date)
        }
    }
    
    
    func setToDateTime(_ picker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        form.quest("[name=toDateTime]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.text = dateFormatter.string(from: picker.date)
        }
    }
    
    func manageKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(onKeyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    var scrollConstraints : NSLayoutConstraint?
    
    @objc
    func onKeyboardShow(_ notification: NSNotification) {
        //郵便入れみたいなもの
        let userInfo = notification.userInfo!
        //キーボードの大きさを取得
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardHeight = keyboardRect.size.height
        
        let scroll = form.quest("[name=Input-Container]").control()
        scrollConstraints?.autoRemove()
        scrollConstraints = scroll?.view.autoPinEdge(toSuperviewEdge: .bottom, withInset: keyboardHeight)
        self.view.setNeedsUpdateConstraints()

    }
    
    
    @objc
    func onKeyboardHide(_ notification: NSNotification) {
        scrollConstraints?.autoRemove()
        scrollConstraints = nil
        
        self.view.setNeedsUpdateConstraints()
    }
    
    
    
}


