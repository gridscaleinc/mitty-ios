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
import MapKit
import AlamofireImage

//
class ActivityPlanViewController: MittyViewController, IslandPickerDelegate, PricePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WebPickerDelegate, ContentPickerDelegate {

    var activityInfo: ActivityInfo
    var activityTitle = "活動"
    var type = "Unkown"
    var imagePicked = false
    var form = EventInputForm()
    var pickedIsland: IslandPick? = nil
    var logoContent: Content? = nil
    let pricePicker = PricePicker()

    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        return dateFormatter
    } ()

    init(_ info: ActivityInfo) {
        activityInfo = info
        super.init(nibName: nil, bundle: nil)
    }

    //
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //
    //
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

    var didSetupConstraints = false

    override func updateViewConstraints() {
        if !didSetupConstraints {
            form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
            form.autoPinEdge(toSuperviewEdge: .left)
            form.autoPinEdge(toSuperviewEdge: .right)
            form.autoPinEdge(toSuperviewEdge: .bottom)

            form.configLayout()
            didSetupConstraints = true
        }


        form.updateLayout()


        super.updateViewConstraints()

    }

    override func viewDidLoad() {

        super.autoCloseKeyboard()

        self.navigationItem.title = activityTitle

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)


        pricePicker.delegate = self

        let startDateText = form.startDate.textField
        let picker1 = UIDatePicker()
        startDateText.inputView = picker1
        setFromDateTime(picker1)
        picker1.addTarget(self, action: #selector(setFromDateTime(_:)), for: .valueChanged)


        let endDateText = form.endDate.textField
        let picker2 = UIDatePicker()
        endDateText.inputView = picker2
        setToDateTime(picker2)
        picker2.addTarget(self, action: #selector(setToDateTime(_:)), for: .valueChanged)

        let allDay = form.allDayFlag
        allDay.bindEvent(.valueChanged) { [weak self]
            s in
            if (s as! UISwitch).isOn {
                self?.dateFormatter.timeStyle = .none
                picker1.datePickerMode = .date
                picker2.datePickerMode = .date
            } else {
                self?.dateFormatter.timeStyle = .medium
                picker1.datePickerMode = .dateAndTime
                picker2.datePickerMode = .dateAndTime
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
            controller.islandForm.addressControl.textField.text = self?.form.address.label.text
            controller.islandForm.nameText.text = self?.form.location.textField.text

            self?.navigationController?.pushViewController(controller, animated: true)
        }

        form.quest("[name=priceInput]").bindEvent(for: .touchUpInside) { [weak self]
            c in
            c.resignFirstResponder()
            self?.navigationController?.pushViewController((self?.pricePicker)!, animated: true)
        }

        form.quest("[name=addImageLabel]").bindEvent(for: .touchUpInside) {
            label in
            self.pickImage ()
        }

        form.registerButton.bindEvent(.touchUpInside) { [weak self]
            c in
            self?.register()
        }

        form.quest("[name=label-official-page]").bindEvent(for: .touchUpInside) {
            label in
            let wb = WebPicker()

            wb.initUrl = self.form.officialUrl.textField.text ?? ""

            wb.initKey = self.form.eventTitle.textField.text ?? ""

            wb.delegate = self

            self.navigationController?.pushViewController(wb, animated: true)
        }

        form.quest("[name=infoUrl]").bindEvent(for: .editingDidBegin) {
            text in
            text.resignFirstResponder()
            let wb = WebPicker()
            wb.initUrl = self.form.infoUrl.textField.text ?? ""
            wb.initKey = self.form.eventTitle.textField.text ?? ""
            wb.delegate = self
            self.navigationController?.pushViewController(wb, animated: true)
        }


        form.eventTitle.textField.text = activityInfo.title
        form.action.textView.text = activityInfo.memo

        // navi
        form.icon.bindEvent(.touchUpInside) {
            ic in
            let vc = ContentPicker()

            vc.delegate = self

            self.navigationController?.pushViewController(vc, animated: true)
        }

        manageKeyboard()
        LoadingProxy.set(self)
    }

    func webpicker(_ picker: WebPicker?, _ info: PickedInfo) -> Void {
        form.infoUrl.textField.text = info.siteUrl
        form.infoSource.textView.text = info.siteTitle
        if (info.siteImage != nil) {
            form.image.imageView.image = info.siteImage
            imagePicked = true
        }
    }

    func pickImage () {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }

    }


    //MARK: - Delegates
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        NSLog("\(info)")
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        form.image.imageView.image = chosenImage.af_imageScaled(to: CGSize(width: 161.8, height: 161.8))
        self.dismiss(animated: false, completion: nil)
        imagePicked = true
    }

    func setFromDateTime(_ picker: UIDatePicker) {
        let textField = form.startDate.textField
        textField.text = dateFormatter.string(from: picker.date)
    }


    func setToDateTime(_ picker: UIDatePicker) {
        let textField = form.endDate.textField
        textField.text = dateFormatter.string(from: picker.date)
    }

    //
    // 場所選択した際の処理
    //
    func pickedIsland(landInfo: IslandPick) {
        form.location.textField.text = landInfo.name
        form.address.label.text = landInfo.address


        pickedIsland = landInfo

        checkAndRegist(landInfo)

        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }


    func clearPickedIsland() {

    }

    func pickedPrice(_ picker: PricePicker) {
        form.price1.label.text = picker.getPrice1()
        form.price2.label.text = picker.getPrice2()
        form.priceDetail.label.text = picker.priceInfo.textView.text
    }

    func clearPickedPriceInfo() {

    }

    func pickedContent(content: Content) {
        logoContent = content
    }

    func clearPickedContent() {
        logoContent = nil
    }

    var scrollConstraints: NSLayoutConstraint?

    @objc
    override func onKeyboardShow(_ notification: NSNotification) {
        //郵便入れみたいなもの
        let userInfo = notification.userInfo!
        //キーボードの大きさを取得
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        let keyboardHeight = keyboardRect.size.height

        let scroll = form.quest("[name=inputContainer]").control()
        scrollConstraints?.autoRemove()
        scrollConstraints = scroll?.view.autoPinEdge(toSuperviewEdge: .bottom, withInset: keyboardHeight)
        self.view.setNeedsUpdateConstraints()

    }


    @objc
    override func onKeyboardHide(_ notification: NSNotification) {
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

        // logoId: int           (O)LogoID
        if logoContent != nil {
            request.setInt(.logoId, String(logoContent!.id))
        }

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

        if (pickedIsland == nil || pickedIsland?.placeMark == nil) {
            showError("住所を入力してください")
            return
        }

        // islandId:  int,        (M)      -- 島ID
        request.setInt(.islandId, String(pickedIsland!.id))

        // priceName1: string,    (O)      -- 価格名称１
        request.setStr(.priceName1, pricePicker.priceName1.textField.text)

        // TODO
        // price1: Double ,       (O)      -- 価格額１
        let price = pricePicker.price1.textField.text
        if (price != nil && price != "") {
            request.setDouble(.price1, price!)
        }


        // priceName2,            (O)      -- 価格名称2
        request.setStr(.priceName2, pricePicker.priceName2.textField.text)


        // price2: Double ,       (O)      -- 価格額２
        let price2 = pricePicker.price2.textField.text
        if (price2 != nil && price != "") {
            request.setDouble(.price2, price2!)
        }

        // currency: string 　　　（O)      -- 通貨　(USD,JPY,などISO通貨３桁表記)
        request.setStr(.currency, pricePicker.currency.textField.text)

        // priceInfo: string      (O)      -- 価格について一般的な記述
        request.setStr(.priceInfo, pricePicker.priceInfo.textView.text)

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
        request.setStr(.officialUrl, trim(form.officialUrl.textField.text, 200))

        // organizer: string,     (O)      -- 主催者の個人や団体の名称
        request.setStr(.organizer, form.organizer.textField.text)

        // sourceName: string,    (M)      -- 情報源の名称
        request.setStr(.sourceName, form.infoSource.textView.text)

        // sourceUrl: URL,        (O)      -- 情報源のWebPageのURL
        request.setStr(.sourceUrl, trim(form.infoUrl.textField.text, 200))

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

        let urlString = MITTY_SERVICE_BASE_URL + "/new/event"

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()

        print(request.parameters)
        Alamofire.request(urlString, method: .post, parameters: request.parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                if (self?.imagePicked)! {
                    if let jsonObject = response.result.value {
                        let json = JSON(jsonObject)
                        print(json)

                        let eventId = json["eventId"].stringValue
                        self?.registerGallery(eventId)
                    }
                } else {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print(response.debugDescription)
                print(response.data ?? "No Data")
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)

                    self?.showError("error occored" + (json as AnyObject).description)

                } catch {
                    print("Serialize Error")
                }

                print(response.description)

                LoadingProxy.off()
                print(error)
            }
        }
    }

    func trim(_ s: String?, _ size: Int) -> String? {
        if (s == nil) {
            return nil
        }
        let nss = s! as NSString

        if (nss.length > size) {
            return nss.substring(to: size)
        } else {
            return s
        }

    }

    func registerGallery (_ eventId: String) {

        let imageData: NSData = UIImagePNGRepresentation(self.form.image.imageView.image!)! as NSData
        let strBase64 = imageData.base64EncodedString()

        let parameters = [
            "gallery": [
                "caption": "イベント画像",
                "briefInfo": "-",
                "freeText": "-",
                "eventId": NSNumber(value: Int(eventId)!)
            ],
            "content": [
                "mime": "image/png",
                "name": String(format: "%02d", "\(eventId)"),
                "link_url": "-",
                "data": strBase64
            ]
        ]

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let urlString = MITTY_SERVICE_BASE_URL + "/gallery/content"

        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default
                          , headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { [weak self] response in
            LoadingProxy.off()
            switch response.result {
            case .success:
                break
            case .failure(let error):
                print(error)
                self?.showError("画像登録エラー")
                Thread.sleep(forTimeInterval: 4)
            }
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}


