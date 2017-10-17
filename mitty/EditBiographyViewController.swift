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

    let constellationCode: [(key: String, value: Code)] = {
        return constellations().sorted() {
            c1, c2 in
            return c1.key < c2.key
        }
    }()

    let appearance: SelectButton = {

        let s = SelectButton(name: "appearance", view: UIView.newAutoLayout())
        s.selectedBackgroundColor = MittyColor.sunshineRed
        s.spacing = 5
        for (key, code) in appearances() {
            s.addOption(code: key, label: code.value)
        }
        return s
        
    } ()


    let ocupations: SelectButton = {
        
        let btns = SelectButton(name: "Occupations", view: UIView.newAutoLayout())
        btns.selectedBackgroundColor = MittyColor.healthyGreen
        btns.spacing = 8
        btns.setMax(selectable: 3)
        for (key, code) in occupations() {
            btns.addOption(code: key, label: code.value)
        }
        return btns
    } ()

    let hobbyButtons: SelectButton = {

        let btns = SelectButton(name: "hobby", view: UIView.newAutoLayout())
        btns.selectedBackgroundColor = MittyColor.healthyGreen
        btns.spacing = 8
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
        
        form.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)
        let anchor = MQForm.label(name: "dummy", title: "").layout {
            a in
            a.height(0).leftMost().rightMost()
        }
        form +++ anchor
        
        // スクロールViewを作る
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 900)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        let scrollContainer = Container(name: "Detail-form", view: scroll).layout() { (container) in
            container.fillParent()
        }
        
        form +++ scrollContainer
        
        let section = Section(name: "section", view: UIView.newAutoLayout())
        section.layout {
            s in
            s.fillHolizon().upper()
        }
        
        scrollContainer +++ section
        
        seperator(section: section, caption: "")

        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }

        row +++ MQForm.label(name: "cons", title: "星座").layout {
            r in
            r.width(70).verticalCenter()
        }
        
        self.constellation.textField.text = CONSTELLATION(of: profile.constellation)?.value
        
        row +++ constellation.layout {
            c in
            c.rightMost().height(30).verticalCenter()
            c.textField.textColor = MittyColor.sunshineRed
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
            r.fillHolizon().height(130)
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
            r.fillHolizon().height(120)
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
        
        let bottom = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }
        
        section <<< bottom

        section.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }

    }

    //Picerviewの列の数は2とする
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ namePickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return constellationCode.count
    }

    //表示する文字列を指定する
    //PickerViewに表示する配列の要素数を設定する
    func pickerView(_ namePickerview: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return constellationCode[row].value.value
    }

    //ラベル表示
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        constellation.textField.text = constellationCode[row].value.value
    }
    
    func saveProfile () {
        
        profile.constellation = constellationCode[constellationPicker.selectedRow(inComponent: 0)].key
        
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
