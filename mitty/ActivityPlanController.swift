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

class ActivityPlanViewController : MittyViewController, IslandPickerDelegate {
    
    var activityInfo : ActivityInfo
    var activityTitle = "活動"
    var type = "Unkown"
    
    var form = EventInputForm()
    var islandInfo : IslandInfo? = nil
    
    var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        return dateFormatter
    } ()
    
    init(_ info: ActivityInfo) {
        activityInfo = info
        super.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        let startDateText = form.startDate.textField
        let picker1 = UIDatePicker()
        startDateText.inputView = picker1
        setFromDateTime(picker1)
        picker1.addTarget(self, action: #selector(setFromDateTime(_:)), for: .valueChanged)
        
        
        let endDateText = form.startDate.textField
        let picker2 = UIDatePicker()
        endDateText.inputView = picker2
        setToDateTime(picker2)
        picker2.addTarget(self, action: #selector(setToDateTime(_:)), for: .valueChanged)
        
        let allDay = form.allDayFlag
        allDay.bindEvent(.valueChanged) { [weak self]
            s in
            if (s as! UISwitch).isOn {
                self?.dateFormatter.timeStyle = .none
            } else {
                self?.dateFormatter.timeStyle = .medium
            }
            self?.setFromDateTime(picker1)
            self?.setToDateTime(picker2)
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
        
        form.quest("[name=location]").bindEvent(for: .editingDidBegin) { [weak self]
            c in
            c.resignFirstResponder()
            let controller = IslandPicker()
            controller.delegate = self
            controller.islandForm.addressControl.textField.text=self?.form.address.label.text
            controller.islandForm.nameText.text=self?.form.location.textField.text
        
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        form.registerButton.bindEvent(.touchUpInside) { [weak self]
            c in
            self?.register()
        }
        
        manageKeyboard()
        LoadingProxy.set(self)
    }
    
    func setFromDateTime(_ picker: UIDatePicker) {
        let textField = form.startDate.textField
        textField.text = dateFormatter.string(from: picker.date)
    }
    
    
    func setToDateTime(_ picker: UIDatePicker) {
        let textField = form.endDate.textField
        textField.text = dateFormatter.string(from: picker.date)
    }
    
    func manageKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(onKeyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func pickedIsland(landInfo: IslandInfo) {
        form.location.textField.text = landInfo.name
        form.address.label.text = landInfo.address
        form.addressRow?.view.isHidden = false
        if landInfo.id == 0 {
            registerNewIsland(landInfo)
        }
        islandInfo = landInfo
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
        
        // type: string,          (M)      -- イベントの種類
        request.setStr(.type, type)
        
        // tag:  string,          (M)      -- イベントについて利用者が入力したデータの分類識別。
        if (form.tagList.textField.text == "") {
            showError("タグを入力してください")
            return
        }
        request.setStr(.tagList, form.tagList.textField.text)
        
        // title: string,         (M)      -- イベントタイトル
        if (form.eventTitle.textField.text == "") {
            showError("タイトルを入力してください")
            return
        }
        request.setStr(.title, form.eventTitle.textField.text)
        
        // action: string,        (M)      -- イベントの行い概要内容
        if (form.action.textView.text == "") {
            showError("行い事の概要を入力してください")
            return
        }
        request.setStr(.action, form.action.textView.text)
        
        // startDate: dateTime,   (M)      -- イベント開始日時
        var dp = form.startDate.textField.inputView as! UIDatePicker
        request.setDate(.startDate, dp.date)
        
        // endDate: dateTime,     (M)      -- イベント終了日時
        dp = form.endDate.textField.inputView as! UIDatePicker
        request.setDate(.endDate, dp.date)
        
        // allDayFlag: bool,      (M)      -- 時刻非表示フラグ。
        request.setStr(.allDayFlag, "true")

        if (islandInfo == nil || islandInfo?.placeMark == nil) {
            showError("住所を入力してください")
            return
        }
        
        // islandId:  int,        (M)      -- 島ID
        request.setInt(.islandId, String(islandInfo!.id))
        
        // priceName1: string,    (O)      -- 価格名称１
        request.setStr(.priceName1, form.price.textField.text)
        
        // TODO
        // price1: Double ,       (O)      -- 価格額１
        request.setDouble(.price1, "100000.0")
        
        // priceName2,            (O)      -- 価格名称2
        request.setStr(.priceName2, "abc")
        
        // price2: Double ,       (O)      -- 価格額２
        request.setDouble(.price2, "10.0")
        
        // currency: string 　　　（O)      -- 通貨　(USD,JPY,などISO通貨３桁表記)
        request.setStr(.currency, "USD")
        
        // priceInfo: string      (O)      -- 価格について一般的な記述
        request.setStr(.priceInfo, form.price.textField.text)
        
        if (form.action.textView.text == "") {
            showError("行い事の概要を入力してください")
            return
        }
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
        request.setStr(.anticipation, "open")
        
        // accessControl: string, (O)      -- イベント情報のアクセス制御：　PUBLIC: 全公開、　PRIVATE: 非公開、 SHARED:関係者のみ
        request.setStr(.accessControl, "public")
        
        // language: string       (M)      -- 言語情報　(Ja_JP, en_US, en_GB) elastic　searchに使用する。
        request.setStr(.language, "Ja_JP")
        
        request.setInt(.relatedActivityId, activityInfo.id)
        if (activityInfo.mainEventId == nil || activityInfo.mainEventId == "0" || activityInfo.mainEventId == "0") {
            request.setStr(.asMainEvent, "true")
        } else {
            request.setStr(.asMainEvent, "false")
        }
        
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
    
    func registerNewIsland(_ landInfo : IslandInfo) {
        let request = NewIslandReq()
        
        //nickname           : string      --(O)  愛称
        request.setStr(.nickname, "")
        
        //name               : string      --(M)  名称
        request.setStr(.name, landInfo.placeMark?.name)
        
        //logoId             : int         --(O)  LogoのContent Id
//        request.setStr(.logoId, "")
        
        //description        : string      --(O)  説明
        request.setStr(.description,"")
        
        //category           : string      --(M)  カテゴリ
        request.setStr(.category,"UKNOWN")
        
        //mobilityType       : string      --(M)  移動性分類
        request.setStr(.mobilityTyep,"NONE")
        
        //realityType        : string      --(M)  実在性分類
        request.setStr(.realityType,"REAL")
        
        //ownershipType      : string      --(M)  所有者分類
        request.setStr(.ownershipTYpe,"PUBLIC")
        
        //ownerName          : string      --(O)  所有者名
        request.setStr(.ownerName,"UNOWNED")
        
        //ownerId            : int         --(O)  所有者のMitty User Id
//        request.setStr(.ownerId,"")
        
        //creatorId          : int         --(O)  作成者のMitty User Id
//        request.setStr(.creatorId,"")
        
        //meetingId          : int         --(O)  会議Id
//        request.setStr(.meetingId,"")
        
        //galleryId          : int         --(O)  ギャラリーID
//        request.setStr(.galleryId,"")
        
        //tel                : string      --(O)  電話番号
        request.setStr(.tel, "")
        
        //fax                : string      --(O)  FAX
        request.setStr(.fax,"")
        
        //mailaddress        : string      --(O)  メールアドレス
        request.setStr(.mailaddress, "")
        
        //webpage            : string      --(O) 　WebページのURL
        request.setStr(.webpage,"")
        
        //likes              : string      --(O)  いいねの数
        request.setStr(.likes, "0")
        
        //countryCode        : string      --(O)  国コード
        request.setStr(.countryCode, landInfo.placeMark?.isoCountryCode)
        
        //countryName        : string      --(O)  国名称
        request.setStr(.countryName, landInfo.placeMark?.country)
        
        //state              : string      --(O)  都道府県
        request.setStr(.state, landInfo.placeMark?.administrativeArea)
        
        //city               : string      --(O)  市、区
        request.setStr(.city, landInfo.placeMark?.locality)
        
        //postcode           : string      --(O)  郵便番号
        request.setStr(.postcode, landInfo.placeMark?.postalCode)
        
        //thoroghfare        : string      --(O)  大通り
        request.setStr(.thoroghfare, landInfo.placeMark?.thoroughfare)
        
        //subthroghfare      : string      --(O)  通り
        request.setStr(.subthorghfare, landInfo.placeMark?.subThoroughfare)
        
        //buildingName       : string      --(O)  建物名称
        request.setStr(.buildingName, "")
        
        //floorNumber        : string      --(O)  フロー番号
        request.setStr(.floorNumber, String(describing: landInfo.placeMark?.location?.floor?.level))
        
        //roomNumber         : string      --(O)  部屋番号
        request.setStr(.roomNumber,"")
        
        //address1           : string      --(O)  住所行１
        // print(landInfo.placeMark?.addressDictionary)
        if let addressLines = landInfo.placeMark?.addressDictionary?["FormattedAddressLines"] as? NSArray {
            //address1-3           : string      --(O)  住所行１-3
            if addressLines.count>0 {
                request.setStr(.address1, addressLines[0] as? String)
            }
            if addressLines.count>1 {
                request.setStr(.address2, addressLines[1] as? String)
            }
            if addressLines.count>2 {
                request.setStr(.address3, addressLines[2] as? String)
            }
        }
        
        //latitude           : double      --(O)  地理位置の緯度
        if let lat = landInfo.placeMark?.location?.coordinate.longitude {
            request.setDouble(.latitude, String(describing: lat))
        }
        
        //longitude          : double      --(O)  地理位置の経度
        if let longi = landInfo.placeMark?.location?.coordinate.longitude {
            request.setDouble(.longitude, String(describing: longi))
        }
        
        print(request.parameters)
        
        let urlString = "http://dev.mitty.co/api/new/island"

        Alamofire.request(urlString, method: .post, parameters: request.parameters).validate(statusCode: 200..<300).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    let islandId = json["islandId"].intValue
                    landInfo.id = islandId
                }
                
//                self?.navigationController?.popToRootViewController(animated: true)
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

}


