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
    var form = EventEditForm()
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

        setForm()
        
        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(form)

        form.loadForm()

        view.setNeedsUpdateConstraints() // bootstrap Auto Layout

    }
    func setForm() {
        
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
            form.setImage(info.siteImage!)
            imagePicked = true
        }
    }

    func pickImage () {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .formSheet
            self.present(imagePicker, animated: true, completion: nil)
        }

    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        NSLog("\(info)")
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        form.setImage(chosenImage.af_imageScaled(to: CGSize(width: 161.8, height: 161.8)))
        picker.dismiss(animated: false, completion: nil)
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
        if (content.linkUrl != nil) {
            form.icon.imageView.setMittyImage(url: (content.linkUrl)!)
        }
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
        if (self.form.coverImage == nil) {
            showError("画像未設定")
            return
        }
        
        let imageData: NSData = UIImagePNGRepresentation(self.form.coverImage!.imageView.image!)! as NSData
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
        
        let api = APIClient(path: "/gallery/content", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            self.navigationController?.popViewController(animated: true)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
            self.showError("画像登録エラー")
        })
    }
}


