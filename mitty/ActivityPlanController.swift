//
//  ActivityPlanViewController.swift
//  mitty
//
//  Created by gridscale on 2017/01/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ActivityPlanViewController : UIViewController, IslandPickerDelegate {
    
    var activityTitle = "活動"
    var type = "Unkown"
    
    var form = EventInputForm()
    
    override func loadView() {
        
        // navigation bar の初期化をする
        
        // activityList を作成する
        
        // 線を引いて、対象年のフィルタボタンを設定する
        
        super.loadView()
        
        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(form)

        
        form.loadForm()
        
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
        
    }
    
    
    override func updateViewConstraints() {
        form.autoPin(toTopLayoutGuideOf: self, withInset:0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        form.configLayout()
        super.updateViewConstraints()

    }
    
    override func viewDidLoad() {
        
        self.navigationItem.title = activityTitle
        
        self.view.backgroundColor = UIColor.white
        form.quest("[name=fromDateTime]").forEach() { (c) in
            let textField = c.view as! UITextField
            let picker = UIDatePicker()
            textField.inputView = picker
            picker.addTarget(self, action: #selector(setFromDateTime(_:)), for: .valueChanged)
        }
        
        form.quest("[name=toDateTime]").forEach() { (c) in
            
            let textField = c.view as! UITextField
            let picker = UIDatePicker()
            textField.inputView = picker
            picker.addTarget(self, action: #selector(setToDateTime(_:)), for: .valueChanged)
        
        }
        
        form.quest("[name=contact-Tel]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.keyboardType = .numberPad
        }
        
        form.quest("[name=contact-mail]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.keyboardType = .emailAddress
        }
        
        form.quest("[name=infoUrl]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.keyboardType = .URL
        }
        
        form.quest("[name=location]").bindEvent(for: .editingDidBegin) {
            c in
            c.resignFirstResponder()
            let controller = IslandPicker()
            controller.delegate = self
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        form.registerButton.bindEvent(.touchUpInside) { [weak self]
            c in
            self?.register()
        }
        
        manageKeyboard()
        LoadingProxy.set(self)
    }
    
    func setFromDateTime(_ picker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        form.quest("[name=fromDateTime]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.text = dateFormatter.string(from: picker.date)
        }
    }
    
    
    func setToDateTime(_ picker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        form.quest("[name=toDateTime]").forEach() { (c) in
            let textField = c.view as! UITextField
            textField.text = dateFormatter.string(from: picker.date)
        }
    }
    
    func manageKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(onKeyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func pickedIsland(landInfo: IslandInfo) {
        form.location.textField.text = landInfo.name
        form.address.label.text = landInfo.address
    }
    
    var scrollConstraints : NSLayoutConstraint?
    
    @objc
    func onKeyboardShow(_ notification: NSNotification) {
        //郵便入れみたいなもの
        let userInfo = notification.userInfo!
        //キーボードの大きさを取得
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardHeight = keyboardRect.size.height
        
        let scroll = form.quest("[name=Input-Container]").control()
        scrollConstraints?.autoRemove()
        scrollConstraints = scroll?.view.autoPinEdge(toSuperviewEdge: .bottom, withInset: keyboardHeight)
        self.view.setNeedsUpdateConstraints()

    }
    
    
    @objc
    func onKeyboardHide(_ notification: NSNotification) {
        scrollConstraints?.autoRemove()
        scrollConstraints = nil
        
        self.view.setNeedsUpdateConstraints()
    }
    
    func register() {
        let request = NewEventReq()
        
        var dp = form.startDate.textField.inputView as! UIDatePicker

        // type: string,          (M)      -- イベントの種類
        request.setStr(.type, type)
        
        // tag:  string,          (M)      -- イベントについて利用者が入力したデータの分類識別。
        request.setStr(.tagList, form.tagList.textField.text)
        
        // title: string,         (M)      -- イベントタイトル
        request.setStr(.title, form.eventTitle.textField.text)
        
        // action: string,        (M)      -- イベントの行い概要内容
        request.setStr(.action, form.action.textView.text)
        
        // startDate: dateTime,   (M)      -- イベント開始日時
        request.setDate(.startDate, dp.date)
        
        // endDate: dateTime,     (M)      -- イベント終了日時
        dp = form.endDate.textField.inputView as! UIDatePicker
        request.setDate(.endDate, dp.date)
        
        // allDayFlag: bool,      (M)      -- 時刻非表示フラグ。
        request.setStr(.allDayFlag, "true")

        // islandId:  int,        (M)      -- 島ID
        request.setInt(.islandId, "1")
        
        // priceName1: string,    (O)      -- 価格名称１
        request.setStr(.priceName1, form.price.textField.text)
        
        // price1: Double ,       (O)      -- 価格額１
        request.setDouble(.price1, "100000.0")
        
        // priceName2,            (O)      -- 価格名称2
        request.setStr(.priceName2, "abc")
        
        // price2: Double ,       (O)      -- 価格額２
        request.setDouble(.price2, "10.0")
        
        // currency: string 　　　（O)      -- 通貨　(USD,JPY,などISO通貨３桁表記)
        request.setStr(.currency, "USD")
        
        // priceInfo: string      (O)      -- 価格について一般的な記述
        request.setStr(.priceInfo, "abc")
        
        // description: string    (M)      -- イベントについて詳細な説明記述
        request.setStr(.description, form.detailDescription.textView.text)
        
        // contactTel: string,    (O)      -- 連絡電話番号
        request.setStr(.contactTel, form.contactTel.textField.text)
        
        // contactFax: string,    (O)      -- 連絡FAX
        request.setStr(.contactFax, "-")
        
        // contactMail: string,   (O)      -- 連絡メール
        request.setStr(.contactMail, form.contactEmail.textField.text)
        
        // officialUrl: URL,      (O)      -- イベント公式ページURL
        request.setStr(.officialUrl, form.officialUrl.textField.text)
        
        // organizer: string,     (O)      -- 主催者の個人や団体の名称
        request.setStr(.organizer, form.organizer.textField.text)
        
        // sourceName: string,    (M)      -- 情報源の名称
        request.setStr(.sourceName, form.infoSource.textView.text)
        
        // sourceUrl: URL,        (O)      -- 情報源のWebPageのURL
        request.setStr(.sourceUrl, form.infoUrl.textField.text)
        
        // anticipation: string,  (O)      -- イベント参加方式、 OPEN：　自由参加、　INVITATION:招待制、PRIVATE:個人用、他の人は参加不可。
        request.setStr(.anticipation, "PRIVATE")
        
        // accessControl: string, (O)      -- イベント情報のアクセス制御：　PUBLIC: 全公開、　PRIVATE: 非公開、 SHARED:関係者のみ
        request.setStr(.accessControl, "PRIVATE")
        
        // language: string       (M)      -- 言語情報　(Ja_JP, en_US, en_GB) elastic　searchに使用する。
        request.setStr(.language, "Ja_JP")
        
        let urlString = "http://dev.mitty.co/api/new/event"
        
        print(request.parameters)
        Alamofire.request(urlString, method: .post, parameters: request.parameters).validate(statusCode: 200..<300).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                self?.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                print(response.debugDescription)
                print(response.data ?? "No Data")
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    self?.showError("error occored")

                } catch {
                    print("Serialize Error")
                }
                
                print(response.description)

                LoadingProxy.off()
                print(error)
            }
        }
    }
    
    var error : Control?
    var lock = NSLock()
    
    func showError(_ errorMsg: String ) {
        lock.lock()
        defer {lock.unlock()}
        
        if error != nil {
            return
        }
        let message = UILabel.newAutoLayout()
        message.backgroundColor = .yellow
        message.text = errorMsg
        message.textAlignment = .center
        self.view.addSubview(message)
        
        error = Control(name: "error", view: message).layout{
            e in
            e.upper(withInset: 80).fillHolizon().height(40)
        }
        error?.configLayout()
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(clearMessage), userInfo: nil, repeats: true)
    }
    
    func clearMessage() {
        lock.lock()
        defer {lock.unlock()}
        
        if (error != nil) {
            error?.view.removeFromSuperview()
            error = nil
        }
    }
}


