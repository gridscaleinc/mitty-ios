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

    let gendle : SelectButton = {
        let s = SelectButton(name: "gendle", view: UIView.newAutoLayout())
        s.selectedBackgroundColor = MittyColor.pink
        s.spacing = 10
        s.addOption(code: "male", label: "男性")
        s.addOption(code: "female", label: "女性")

        return s
    } ()

    let age : SelectButton = {
        let s = SelectButton(name: "age", view: UIView.newAutoLayout())
        
        s.selectedBackgroundColor = MittyColor.pink
        s.spacing = 10
        
        s.addOption(code: "underage", label: "未成年")
        s.addOption(code: "female", label: "青年")
        s.addOption(code: "male", label: "中年")
        s.addOption(code: "female", label: "老年")
        s.setMultiSelect(true)

        
        return s
    } ()
    
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
            r.fillHolizon().height(45)
        }
        
        row +++ MQForm.label(name: "gendre", title: "性別").height(40).width(70)
        row +++ gendle.layout {
            c in
            c.fillParent()
        }
    
        section <<< row
        
        seperator(section: section, caption: "年齢層")
        
        row = Row.LeftAligned().layout{
            r in
            r.fillHolizon().height(45)
        }

        row +++ age.layout {
            c in
            c.fillParent()
        }
                
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
