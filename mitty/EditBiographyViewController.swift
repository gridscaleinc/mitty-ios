//
//  EditBiographyViewController.swift
//  mitty
//
//  Created by gridscale on 2017/08/13.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class EditBiographyViewController: MittyViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var userInfo = UserInfo()
    var profile = Profile()
    
    var form = MQForm.newAutoLayout()

    let constellations = ["獅子座", "天平座", "蟹座", "牡羊座"
        , "牡牛座", "乙女座", "蠍座", "射手座",
        "山羊座", "水瓶座", "魚座", "双子座"]

    let appearance: SelectButton = {

        let s = SelectButton(name: "appearance", view: UIView.newAutoLayout())
        s.selectedBackgroundColor = UIColor.orange
        s.spacing = 5
        for (key, code) in appearances() {
            s.addOption(code: key, label: code.value)
        }
        return s
        
    } ()


    let ocupations: SelectButton = {
        
        let btns = SelectButton(name: "Occupations", view: UIView.newAutoLayout())
        btns.selectedBackgroundColor = MittyColor.healthyGreen
        btns.spacing = 5
        btns.setMax(selectable: 3)
        for (key, code) in occupations() {
            btns.addOption(code: key, label: code.value)
        }
        return btns
    } ()

    let hobbyButtons: SelectButton = {

        let btns = SelectButton(name: "hobby", view: UIView.newAutoLayout())
        btns.selectedBackgroundColor = MittyColor.healthyGreen
        btns.spacing = 5
        btns.setMax(selectable: 5)
        for (key, code) in hobbys() {
            btns.addOption(code: key, label: code.value)
        }
        return btns
    } ()

    var constellationPicker: UIPickerView = UIPickerView()

    var okButton = MQForm.button(name: "ok", title: "OK")

    var constellation = MQForm.text(name: "constellation", placeHolder: "選択してください")

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

        self.navigationItem.title = "Biography"

        self.view.backgroundColor = UIColor.white

        constellationPicker.dataSource = self
        constellationPicker.delegate = self
        constellation.textField.inputView = constellationPicker

        okButton.bindEvent(.touchUpInside) {
            b in
            self.saveProfile()
            self.navigationController?.popViewController(animated: true)
        }
    }


    func buildForm () {
        let section = Section(name: "section", view: UIView.newAutoLayout())
        form +++ section.layout {
            s in
            s.fillHolizon().upper()
        }

        seperator(section: section, caption: "")

        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }

        row +++ MQForm.label(name: "cons", title: "星座").layout {
            r in
            r.width(70)
        }
        constellation.textField.text = profile.constellation
        row +++ constellation.layout {
            c in
            c.rightMost().height(30)
            c.textField.textColor = UIColor.orange
        }

        section <<< row

        seperator(section: section, caption: "外見")
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(50)
        }

        appearance.selected(code: profile.appearanceTag)
        row +++ appearance.layout {
            b in
            b.fillParent()
        }

        section <<< row

        let sep = seperator(section: section, caption: "職業")
        // handler
        ocupations.addObserver(handler: { o in
            if let l = sep["caption"] {
                let count = (o as! SelectButton).selectedValues.count
                if (count == 3) {
                    l.label.text = "職業(３つまで選択可)"
                } else {
                    l.label.text = (count > 0) ? "職業(\(count))" : "職業"
                }
            }
        })
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(120)
        }
        ocupations.selected(code: profile.occupationTag1)
        ocupations.selected(code: profile.occupationTag2)
        ocupations.selected(code: profile.occupationTag3)
        
        row +++ ocupations.layout {
            o in
            o.fillParent()
        }
        
        section <<< row

        let sep2 = seperator(section: section, caption: "趣味")
        // handler
        hobbyButtons.addObserver(handler: { o in
            if let l = sep2["caption"] {
                let count = (o as! SelectButton).selectedValues.count
                if (count == 5) {
                    l.label.text = "趣味(5つまで選択可)"
                } else {
                    l.label.text = (count > 0) ? "趣味(\(count))" : "趣味"
                }
            }
        })
        
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(75)
        }
        hobbyButtons.selected(code: profile.hobbyTag1)
        hobbyButtons.selected(code: profile.hobbyTag2)
        hobbyButtons.selected(code: profile.hobbyTag3)
        hobbyButtons.selected(code: profile.hobbyTag4)
        hobbyButtons.selected(code: profile.hobbyTag5)
        row +++ hobbyButtons.layout {
            o in
            o.fillParent()
        }

        section <<< row

        section <<< HL(.gray, 0.4)

        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(50)
        }
        row.spacing = 80

        row +++ okButton

        section <<< row

    }

    //Picerviewの列の数は2とする
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ namePickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return constellations.count
    }

    //表示する文字列を指定する
    //PickerViewに表示する配列の要素数を設定する
    func pickerView(_ namePickerview: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return constellations[row]
    }

    //ラベル表示
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        constellation.textField.text = constellations[row]
    }
    
    func saveProfile () {
        
        profile.constellation = constellation.textField.text!
        
        if appearance.selectedValues.count > 0 {
            profile.appearanceTag = appearance.selectedValues.first!
        } else {
            profile.appearanceTag = ""
        }
        
        let codes = ocupations.selectedValues
        if codes.count > 0 {
            profile.occupationTag1 = codes.first!
        } else {
            profile.occupationTag1 = ""
        }
        if codes.count > 1 {
            profile.occupationTag2 = codes[1]
        } else {
            profile.occupationTag2 = ""
        }
        if codes.count > 2 {
            profile.occupationTag3 = codes[2]
        } else {
            profile.occupationTag3 = ""
        }
        
        let codes1 = hobbyButtons.selectedValues
        if codes1.count > 0 {
            profile.hobbyTag1 = codes1[0]
        } else {
            profile.hobbyTag1 = ""
        }
        
        if codes1.count > 1 {
            profile.hobbyTag2 = codes1[1]
        } else {
            profile.hobbyTag2 = ""
        }
        
        if codes1.count > 2 {
            profile.hobbyTag3 = codes1[2]
        } else {
            profile.hobbyTag3 = ""
        }
        
        if codes1.count > 3 {
            profile.hobbyTag4 = codes1[3]
        } else {
            profile.hobbyTag4 = ""
        }
        
        if codes1.count > 4 {
            profile.hobbyTag5 = codes1[4]
        } else {
            profile.hobbyTag5 = ""
        }
        
        ProfileService.instance.saveProfile(profile, onComplete: {
        }, onError: {
            err in self.showError(err)
        })
        
        profile.notify()
    }
}
