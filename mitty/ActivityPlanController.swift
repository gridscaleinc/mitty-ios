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
        }
        
        form.quest("[name=toDateTime]").forEach() { (c) in
            
            let textField = c.view as! UITextField
            let picker = UIDatePicker()
            textField.inputView = picker
        
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
    }
    
    func pickDate (_ v: UIView) {
        
        let dateTime = v as! StyledTextField
        dateTime.resignFirstResponder()
        UIApplication.shared.keyWindow?.endEditing(true)
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.doneButtonTitle = "DONE"
        picker.todayButtonTitle = "Today"
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY年MM月dd日 HH:mm"
            // let fromDate = self?.quest("name=fromDate").control()?.view as! StyledTextField
            // let fromTime = self?.quest("name=fromTime").control()?.view as! StyledTextField
            
            print(formatter.string(from:date))
            dateTime.text = formatter.string(from:date)
        }
    }
    
}
