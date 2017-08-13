//
//  EditBasicInfoViewController.swift
//  mitty
//
//  Created by gridscale on 2017/08/06.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class EditBasicInfoViewController: MittyViewController {

    var form = MQForm.newAutoLayout()


    let idlabel = MQForm.label(name: "id", title: "")
    let nameLabel = MQForm.label(name: "name", title: "")

    let maleLabel = MQForm.label(name: "male", title: "男性")
    let femaleLabel = MQForm.label(name: "female", title: "女性")

    let underage = MQForm.label(name: "underage", title: "未成年")
    let yuang = MQForm.label(name: "female", title: "青年")
    let middleage = MQForm.label(name: "male", title: "中年")
    let oldage = MQForm.label(name: "female", title: "老年")

    let speech = MQForm.textView(name: "oneword-speech")

    var okButton = MQForm.button(name: "ok", title: "OK")

    var profile: Profile

    init(_ info: Profile) {
        self.profile = info
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        super.loadView()

        self.form.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(form)
        
        buildForm()
        
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

        self.navigationItem.title = "基本情報設定"

        self.view.backgroundColor = UIColor.white

        okButton.bindEvent(.touchUpInside) {
            b in

            

        }
    }


    // プロファイルを設定。
    func setProfile(_ info: Profile) {
        self.profile = info
    }
    
    func buildForm () {
        let section = Section(name: "section", view: UIView.newAutoLayout())
        form +++ section.layout {
            s in
            s.fillHolizon().upper()
        }
        
        // name
        var row = Row.LeftAligned().layout{
            r in
            r.fillHolizon().height(40)
        }
        
        row +++ MQForm.label(name: "namelabel", title: "名前").height(38).width(70)
        nameLabel.label.text = "黄　永紅"
        row +++ nameLabel.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }
        
        section <<< row
        
        section <<< HL(.gray, 0.4)
        
        // ID
        row = Row.LeftAligned().layout{
            r in
            r.fillHolizon().height(40)
        }
        
        row +++ MQForm.label(name: "mittyId", title: "MittyID").height(38).width(70)
        row +++ idlabel.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }

        idlabel.label.text = "0000014"
        
        section <<< row
        
        section <<< HL(.gray, 0.4)
        
        // Gendle
        row = Row.LeftAligned().layout{
            r in
            r.fillHolizon().height(40)
        }
        
        row +++ MQForm.label(name: "gendre", title: "性別").height(38).width(70)
        let gendle = Row.Intervaled().layout{
            r in
            r.rightMost().height(40)
        }
        row +++ gendle
        gendle.spacing = 5
        gendle +++ setSelection(maleLabel)
        gendle +++ setSelection(femaleLabel)
        femaleLabel.label.backgroundColor = MittyColor.pink

        section <<< row
        
        seperator(section: section, caption: "年齢層")
        
        row = Row.Intervaled().layout{
            r in
            r.fillHolizon().height(40)
        }

        row.spacing = 5
        
        row +++ setSelection(underage)
        
        row +++ setSelection(yuang)
        
        row +++ setSelection(middleage)
        middleage.label.backgroundColor = MittyColor.healthyGreen
        
        row +++ setSelection(oldage)
        
        section <<< row
        
        seperator(section: section, caption: "One word speech")
        row = Row.Intervaled().layout{
            r in
            r.fillHolizon().height(80)
        }
        
        row +++ speech.layout {
            s in
            s.fillParent(withInset: 10)
        }

        section <<< row
        
        section <<< HL(.gray, 0.4)
        
        row = Row.Intervaled().layout{
            r in
            r.fillHolizon().height(50)
        }
        row.spacing = 80
        
        row +++ okButton
        
        section <<< row
        
    }

}
