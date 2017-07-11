//
//  PriceInfoPicker.swift
//  mitty
//
//  Created by gridscale on 2017/05/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit


protocol PricePickerDelegate : class {
    func pickedPrice(_ pricker : PricePicker)
    func clearPickedPriceInfo()
}

class PricePicker: MittyViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var delegate : PricePickerDelegate? = nil
    
    let form = MQForm.newAutoLayout()
    
    var priceName1 = MQForm.text(name: "name1", placeHolder: "価格名称１")
    var price1 = MQForm.text(name: "price1", placeHolder: "価格を入力")
    var currency = MQForm.text(name: "currency", placeHolder: "単位")
    var currencyPicker: UIPickerView = UIPickerView()
    
    var priceName2 = MQForm.text(name: "name2", placeHolder: "価格名称2")
    var price2 = MQForm.text(name: "price2", placeHolder: "価格を入力")
    
    var priceInfo = MQForm.textView(name: "priceInfo")
    
    var done = MQForm.button(name: "pick", title: "done")
    var clear = MQForm.button(name: "clear", title: "clear")
    
    var list = ["🇯🇵 日本円 ¥","🇰🇷 韓国ワン","🇺🇸 アメリカドル $", "🇨🇳 中国元", "   ユーロ €"]
    var units = ["円","ワン","ドル", "元", "ユーロ"]
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        
        super.autoCloseKeyboard()
        
        self.view.addSubview(form)
        self.view.backgroundColor = .white
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currency.textField.inputView = currencyPicker
        
        
        buildForm()
        view.setNeedsUpdateConstraints()
        
        super.viewDidLoad()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        form.autoPinEdgesToSuperviewEdges()
        form.configLayout()
        
    }
    
    func buildForm () {
        
        form +++ priceName1.layout {
            c in
            c.textField.autoPin(toTopLayoutGuideOf: self, withInset: 10)
            c.leftMost(withInset: 10).height(40).width(100)
        }
        
        form +++ price1.layout {
            c in
            let refer = self.priceName1
            c.topAlign(with: refer).bottomAlign(with: refer).righter(than: refer, withOffset: 10).width(80)
        }
        
        
        form +++ priceName2.layout {
            c in
            let refer = self.price1
            c.putUnder(of: refer, withOffset: 10).leftMost(withInset: 10).height(40).width(100)
        }
        
        form +++ price2.layout {
            c in
            let refer = self.priceName2
            c.topAlign(with: refer).bottomAlign(with: refer).righter(than: refer, withOffset: 10).width(80)
        }

        let unitLabel = MQForm.label(name: "Unit", title: "単位").layout {
            c in
            let refer = self.priceName2
            c.putUnder(of: refer).height(40).width(80).leftMost(withInset: 10)
        }
        
        form +++ unitLabel
        
        form +++ currency.layout {
            c in
            let refer = unitLabel
            c.textField.attributedPlaceholder = NSAttributedString(string:"通貨を選択", attributes: [NSForegroundColorAttributeName: MittyColor.healthyGreen])

            c.topAlign(with: refer).bottomAlign(with: refer).righter(than: refer, withOffset: 10).width(100)
        }
        
        form +++ priceInfo.layout {
            c in
            let refer = unitLabel
            c.putUnder(of: refer, withOffset: 10).fillHolizon(10).height(150)
        }
        
        let row = Row.Intervaled().layout {
            r in
            r.putUnder(of: self.priceInfo, withOffset: 10).height(40).fillHolizon(10)
        }
        row.spacing = 30
        
        form +++ row
        row +++ done.layout{
            d in
            d.height(30)
        }
        row +++ clear.layout{
            c in
            c.height(30)
        }
        
        done.bindEvent(.touchUpInside) {
            b in
            self.delegate?.pickedPrice(self)
            self.navigationController?.popViewController(animated: false)
        }
        
        clear.bindEvent(.touchUpInside) {
            b in
            self.delegate?.clearPickedPriceInfo()
            self.navigationController?.popViewController(animated: false)
        }
        
    }
    
    //Picerviewの列の数は2とする
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ namePickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    //表示する文字列を指定する
    //PickerViewに表示する配列の要素数を設定する
    func pickerView(_ namePickerview: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return list[row]
    }
    
    //ラベル表示
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            currency.textField.text = units[row]
    }
    
    func getPrice1() -> String {
        return priceName1.textField.text! + " " + price1.textField.text! + currency.textField.text!
    }
    
    func getPrice2() -> String {
        return priceName2.textField.text! + " " + price2.textField.text! + currency.textField.text!
    }
}
