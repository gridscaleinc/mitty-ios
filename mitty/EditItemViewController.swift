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


    var activityItem: ActivityItem

    let itemTitle = MQForm.text(name: "title", placeHolder: "タイトルを入力してください")

    let itemMemo = MQForm.textView(name: "memo")


    let labelNoti = MQForm.label(name: "labelNotification", title: "お知らせ")
    let switchButton = MQForm.switcher(name: "notificationSwitch")

    let textNotifyTime = MQForm.text(name: "ntifyTime", placeHolder: "お知らせ時刻")
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        return picker
    } ()

    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    } ()

    init(_ item: ActivityItem) {
        activityItem = item
        itemTitle.textField.text = item.title
        itemMemo.textView.text = item.memo
        textNotifyTime.textField.inputView = timePicker
        super.init(nibName: nil, bundle: nil)

        timePicker.addTarget(self, action: #selector(setNotifyTime(_:)), for: .valueChanged)

    }

    var updateButton = MQForm.button(name: "update", title: "保存")

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        super.loadView()

        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(form)

        let section = MQForm.section(name: "itemEdit-Section")
        form +++ section.layout {
            s in
            s.fillParent()
        }

        // title line
        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(50)
        }
        
        row +++ itemTitle.layout {
            t in
            t.leftMargin(10).rightMost(withInset: 10).height(50).verticalCenter()

        }

        section <<< row

        // memo line
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(100).upMargin(3)
        }

        row +++ itemMemo.layout {
            m in
            m.leftMargin(10).rightMost(withInset: 10).height(100).verticalCenter()
        }

        section <<< row

        // notification line
        row = Row.LeftAligned().layout {
            r in
            r.leftMargin(10).height(30).rightMost(withInset: 10).upMargin(3)
        }

        row +++ labelNoti.layout {
            r in
            r.verticalCenter()
        }

        row +++ switchButton.layout {
            r in
            r.verticalCenter()
        }

        row +++ textNotifyTime.layout { t in
            t.height(30)
            t.rightMost(withInset: 20).verticalCenter().leftMargin(20)
        }

        section <<< row


        // buttons
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(60)
        }
        row.spacing = 100

        row +++ updateButton.layout {
            b in
            b.button.backgroundColor = .white
            b.button.setTitleColor(.orange, for: .normal)
            b.height(45)
        }

        section <<< row

        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(60)
        }
        row.spacing = 100

        let deleteButton = MQForm.button(name: "delete", title: "アイテムを削除")
        row +++ deleteButton.layout() {
            c in
            c.view.backgroundColor = UIColor.red
            c.view.layer.cornerRadius = 8
            c.height(28).fillHolizon(60)
        }
        deleteButton.bindEvent(.touchUpInside) {
            b in
            ActivityService.instance.removeItem(id: self.activityItem.id, of: self.activityItem.activityId) {
               self.navigationController?.popViewController(animated: true)
            }
        }
        
        section <<< row

        // バネ行
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }

        section <<< row


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

        self.navigationItem.title = "活動アイテム編集"

        self.view.backgroundColor = UIColor.white

        updateButton.bindEvent(.touchUpInside) {
            [weak self] b in

            self?.updateActivityItem()

        }

        LoadingProxy.set(self)

    }

    //
    func updateActivityItem() {

        activityItem.title = itemTitle.textField.text!
        activityItem.memo = itemMemo.textView.text
        activityItem.notification = switchButton.switcher.isOn
        activityItem.notificationTime = timePicker.date
        ActivityService.instance.saveItem(activityItem, onCompletion: {
            item in
            if self.onEditItemComplete != nil {
                self.onEditItemComplete!(item)
            }
            self.navigationController?.popViewController(animated: true)
        },
                                          onError: { error in
                                              print(error)
                                          })
    }

    //
    func setNotifyTime(_ picker: UIDatePicker) {
        let textField = textNotifyTime.textField
        textField.text = dateFormatter.string(from: picker.date)
    }


    var onEditItemComplete: ((_ info: ActivityItem) -> Void)?
}
