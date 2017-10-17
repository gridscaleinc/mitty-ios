//
//  EditViewController.swift
//  mitty
//
//  Created by gridscale on 2017/07/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class EditViewController: MittyViewController {

    var form = MQForm.newAutoLayout()


    let activityTitle = MQForm.text(name: "title", placeHolder: "タイトルを入力してください")

    let memo = MQForm.textView(name: "memo")

    var updateButton = MQForm.button(name: "update", title: "保存")

    var activityInfo: ActivityInfo

    init(_ activity: ActivityInfo) {
        activityInfo = activity
        activityTitle.textField.text = activityInfo.title
        memo.textView.text = activityInfo.memo

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        super.loadView()

        self.form.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(form)

        form +++ activityTitle.layout {
            t in
            t.upper(withInset: 10).leftMost(withInset: 10).rightMost(withInset: 10).height(50)

        }

        let header = MQForm.label(name: "header", title: "<メモ>").layout {
            t in
            t.label.textColor = .black
            t.putUnder(of: self.activityTitle).leftMost(withInset: 10).rightMost(withInset: 10).height(30).upMargin(20)
        }
        
        form +++ header
        
        form +++ memo.layout {
            m in
            m.putUnder(of: header, withOffset: 2)
                .leftMost(withInset: 10).rightMost(withInset: 10).height(100)
        }

        form +++ updateButton.layout { [weak self] b in
            b.button.backgroundColor = .white
            b.button.setTitleColor(MittyColor.sunshineRed, for: .normal)
            b.holizontalCenter().width(130).height(45).putUnder(of: (self?.memo)!, withOffset: 10)
        }

        let deleteButton = MQForm.button(name: "delete", title: "活動計画を削除")
        form +++ deleteButton
        deleteButton.layout() {
            c in
            c.view.backgroundColor = UIColor.red
            c.view.layer.cornerRadius = 8
            c.button.setTitleColor(.white, for: .normal)
            c.height(28).fillHolizon(60).putUnder(of: self.updateButton, withOffset: 40)
        }
        
        let warningMsg = MQForm.label(name: "alert", title: "◆注意：\r\n 活動計画を削除すると、付随する全ての予定も削除される。")
        form +++ warningMsg.layout {
            w in
            w.label.backgroundColor = UIColor.lightGray
            w.label.textColor = MittyColor.baseYellow
            w.label.layer.cornerRadius = 3
            w.label.layer.masksToBounds = true
            w.label.numberOfLines = 0
            w.leftMost(withInset: 20).rightMost(withInset: 20).putUnder(of: deleteButton, withOffset: 30)
        }
        
        deleteButton.bindEvent(.touchUpInside) {
            b in
            ActivityService.instance.removeActivity(id: Int64(self.activityInfo.id)!) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout

    }


    override func updateViewConstraints() {
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        form.configLayout()
        super.updateViewConstraints()

    }

    override func viewDidLoad() {

        super.autoCloseKeyboard()

        self.navigationItem.title = "活動編集"

        self.view.backgroundColor = UIColor.white

        updateButton.bindEvent(.touchUpInside) {
            [weak self] b in

            self?.updateActivity()

        }

        LoadingProxy.set(self)

    }

    func updateActivity() {
        activityInfo.title = activityTitle.textField.text!
        activityInfo.memo = memo.textView.text
        ActivityService.instance.save(activityInfo, onCompletion: {
            info in
            if self.onEditComplete != nil {
                self.onEditComplete!(info)
            }
            self.navigationController?.popViewController(animated: true)
        },
                                      onError: { error in
                                          print(error)
                                      })

    }

    var onEditComplete: ((_ info: ActivityInfo) -> Void)?
}
