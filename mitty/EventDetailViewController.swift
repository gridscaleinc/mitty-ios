//
//  EventDetail.swift
//  mitty
//
//  Created by gridscale on 2017/04/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class EventDetailViewController: MittyViewController, UITextFieldDelegate {

    var event: Event

    var form = MQForm.newAutoLayout()

    //
    // Purelayout流の画面パーツ作り方、必ずnewAutoLayoutを一度呼び出す。
    // 画面を構成するパーツだから、methoの中ではなく、インスタンス変数として持つ。
    //

    let imageView: UIImageView = {

        let itemImageView = UIImageView.newAutoLayout()
        itemImageView.clipsToBounds = true
        itemImageView.contentMode = UIViewContentMode.scaleAspectFill
        return itemImageView
    } ()


    ///
    ///
    let subscribeButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("参加", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .orange

        return b
    } ()

    let invitationButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("招待", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .orange

        return b
    } ()

    let revertButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("脱退", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .orange

        return b
    } ()

    init (event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        super.autoCloseKeyboard()

        self.view.backgroundColor = UIColor.white

        buildform()
        self.view.addSubview(form)

        form.autoPinEdge(toSuperviewEdge: .top)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        form.configLayout()
        configNavigationBar()


    }

    func configNavigationBar() {
        // TODO: 他の画面への影響をなくす。この画面から出たら、モドに戻す。
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = MittyColor.healthyGreen

        self.navigationController?.view.backgroundColor = .clear
        //        self.navigationController?.navigationBar.isHidden = true
    }

    func buildform () {

        form.backgroundColor = UIColor(patternImage: UIImage(named: "timesquare")!)

        // スクロールViewを作る
        let scroll = UIScrollView.newAutoLayout()
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

        // Cover Image
        loadCoverImage(detailForm)
        
        loadTitle(detailForm)
        
        loadLikes(detailForm)
        
        loadTerm(detailForm)
        
        loadAction(detailForm)
        
        // TODO : Price Info
        addPriceInfo(detailForm)

        loadLocation(detailForm)
        
        addContactInfo(detailForm)

        let descriptionRow = Row.LeftAligned()

        let description = event.description

        let descriptionLabel = MQForm.label(name: "detailDescription", title: description).layout {
            c in
            c.fillHolizon(10).verticalCenter().leftMargin(10)
            let l = c.view as! UILabel
            //            l.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
            l.numberOfLines = 0
            l.textColor = .black
            l.font = .systemFont(ofSize: 15)
            l.layer.cornerRadius = 2
            l.layer.borderWidth = 0.8
            l.layer.borderColor = UIColor.gray.cgColor
            l.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
        }
        descriptionRow +++ descriptionLabel
        descriptionRow.layout {
            r in
            r.fillHolizon().topAlign(with: descriptionLabel).bottomAlign(with: descriptionLabel)
        }

        detailForm <<< descriptionRow

        let interval = Row.LeftAligned().layout {
            r in
            r.fillHolizon().taller(than: 60)
        }

        detailForm <<< interval

        detailForm.layout {
            f in
            f.fillParent().width(UIScreen.main.bounds.width).bottomAlign(with: interval)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }

        setButtons()
    }
    
    func loadCoverImage(_ section: Section) {
        
        let topRow = Row.LeftAligned()
        let topContainer = Container (name: "topContainer", view: UIView.newAutoLayout())
        let img = Control(name: "image", view: imageView).layout {
            i in
            i.width(UIScreen.main.bounds.size.width).height(UIScreen.main.bounds.size.width).upper()
        }
        
        if (event.coverImageUrl != "") {
            DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
            imageView.af_setImage(withURL: URL(string: event.coverImageUrl)!, placeholderImage: UIImage(named: "downloading"), completion: { image in
                if (image.result.isSuccess) {
                    self.imageView.image = image.result.value
                    img.height(UIScreen.main.bounds.size.width * (image.result.value?.size.ratio)!)
                }
            }
            )
        }
        topContainer +++ img
        topContainer.layout {
            c in
            c.fillHolizon().upper()
            c.topAlign(with: img).bottomAlign(with: img)
        }
        
        
        topRow +++ topContainer
        topRow.layout {
            r in
            r.fillHolizon()
            r.topAlign(with: topContainer).bottomAlign(with: topContainer)
        }
        
        section <<< topRow

    }

    func loadTitle (_ section: Section ) {
        
        let row = Row.LeftAligned().layout {
            r in
            r.view.backgroundColor = MittyColor.healthyGreen
            r.fillHolizon().height(35)
        }
        
        let titleLabel = MQForm.label(name: "Title", title: event.title).layout {
            l in
            l.leftMargin(15).rightMost(withInset: 55).height(30).verticalCenter()
            
            l.label.font = UIFont.boldSystemFont(ofSize: 20)
            l.label.textColor = UIColor.white
            l.label.numberOfLines = 2
            l.label.adjustsFontSizeToFitWidth = true
        }
        
        row +++ titleLabel
        let imageIcon: Control = {
            if event.eventLogoUrl != "" {
                // imageがある場合、イメージを表示
                let itemImage = MQForm.img(name: "eventImage", url: event.eventLogoUrl).layout {
                    img in
                    img.width(30).height(30)
                }
                itemImage.imageView.setMittyImage(url: event.eventLogoUrl)
                return itemImage
            } else {
                return MQForm.img(name: "eventLogo", url: "timesquare").width(50).height(50)
            }
        } ()
        
        row +++ imageIcon.layout {
            i in
            i.width(35).height(35).rightMost(withInset: 15).verticalCenter()
        }
        
        section <<< row
        
    }
    
    func loadLikes (_ section: Section) {
        let row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }
        
        let likes = MQForm.hilight(label: "❤️ \(event.likes) likes", named: "heart").layout { l in
            l.height(35).width(90).verticalCenter().leftMargin(15)
        }
        
        row +++ likes
        
        let rightRow = Row.RightAligned().layout {
            r in
            r.rightMost(withInset: 15).fillVertical()
        }
        
        let likeButton = MQForm.button(name: "likeIt", title: "いいね").layout { b in
            b.height(30).width(90).verticalCenter()
            b.view.backgroundColor = .white
            b.view.layer.borderColor = UIColor.orange.cgColor
            b.view.layer.borderWidth = 0.7
            b.button.setTitleColor(UIColor.orange, for: .normal)
            b.button.setTitleColor(.gray, for: UIControlState.disabled)
            b.button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
        }
        
        likeButton.bindEvent(.touchUpInside) { b in
            LikesService.instance.sendLike("EVENT", id: Int64(self.event.id)!)
            (b as! UIButton).isEnabled = false
        }
        
        rightRow +++ likeButton
        row +++ rightRow
        section <<< row

    }
    
    func loadTerm(_ section: Section) {
        
        seperator(section: section, caption: "期間")
        
        // 日付情報を設定
        let row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(34)
        }
        
        row.spacing = 10
        
        let remainder = event.endDate.timeIntervalSinceNow / 86400
        let tillStart = event.startDate.timeIntervalSinceNow / 86400
        
        var remainDays = ""
        let duration = event.duration()
        row +++ MQForm.label(name: "duration", title: duration).layout {
            d in
            d.leftMost(withInset:5).rightMargin(10).verticalCenter()
            d.label.adjustsFontSizeToFitWidth = true
            d.label.textColor = UIColor.gray
        }
        // 未開始
        if (tillStart > 0) {
            remainDays = "開始まで\(Int(tillStart))日"
            // 開始まで１日を切った場合
            if tillStart < 1 {
                remainDays = "開始まで\(Int(tillStart*24))時間"
            }
            
            // 開始まで1時間を切った場合
            if tillStart < (1/24) {
                remainDays = "開始まで\(Int(tillStart*24*60))分"
            }
            
            // 進行中
        } else if (tillStart <= 0 && remainder > 0) {
            remainDays = "終了まで\(Int(remainder))日"
            // 終了まで１日を切った場合
            if remainder < 1 {
                remainDays = "終了まで\(Int(remainder*24))時間"
            }
            
            // 開始まで1時間を切った場合
            if remainder < (1/24) {
                remainDays = "終了まで\(Int(remainder*24*60))分"
            }
            
            // 完了
        } else if remainder <= 0 {
            remainDays = "完了しました"
            // else はありえない、意味不明
        } else {
            remainDays = "日程不明"
        }
        
        let termStatus = MQForm.hilight(label: remainDays, named:"termStatus")
        
        row +++ termStatus.layout {
            pub in
            pub.height(28).verticalCenter()
            let l = pub.label
            l.textAlignment = .center
            l.adjustsFontSizeToFitWidth = true
            l.font = UIFont.boldSystemFont(ofSize: 12)
            l.textColor = UIColor.darkGray
        }
        
        section <<< row

    }
    func loadAction(_ section: Section) {
        
        seperator(section: section, caption: "行い内容")
        
        let row = Row.LeftAligned()
        row.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        let actionLabel = MQForm.label(name: "action", title: (event.action)).layout {
            c in
            c.fillHolizon(15).verticalCenter().leftMargin(15)
            c.label.numberOfLines = 0
            c.label.font = .boldSystemFont(ofSize: 14)
            c.label.textColor = UIColor.darkGray
        }
        
        row +++ actionLabel
        row.layout {
            r in
            r.fillHolizon()
            r.topAlign(with: actionLabel).bottomAlign(with: actionLabel)
        }
        
        section <<< row
    }
    
    func loadLocation (_ section: Section) {
        
        seperator(section: section, caption: "場所")
        
        let row = Row.LeftAligned().layout {
            r in
            r.fillHolizon(15).height(40).leftMargin(15)
        }
        row +++ MQForm.label(name: "geoIcon", title: "📍").height(35).width(30).layout{
            l in
            l.verticalCenter()
        }
        
        if (self.event.isLandLogoUrl != "" ) {
            let lacationIcon = MQForm.img(name: "locationIocn", url: "").layout {
                icon in
                icon.height(25).width(25).verticalCenter()
            }
            lacationIcon.imageView.setMittyImage(url: self.event.isLandLogoUrl)
            
            row +++ lacationIcon
        }
        
        let location = MQForm.label(name: "isLand", title: "\(event.isLandName)").layout { l in
            l.height(40).rightMost(withInset: 5).verticalCenter().leftMargin(10)
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
            l.label.font = UIFont.systemFont(ofSize: 14)
            
            if self.event.isValidGeoInfo {
                l.label.textColor = MittyColor.healthyGreen
            }
        }
        
        if (event.isValidGeoInfo) {
            location.bindEvent(.touchUpInside) { _ in
                self.event.openGoogleMap()
            }
        }
        
        row +++ location
        section <<< row
        
        let buttonRow = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(40)
        }
        
        buttonRow.spacing = 40
        
        let routeButton = MQForm.button(name: "route", title: "経路").layout { b in
            b.verticalCenter().height(30)
            b.view.backgroundColor = .white
            b.view.layer.borderColor = UIColor.orange.cgColor
            b.view.layer.borderWidth = 0.7
            b.button.setTitleColor(UIColor.orange, for: .normal)
            
        }
        
        buttonRow +++ routeButton
        
        section <<< buttonRow
        
    }
    // 価格情報をデータに応じて表示。
    //
    func addPriceInfo(_ section: Section) {

    }

    func addContactInfo(_ section: Section) {

        seperator(section: section, caption: "補足情報")
        
        // TODO: Mail address

        let infoSource = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }


        infoSource +++ MQForm.label(name: "sponsor", title: "主催者").layout {
            l in
            l.height(35).verticalCenter().leftMargin(10)
        }
        infoSource +++ MQForm.label(name: "name", title: event.organizer).layout {
            l in
            l.height(35).rightMost(withInset: 70).verticalCenter()
        }

        section <<< infoSource
        
        let contactRow = Row.Intervaled()
        contactRow.spacing = 40
        
        let contactButton = MQForm.button(name: "contact", title: "問合せ").layout { b in
            b.height(30).verticalCenter()
            b.view.backgroundColor = .white
            b.view.layer.borderColor = UIColor.orange.cgColor
            b.view.layer.borderWidth = 0.7
            b.button.setTitleColor(UIColor.orange, for: .normal)
        }
        
        contactRow +++ contactButton
        section <<< contactRow

        let url = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        url +++ MQForm.label(name: "URL", title: "情報源").layout {
            l in
            l.height(35).verticalCenter().leftMargin(10)
            l.label.adjustsFontSizeToFitWidth = true
        }

        let link = UIButton.newAutoLayout()
        link.setTitleColor(MittyColor.healthyGreen, for: .normal)
        link.setTitle(event.sourceName, for: .normal)
        link.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        url +++ Control(name: "URL", view: link).layout {
            l in
            l.height(35).verticalCenter().rightMost(withInset: 10)
        }.bindEvent(.touchUpInside) { [weak self]
            b in

            let urlString: String = (self?.event.sourceUrl)!

            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }

        section <<< url

    }

    var buttons = Row.Intervaled()

    func setButtons() {

        // ２回目以降に呼ばれる際に備える。
        for b in buttons.children {
            b.view.removeFromSuperview()
        }
        if (buttons.view.superview != nil) {
            buttons.view.removeFromSuperview()
        }

        buttons = Row.Intervaled().layout {
            r in
            r.fillHolizon().down().height(40)
        }

        buttons.spacing = 10


        let subscribe = Control(name: "subscribe", view: subscribeButton).layout {
            c in
            c.height(40).verticalCenter()
        }

        subscribe.bindEvent(.touchUpInside) {
            b in
            self.pressSubscribe(sender: self.subscribeButton)
        }

        let revert = Control(name: "revert", view: revertButton).layout {
            c in
            c.height(40).verticalCenter()
        }

        let invitation = Control(name: "revert", view: invitationButton).layout {
            c in
            c.height(40).verticalCenter()
            c.button.backgroundColor = MittyColor.healthyGreen
        }
        invitation.bindEvent(.touchUpInside) {
            b in
            self.invite(sender: self.invitationButton)
        }

        buttons +++ invitation


        if event.accessControl == "public" {
            if !event.participated() {
                buttons +++ subscribe
            } else {
                buttons +++ revert
            }
        }

        form +++ buttons

    }

    func invite (sender: UIButton) {

        let vc = SendInvitationViewController()
        vc.event = self.event
        self.navigationController?.pushViewController(vc, animated: true)

    }

    func share (sender: UIButton) {
        // 共有する項目
        let shareText = "Apple - Apple Watch"
        let shareWebsite = NSURL(string: "https://www.apple.com/jp/watch/")!
        let shareImage = UIImage(named: "penginland")!

        let activityItems = [shareText, shareWebsite, shareImage] as [Any]

        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityType.postToFacebook,
            UIActivityType.postToTwitter,
            UIActivityType.message,
            UIActivityType.saveToCameraRoll,
            UIActivityType.print
        ]

        activityVC.excludedActivityTypes = excludedActivityTypes

        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)

    }

    // 参加
    func pressSubscribe (sender: UIButton) {
        ActivityService.instance.register(event.title, event.description, event.id,
                                          onCompletion: {
                                              act in
                                              let detailViewController = ActivityPlanDetailsController(act)
                                              self.navigationItem.title = "..."
                                              self.tabBarController?.tabBar.isHidden = true
                                              self.navigationController?.pushViewController(detailViewController, animated: true)
                                              self.event.participationStatus = "PARTICIPATING"
                                              self.setButtons()
                                              self.buttons.configLayout()
                                          },
                                          onError: {
                                              error in
                                              self.showError("活動登録時エラーになりました。")
                                          })
    }



}
