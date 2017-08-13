//
//  ActivityEntryController.swift
//  mitty
//
//  Created by gridscale on 2017/05/02.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class ActivityEntryViewController: MittyViewController {
    var pageTitle = "活動作成"
    var form = MQForm.newAutoLayout()

    let activityTitle = MQForm.text(name: "title", placeHolder: "タイトルを入力してください")

    let memo = MQForm.textView(name: "memo")

    let doneButton = MQForm.button(name: "done", title: "Done")

    var pickedInfo: PickedInfo? = nil

    override func loadView() {

        // navigation bar の初期化をする

        // activityList を作成する

        // 線を引いて、対象年のフィルタボタンを設定する

        super.loadView()

        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(form)


        form +++ activityTitle.layout {
            t in
            t.upper(withInset: 10).leftMost(withInset: 10).rightMost(withInset: 10).height(50)

        }

        let caption = MQForm.label(name: "caption", title: "活動・計画メモ").layout {
            c in
            c.height(20).fillHolizon(10)
            c.label.backgroundColor = MittyColor.light
            c.label.textColor = .gray
            c.label.textAlignment = .center
            c.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            c.putUnder(of: self.activityTitle, withOffset: 10)
        }

        form +++ caption

        form +++ memo.layout {
            m in
            m.putUnder(of: caption, withOffset: 2)
                .leftMost(withInset: 10).rightMost(withInset: 10).height(100)
        }

        form +++ doneButton.layout { [weak self] b in
            b.holizontalCenter().width(130).height(45).putUnder(of: (self?.memo)!, withOffset: 10)
        }

        if let info = pickedInfo {
            memo.textView.text = info.siteTitle
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

        self.navigationItem.title = pageTitle

        self.view.backgroundColor = UIColor.white

        doneButton.bindEvent(.touchUpInside) {
            [weak self] b in

            self?.registerActivity()

        }

        LoadingProxy.set(self)
    }

    func registerActivity() {

        let title = activityTitle.textField.text!
        let memoText = memo.textView.text!

        if (title == "" || memoText == "") {
            showError("タイトルとメモを入力してください")
            return
        }

        ActivityService.instance.register(activityTitle.textField.text!, memo.textView.text!
                                          , "0", onCompletion: {
                                              act in
                                              if let info = self.pickedInfo {
                                                  let vc = ActivityPlanViewController(act)
                                                  vc.webpicker(nil, info)
                                                  self.navigationController?.pushViewController(vc, animated: true)
                                              } else {
                                                  let vc = ActivityPlanDetailsController(act)
                                                  vc.status = 1
                                                  self.navigationController?.pushViewController(vc, animated: true)
                                              }
                                          },
                                          onError: { error in

                                              LoadingProxy.off()
                                              print(error)
                                              let count = self.navigationController?.viewControllers.count
                                              let vc = self.navigationController?.viewControllers[count! - 2]
                                              self.navigationController?.popToViewController(vc!, animated: true)
                                          })

    }
}
