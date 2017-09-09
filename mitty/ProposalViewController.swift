//
//  ProposalViewController.swift
//  mitty
//
//  Created by gridscale on 2017/07/09.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class ProposalViewController: MittyViewController, IslandPickerDelegate, PricePickerDelegate {

    var relatedRequest: RequestInfo!

    let form: MQForm = MQForm.newAutoLayout()

    var pickedIsland: IslandPick? = nil
    let pricePicker = PricePicker()

    // 場所
    let location = MQForm.text(name: "location", placeHolder: "場所名を入力")
    let locationIcon = MQForm.img(name: "icon", url: "noicon")
    let addressLabel = MQForm.label(name: "label-Address", title: "住所")
    let address = MQForm.label(name: "address", title: "")

    var addressRow: Row? = nil


    let priceInput = MQForm.button(name: "priceInput", title: "価格を入力")
    let price1 = MQForm.label(name: "price1", title: "")
    var price1Row: Row? = nil

    let price2 = MQForm.label(name: "price2", title: "")
    var price2Row: Row? = nil

    let priceDetail = MQForm.label(name: "priceDetail", title: "")
    var priceDetailRow: Row? = nil

    let contactTel = MQForm.text(name: "contact-Tel", placeHolder: "☎️ 電話番号")
    // 開始日時
    let date1 = MQForm.text(name: "fromDateTime", placeHolder: "開始日時")
    let picker1 = UIDatePicker()

    //  終了日時
    let date2 = MQForm.text(name: "toDateTime", placeHolder: "終了日時")
    let picker2 = UIDatePicker()

    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    } ()


    ///
    ///
    let proposolButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("Done", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .orange

        return b
    } ()

    let additionalInfo = MQForm.textView(name: "description")


    override func viewDidLoad() {

        super.autoCloseKeyboard()

        buildForm()


        pricePicker.delegate = self
        picker1.date = Date()
        picker2.date = Date()

        let startDateText = date1.textField

        startDateText.inputView = picker1
        setFromDateTime(picker1)
        picker1.addTarget(self, action: #selector(setFromDateTime(_:)), for: .valueChanged)


        let endDateText = date2.textField
        endDateText.inputView = picker2
        setToDateTime(picker2)
        picker2.addTarget(self, action: #selector(setToDateTime(_:)), for: .valueChanged)


        self.view.addSubview(form)
        self.view.backgroundColor = .white

        location.bindEvent(.editingDidBegin) { [weak self]
            c in
            c.resignFirstResponder()
            let controller = IslandPicker()
            controller.delegate = self
            controller.islandForm.addressControl.textField.text = self?.address.label.text
            controller.islandForm.nameText.text = self?.location.textField.text

            self?.navigationController?.pushViewController(controller, animated: true)
        }

        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        self.view.setNeedsUpdateConstraints()


    }

    func setFromDateTime(_ picker: UIDatePicker) {
        let textField = date1.textField
        textField.text = dateFormatter.string(from: picker.date)
    }


    func setToDateTime(_ picker: UIDatePicker) {
        let textField = date2.textField
        textField.text = dateFormatter.string(from: picker.date)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        form.configLayout()
        updateLayout()
    }

    func buildForm() {

        let row_height = CGFloat(50)
        let line_height = CGFloat(48)


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

        let detailForm = Section(name: "Content-Form", view: UIView.newAutoLayout())

        scrollContainer +++ detailForm

        var row = Row.LeftAligned()

        row.layout {
            r in
            r.fillHolizon(0).height(25)
            r.view.backgroundColor = MittyColor.healthyGreen
        }

        row +++ MQForm.label(name: "title-request", title: "リクエスト").layout {
            c in
            c.height(25)
            c.leftMost(withInset: 20).verticalCenter()
            let l = c.view as! UILabel
            l.textColor = .white
            l.font = .systemFont(ofSize: 16)
        }
        detailForm <<< row


        row = Row.LeftAligned()

        row.layout {
            r in
            r.fillHolizon(0).height(25)
        }

        let titleLabel = MQForm.label(name: "Title", title: relatedRequest.title).layout {
            l in
            l.fillHolizon(10).height(25).verticalCenter()
            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 20)
            (l.view as! UILabel).textColor = .black
            (l.view as! UILabel).numberOfLines = 0
        }

        row +++ titleLabel

        detailForm <<< row

        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(0).height(25)
        }
        let tagLabel = MQForm.label(name: "tag", title: "🏷 " + relatedRequest.tag).layout {
            l in
            l.width(35).height(35).fillHolizon(10).verticalCenter()
            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 15)
            (l.view as! UILabel).textColor = .gray
            (l.view as! UILabel).numberOfLines = 1
        }
        row +++ tagLabel
        detailForm <<< row

        row = Row.LeftAligned()

        let actionLabel = MQForm.label(name: "action", title: (relatedRequest.desc)).layout {
            c in
            c.fillHolizon(10).verticalCenter()
            let l = c.view as! UILabel
            l.numberOfLines = 3
            l.textColor = .black
            l.font = .systemFont(ofSize: 15)
            l.layer.cornerRadius = 2
            l.layer.borderWidth = 0.8
            l.layer.borderColor = UIColor.gray.cgColor
            l.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
        }
        row.layout {
            r in
            r.fillHolizon(0).bottomAlign(with: actionLabel).topAlign(with: actionLabel)
        }

        row +++ actionLabel
        detailForm <<< row

        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(0).height(25)
            r.view.backgroundColor = .orange
        }

        row +++ MQForm.label(name: "title-main-proposal", title: "提案情報登録").layout {
            c in
            c.height(25).verticalCenter()
            c.leftMost(withInset: 20)
            let l = c.view as! UILabel
            l.textColor = .white
            l.font = .systemFont(ofSize: 16)
        }
        detailForm <<< row

        row = Row.LeftAligned()


        seperator(section: detailForm, caption: "価格")
        row = Row.LeftAligned().height(row_height)
        row +++ MQForm.label(name: "price", title: "価格").height(line_height).width(60).layout {
            l in
            l.verticalCenter()
        }

        row +++ priceInput.layout {
            line in
            line.button.setTitleColor(MittyColor.healthyGreen, for: .normal)
            line.button.backgroundColor = .white
            line.button.layer.borderWidth = 0

            line.height(line_height).rightMost(withInset: 10).verticalCenter()
        }

        priceInput.bindEvent(.touchUpInside) { [weak self]
            c in
            self?.navigationController?.pushViewController((self?.pricePicker)!, animated: true)
        }

        detailForm <<< row

        price1Row = Row.LeftAligned().height(20)
        price1Row! +++ price1.layout {
            p in
            p.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            p.label.textColor = .gray
            p.fillHolizon(20).verticalCenter()
        }

        detailForm <<< price1Row!

        price2Row = Row.LeftAligned().height(20)
        price2Row! +++ price2.layout {
            p in
            p.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            p.label.textColor = .gray
            p.fillHolizon(20).verticalCenter()

        }

        detailForm <<< price2Row!

        priceDetailRow = Row.LeftAligned().height(30)
        priceDetailRow! +++ priceDetail.layout {
            p in
            p.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            p.label.textColor = .gray
            p.fillHolizon(20).verticalCenter()
        }

        detailForm <<< priceDetailRow!

        seperator(section: detailForm, caption: "日程")
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-start", title: "開始").height(line_height).width(60).layout {
            l in
            l.verticalCenter()
        }

        row +++ date1.layout {
            line in
            line.textField.textColor = MittyColor.healthyGreen
            line.textField.attributedPlaceholder = NSAttributedString(string: "開始日付・時刻を入力", attributes: [NSForegroundColorAttributeName: MittyColor.healthyGreen])
            line.height(line_height).rightMost(withInset: 10).verticalCenter()
        }

        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }

        detailForm <<< row

        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-End", title: "終了").height(line_height).width(60)
        row +++ date2.layout {
            line in
            line.textField.textColor = MittyColor.healthyGreen
            line.textField.attributedPlaceholder = NSAttributedString(string: "終了日付・時刻を入力", attributes: [NSForegroundColorAttributeName: MittyColor.healthyGreen])
            line.height(line_height).rightMost(withInset: 10).verticalCenter()
        }

        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }

        detailForm <<< row

        seperator(section: detailForm, caption: "場所")
        row = Row.LeftAligned()
        row +++ location.layout {
            line in
            line.textField.textColor = MittyColor.healthyGreen
            line.textField.attributedPlaceholder = NSAttributedString(string: "場所名・住所などを入力", attributes: [NSForegroundColorAttributeName: MittyColor.healthyGreen])
            line.height(line_height).rightMost(withInset: 60).verticalCenter()
        }
        row +++ locationIcon.height(line_height).width(line_height)


        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        detailForm <<< row

        row = Row.LeftAligned()
        addressRow = row
        row +++ addressLabel.layout {
            l in
            l.height(0).width(60).verticalCenter()
        }
        row +++ address.layout {
            line in
            line.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            line.label.isUserInteractionEnabled = false
            line.label.textColor = UIColor.gray
            line.label.numberOfLines = 0
            line.height(0).rightMost(withInset: 10).verticalCenter()
        }

        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        detailForm <<< row

        seperator(section: detailForm, caption: "補足")
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-Tel", title: "連絡先").height(line_height).width(70).layout {
            l in
            l.verticalCenter()
        }

        row +++ contactTel.layout {
            line in
            line.height(line_height).rightMost(withInset: 10).verticalCenter()
        }

        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }

        detailForm <<< row

        row = Row.LeftAligned()
        row +++ additionalInfo.layout {
            line in
            line.height(90).rightMost(withInset: 10).verticalCenter()
        }

        row.layout() {
            r in
            r.height(100).fillHolizon()
        }

        detailForm <<< row

        row = Row.Intervaled()
        row.spacing = 90

        let proposal = Control(name: "scbscribe", view: proposolButton).layout {
            c in
            c.height(45)
        }

        proposal.bindEvent(.touchUpInside) { _ in
            self.propose()
        }

        row +++ proposal

        row.layout() {
            r in
            r.height(100).fillHolizon()
        }

        detailForm <<< row

        //reply_to_request_id		int8
        //contact_tel		varchar	(20),
        //proposed_island_id		int8
        //priceName1		varchar	(1000),
        //price1		int
        //priceName2		varchar	(1000),
        //price2		int
        //priceCurrence		varchar	(1000),
        //priceInfo		varchar	(1000),
        //proposed_datetime1		timestamp
        //proposed_datetime2		timestamp
        //additionalInfo		varchar	(1000),
        //proposer_id		int8
        //proposed_date		timestamp
        //accept_status		varchar	(1000),
        //accept_date		timestamp
        //confirm_tel		varchar	(1000),
        //confirm_mail_address		varchar	(50),
        //approval_status		varchar	(1000),
        //approval_date		timestamp

        let bottom = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }

        detailForm <<< bottom

        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }

    }

    func updateLayout () {
        addressLabel.heightConstraints?.autoRemove()
        address.heightConstraints?.autoRemove()
        addressRow?.heightConstraints?.autoRemove()

        if address.label.text != "" {
            addressLabel.height(48)
            address.height(48)
            addressRow?.height(48)
        } else {
            addressLabel.height(0)
            address.height(0)
            addressRow?.height(0)
        }

        price1Row?.heightConstraints?.autoRemove()
        price1.heightConstraints?.autoRemove()
        price2Row?.heightConstraints?.autoRemove()
        price2.heightConstraints?.autoRemove()
        priceDetailRow?.heightConstraints?.autoRemove()
        priceDetail.heightConstraints?.autoRemove()


        if price1.label.text != "" {
            price1Row?.height(15)
            price1.height(15)
        } else {
            price1Row?.height(0)
            price1.height(0)
        }

        if price2.label.text != "" {
            price2Row?.height(15)
            price2.height(15)
        } else {
            price2Row?.height(0)
            price2.height(0)
        }

        if priceDetail.label.text != "" {
            priceDetailRow?.height(60)
            priceDetail.height(60)
        } else {
            priceDetailRow?.height(0)
            priceDetail.height(0)
        }


    }

    //
    // 場所選択した際の処理
    //
    func pickedIsland(landInfo: IslandPick) {
        self.location.textField.text = landInfo.name
        self.address.label.text = landInfo.address

        pickedIsland = landInfo

        checkAndRegist(landInfo)

        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }


    func clearPickedIsland() {

    }

    func pickedPrice(_ picker: PricePicker) {
        self.price1.label.text = picker.getPrice1()
        self.price2.label.text = picker.getPrice2()
        self.priceDetail.label.text = picker.priceInfo.textView.text

        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }

    func clearPickedPriceInfo() {

    }

    //
    func propose () {
        let newProposal = NewProposalReq()

        newProposal.setInt(.ReplyToRequestID, String(relatedRequest.id))
        if contactTel.textField.text == nil {
            showError("連絡電話を入力してください。")
            return
        }

        newProposal.setStr(.ContactTel, contactTel.textField.text)
        // newProposal.setStr(.ContactEmail    , contact.textField.text)
        if (pickedIsland == nil) {
            showError("場所を選択してください。")
            return
        }

        newProposal.setInt(.ProposedIslandID, String(pickedIsland!.id))

        // newProposal.setInt(.ProposedIslandID2 , contactTel.textField.text)
        // newProposal.setInt(.GalleryID         , contactTel.textField.text)
        newProposal.setStr(.PriceName1, pricePicker.priceName1.textField.text)
        if pricePicker.price1.textField.text != "" {
            newProposal.setInt(.Price1, pricePicker.price1.textField.text!)
        }

        newProposal.setStr(.PriceName2, pricePicker.priceName2.textField.text)
        if pricePicker.price2.textField.text != "" {
            newProposal.setInt(.Price2, pricePicker.price2.textField.text!)
        }

        if pricePicker.currency.textField.text != "" {
            newProposal.setStr(.PriceCurrency, pricePicker.currency.textField.text)
        }
        if pricePicker.priceInfo.textView.text != nil {
            newProposal.setStr(.PriceInfo, pricePicker.priceInfo.textView.text)
        }

        newProposal.setDate(.ProposedDatetime1, picker1.date)
        newProposal.setDate(.ProposedDatetime2, picker2.date)

        if additionalInfo.textView.text == nil {
            showError("提案内容を入力してください。")
            return
        }

        newProposal.setStr(.AdditionalInfo, additionalInfo.textView.text)
        // newProposal.setStr(.ProposerInfo, contactTel.textField.text)

        ProposalService.instance.register(newProposal, onSuccess: {
            self.navigationController?.popViewController(animated: true)
        }, onError: {
            error in
            self.showError(error)
        })
    }
}
