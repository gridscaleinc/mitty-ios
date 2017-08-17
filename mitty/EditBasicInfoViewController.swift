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
    var userInfo = UserInfo()
    var profile = Profile()
    
    var form = MQForm.newAutoLayout()


    let idlabel = MQForm.label(name: "id", title: "")
    let nameLabel = MQForm.label(name: "name", title: "")

    let gendle : SelectButton = {
        let s = SelectButton(name: "gendle", view: UIView.newAutoLayout())
        s.selectedBackgroundColor = MittyColor.pink
        s.spacing = 5
        s.addOption(code: "Male", label: "男性")
        s.addOption(code: "Female", label: "女性")
        s.addOption(code: "Secret", label: "秘密")
        return s
    } ()

    let age : SelectButton = {
        let s = SelectButton(name: "age", view: UIView.newAutoLayout())
        
        s.selectedBackgroundColor = MittyColor.pink
        s.spacing = 5
        
        s.addOption(code: "Underage", label: "未成年")
        s.addOption(code: "Yuang", label: "青年")
        s.addOption(code: "Middle", label: "中年")
        s.addOption(code: "Old", label: "老年")

        
        return s
    } ()
    
    let speech = MQForm.textView(name: "oneword-speech")

    var okButton = MQForm.button(name: "ok", title: "OK")

    init(_ userInfo: UserInfo, _ info: Profile) {
        self.userInfo = userInfo
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


    /// <#Description#>
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
            self.saveProfile()
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
        nameLabel.label.text = userInfo.name
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
        idlabel.label.text = String(format: "%010d", userInfo.id)
        row +++ idlabel.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }
        
        section <<< row
        
        section <<< HL(.gray, 0.4)
        
        // Gendle
        row = Row.LeftAligned().layout{
            r in
            r.fillHolizon().height(45)
        }
        
        row +++ MQForm.label(name: "gendre", title: "性別").height(30).width(70)
        row +++ gendle.layout {
            c in
            c.fillParent()
        }
        gendle.selected(code: profile.gender)
    
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
        age.selected(code: profile.ageGroup)
        
        section <<< row
        
        seperator(section: section, caption: "One word speech")
        row = Row.Intervaled().layout{
            r in
            r.fillHolizon().height(80)
        }
        speech.textView.text = profile.oneWordSpeech
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
    
    func saveProfile () {
        // 性別は初回のみ設定できない。
        let gendleSelection = gendle.selectedValues
        // 未選択
        if gendleSelection.count == 0 {
            profile.gender = "Secret"
        } else {
            profile.gender = gendleSelection.first!
        }
        
        let ageSelect = age.selectedValues
        if ageSelect.count == 0 {
            profile.ageGroup = "Secret"
        } else {
            profile.ageGroup = ageSelect.first!
        }
        
        profile.oneWordSpeech = speech.textView.text

        ProfileService.instance.saveProfile(profile, onComplete:{
            self.navigationController?.popViewController(animated: true)
        }, onError: { err in
            self.showError(err)
        })
        
        profile.notify()
    }

}
