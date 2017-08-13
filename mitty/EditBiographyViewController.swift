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

    var form = MQForm.newAutoLayout()

    let constellations = ["獅子座", "天平座", "蟹座", "牡羊座"
        , "牡牛座", "乙女座", "蠍座", "射手座",
        "山羊座", "水瓶座", "魚座", "双子座"]

    var constellationPicker: UIPickerView = UIPickerView()

    var okButton = MQForm.button(name: "ok", title: "OK")

    var constellation = MQForm.text(name: "constellation", placeHolder: "選択してください")
    
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

        self.navigationItem.title = "Biography"

        self.view.backgroundColor = UIColor.white

        constellationPicker.dataSource = self
        constellationPicker.delegate = self
        constellation.textField.inputView = constellationPicker
        
        okButton.bindEvent(.touchUpInside) {
            b in



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
        
        row +++ MQForm.label(name: "cons", title: "星座").layout{
            r in
            r.width(70)
        }
        
        row +++ constellation.layout {
            c in
            c.rightMost().height(30)
        }

        section <<< row
        
        seperator(section: section, caption: "外見")
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(40)
        }
        row.spacing = 5
        
        row +++ createSelection("お洒落")
        row +++ createSelection("容姿端麗").layout{
            c in
            c.view.backgroundColor = MittyColor.pink
        }

        row +++ createSelection("ぽちゃり")
        row +++ createSelection("細い")
        section <<< row
        
        seperator(section: section, caption: "職業")
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(40)
        }
        row.spacing = 5
        
        row +++ createSelection("管理").layout{
            c in
            c.view.backgroundColor = MittyColor.baseYellow
        }
        
        row +++ createSelection("専門")
        row +++ createSelection("事務")
        row +++ createSelection("販売")
        section <<< row
        section <<< HL(UIColor.gray, 0.5)
        
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(40)
        }
        row.spacing = 5
        
        row +++ createSelection("サービス")
        row +++ createSelection("保安")
        row +++ createSelection("農林")
        row +++ createSelection("輸送")
        section <<< row
        
        seperator(section: section, caption: "趣味")
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(40)
        }
        row.spacing = 5
        
        row +++ createSelection("釣り").layout{
            c in
            c.view.backgroundColor = MittyColor.healthyGreen
        }
        
        row +++ createSelection("ゲーム")
        row +++ createSelection("旅行")
        row +++ createSelection("日曜大工")
        section <<< row
        section <<< HL(UIColor.gray, 0.5)
        
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(40)
        }
        row.spacing = 5
        
        row +++ createSelection("読書")
        row +++ createSelection("音楽")
        row +++ createSelection("ガーデニング")
        row +++ createSelection("運動")
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


    func createSelection(_ s: String) -> Control {
        let c = MQForm.label(name: "-", title: s)
        return setSelection(c)
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
    func pickerView(_ namePickerview: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return constellations[row]
    }
    
    //ラベル表示
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        constellation.textField.text = constellations[row]
    }
}
