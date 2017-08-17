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
        let options = [
            ("1", "お洒落"),
            ("2", "容姿端麗"),
            ("3", "ぽちゃり"),
            ("4", "細い"),
        ]
        let btns = SelectButton(name: "appearance", view: UIView.newAutoLayout())
        btns.selectedBackgroundColor = UIColor.orange
        btns.spacing = 5
        for (c, opt) in options {
            btns.addOption(code: c, label: opt)
        }
        return btns
    } ()


    let ocupations: SelectButton = {
        let options = [
            ("001", "IT"),
            ("002", "観光"),
            ("003", "飲食"),
            ("004", "金融"),
            ("005", "メディア"),
            ("006", "通信"),
            ("007", "交通"),
            ("008", "航空"),
            ("009", "海運"),
            ("010", "農業"),
            ("011", "製造"),
            ("012", "建設"),
        ]
        let btns = SelectButton(name: "industry", view: UIView.newAutoLayout())
        btns.selectedBackgroundColor = MittyColor.healthyGreen
        btns.spacing = 5
        btns.setMax(selectable: 3)
        for (c, opt) in options {
            btns.addOption(code: c, label: opt)
        }
        return btns
    } ()

    let hobbys: SelectButton = {
        let options = [
            ("001", "釣り"),
            ("002", "ゲーム"),
            ("003", "旅行"),
            ("004", "日曜大工"),
            ("005", "読書"),
            ("006", "音楽"),
            ("007", "ガーデニング"),
            ("008", "運動"),
        ]
        let btns = SelectButton(name: "hobby", view: UIView.newAutoLayout())
        btns.selectedBackgroundColor = MittyColor.healthyGreen
        btns.spacing = 5
        btns.setMax(selectable: 5)
        for (c, opt) in options {
            btns.addOption(code: c, label: opt)
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
        hobbys.addObserver(handler: { o in
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
        hobbys.selected(code: profile.hobbyTag1)
        hobbys.selected(code: profile.hobbyTag2)
        hobbys.selected(code: profile.hobbyTag3)
        hobbys.selected(code: profile.hobbyTag4)
        hobbys.selected(code: profile.hobbyTag5)
        row +++ hobbys.layout {
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
        }
        if codes.count > 1 {
            profile.occupationTag2 = codes[1]
        }
        if codes.count > 2 {
            profile.occupationTag3 = codes[2]
        }
        
        let codes1 = hobbys.selectedValues
        if codes1.count > 0 {
            profile.hobbyTag1 = codes1[0]
        }
        
        if codes1.count > 1 {
            profile.hobbyTag2 = codes1[1]
        }
        
        if codes1.count > 2 {
            profile.hobbyTag3 = codes1[2]
        }
        
        if codes1.count > 3 {
            profile.hobbyTag4 = codes1[3]
        }
        
        if codes1.count > 4 {
            profile.hobbyTag5 = codes1[4]
        }
        
        ProfileService.instance.saveProfile(profile, onComplete: {
        }, onError: {
            err in self.showError(err)
        })
        
        profile.notify()
    }
}
