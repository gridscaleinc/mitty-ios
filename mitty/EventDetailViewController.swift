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

//
class EventDetailViewController: MittyViewController, UITextFieldDelegate {

    var event: Event
    var activity : ActivityInfo? = nil
    var activityItem : ActivityItem? = nil
    
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
    let subscribeButton = MQForm.button(name:"subscirbe", title:"参加する")

    let invitationButton = MQForm.button(name:"subscirbe", title:"招待する")

    init (event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        super.autoCloseKeyboard()

        self.view.backgroundColor = UIColor.white

        buildform()
        self.view.addSubview(form)

        form.autoPin(toTopLayoutGuideOf: self, withInset: 10)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        form.configLayout()
//        configNavigationBar()

    }

    func configNavigationBar() {
        // TODO: 他の画面への影響をなくす。この画面から出たら、モドに戻す。
        
        self.navigationItem.title = ""
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

        loadTerm(detailForm)
        
        loadTitle(detailForm)
        
        // Cover Image
        loadCoverImage(detailForm)
        
        loadLikes(detailForm)
        
        loadAction(detailForm)
        
        // TODO : Price Info
        addPriceInfo(detailForm)

        loadLocation(detailForm)
        
        addContactInfo(detailForm)

        let descriptionRow = Row.LeftAligned()

        let description = event.description

        let descriptionLabel = MQForm.label(name: "detailDescription", title: description, pad: 6).layout {
            c in
            c.fillHolizon(10).verticalCenter().leftMargin(10).taller(than: 50)
            c.label.numberOfLines = 0
        }
        
        descriptionRow +++ descriptionLabel
        descriptionRow.layout {
            r in
            r.fillHolizon().topAlign(with: descriptionLabel).bottomAlign(with: descriptionLabel)
        }

        detailForm <<< descriptionRow

        showEditButton(detailForm)
        
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
        let img = Control(name: "image", view: imageView).layout {
            i in
            i.width(UIScreen.main.bounds.size.width - 20 ).height(UIScreen.main.bounds.size.width).upper()
        }
        
        if (event.coverImageUrl != "") {
            DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
            imageView.af_setImage(withURL: URL(string: event.coverImageUrl)!, placeholderImage: UIImage(named: "downloading"), completion: { image in
                if (image.result.isSuccess) {
                    self.imageView.image = image.result.value
                    img.height((UIScreen.main.bounds.size.width - 20) * (image.result.value?.size.ratio)!)
                }
            }
            )
        }
        
        
        topRow +++ img
        topRow.layout {
            r in
            r.leftMargin(10).rightMargin(10)
            r.bottomAlign(with: img)
        }
        
        section <<< topRow

    }

    func loadTitle (_ section: Section ) {
        
        let row = Row.LeftAligned().layout {
            r in
            r.view.backgroundColor = MittyColor.white
            r.fillHolizon().height(50)
        }
        
        let titleLabel = MQForm.label(name: "Title", title: event.title).layout {
            l in
            l.leftMargin(10).rightMost(withInset: 45).height(30).verticalCenter()
            
            l.label.font = UIFont.boldSystemFont(ofSize: 20)
            l.label.textColor = MittyColor.black
            l.label.numberOfLines = 2
            l.label.adjustsFontSizeToFitWidth = true
        }
        row +++ titleLabel
        let imageIcon: Control = {
            if event.eventLogoUrl != "" {
                // imageがある場合、イメージを表示
                let itemImage = MQForm.img(name: "eventLogo", url: event.eventLogoUrl).layout {
                    img in
                    img.width(30).height(30)
                }
                itemImage.imageView.setMittyImage(url: event.eventLogoUrl)
                return itemImage
            } else {
                return MQForm.img(name: "eventLogo", url: "timesquare").width(30).height(30)
            }
        } ()
        
        row +++ imageIcon.layout {
            i in
            i.width(30).height(30).verticalCenter()
        }
        
        section <<< row
//        section <<< HL(MittyColor.healthyGreen, 0.55 ).leftMargin(10).rightMargin(10)
    }
    
    func loadLikes (_ section: Section) {
        let row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(50)
        }
        
        let likes = MQForm.label(name: "heart", title: "❤️ \(event.likes) likes").layout { l in
            l.height(35).width(90).verticalCenter().leftMargin(10)
        }
        
        row +++ likes
        
        let rightRow = Row.RightAligned().layout {
            r in
            r.rightMost(withInset: 15).fillVertical()
        }
        
        
        let likeButton = MQForm.button(name: "likeIt", title: "いいね").layout { b in
            b.height(30).width(90).verticalCenter()
            b.view.backgroundColor = .white
            b.view.layer.borderColor = MittyColor.sunshineRed.cgColor
            b.view.layer.borderWidth = 0.7
            b.button.setTitleColor(MittyColor.sunshineRed, for: .normal)
            b.button.setTitleColor(.gray, for: UIControlState.disabled)
        }
        
        var liked = false
        likeButton.bindEvent(.touchUpInside) { b in
            if super.notLogedIn {
                super.requestForLogin()
                return
            }
            if liked {
                if self.event.likes > 0 {
                    self.event.likes -= 1
                }
                liked = false
                likes.label.text = "❤️ \(self.event.likes) likes"
                LikesService.instance.removeLike("EVENT", id: Int64(self.event.id)!)
                likeButton.button.setTitleColor(.blue, for: .normal)
            } else {
                self.event.likes += 1
                likes.label.text = "❤️ \(self.event.likes) likes"
                LikesService.instance.sendLike("EVENT", id: Int64(self.event.id)!)
                likeButton.button.setTitleColor(.gray, for: .normal)
                liked = true
            }
        }
        
        rightRow +++ likeButton
        row +++ rightRow
        section <<< row
        section <<< HL(MittyColor.healthyGreen, 0.5 ).leftMargin(10).rightMargin(10).upMargin(10)
    }
    
    func loadTerm(_ section: Section) {
        
        // 日付情報を設定
        let row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(80)
        }
        
        let leftCol = EventDay(event).layout {
            c in
            c.width(60).height(65).upper(withInset: 10).leftMargin(10)
            c.view.backgroundColor = MittyColor.healthyGreen.withAlphaComponent(0.8)
            c.view.layer.cornerRadius = 1
            c.view.layer.masksToBounds = true
            c.view.layer.shadowColor = UIColor.gray.cgColor
            c.view.layer.shadowOpacity = 0.4
            c.view.layer.shadowOffset = CGSize(width: 1, height: 1)
            c.view.layer.shadowRadius = 3
        }
        
        row +++ leftCol
        
        let rightCol = Col.UpDownAligned().layout {
            c in
            c.fillVertical().rightMost()
        }
        
        row +++ rightCol
        
        
        let remainder = event.endDate.timeIntervalSinceNow / 86400
        let tillStart = event.startDate.timeIntervalSinceNow / 86400
        
        var remainDays = ""
        let duration = event.duration()
        rightCol +++ MQForm.label(name: "duration", title: duration).layout {
            d in
            d.fillHolizon(10).height(40)
            d.label.textAlignment = .center
            d.label.adjustsFontSizeToFitWidth = true
            d.label.font = UIFont.boldSystemFont(ofSize: 18)
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
        
        rightCol +++ termStatus.layout {
            pub in
            pub.height(40).fillHolizon(30)
            let l = pub.label
            l.textAlignment = .center
            l.adjustsFontSizeToFitWidth = true
            l.font = UIFont.boldSystemFont(ofSize: 12)
            l.textColor = UIColor.darkGray
        }
        
        section <<< row
    }
    
    func loadAction(_ section: Section) {
        let row = Row.LeftAligned()
        let actionLabel = MQForm.label(name: "action", title: (event.action), pad: 4).layout {
            c in
            c.fillHolizon(10).verticalCenter().leftMargin(10)
            c.label.numberOfLines = 0
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
        
        let row = Row.LeftAligned().layout {
            r in
            r.fillHolizon(15).height(40).leftMargin(10)
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
            l.label.numberOfLines = 2
        }
        
        row +++ location
        section <<< row
        
        section <<< HL(MittyColor.healthyGreen, 0.5 ).leftMargin(10).rightMargin(10).upMargin(10)
        let buttonRow = Row.Intervaled()
        buttonRow.spacing = 30
        let mapButton = MQForm.button(name: "route", title: "地図").layout { b in
            b.verticalCenter().height(35)
        }
        
        if (event.isValidGeoInfo) {
            mapButton.bindEvent(.touchUpInside) { _ in
                self.event.openGoogleMap()
            }
        }
        
        let routeButton = MQForm.button(name: "route", title: "経路").layout { b in
            b.verticalCenter().height(35)
        }
        
        if (event.isValidGeoInfo) {
            routeButton.bindEvent(.touchUpInside) { _ in
                self.event.openGoogleMapDirection()
            }
        }
        
        buttonRow +++ mapButton
        buttonRow +++ routeButton
        
        section <<< buttonRow
        
    }
    
    // 価格情報をデータに応じて表示。
    //
    func addPriceInfo(_ section: Section) {

    }

    func addContactInfo(_ section: Section) {
        
        
        // TODO: Mail address

        let infoSource = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }


        if (event.organizer == "") {
            event.organizer = "不明"
        }
        infoSource +++ MQForm.label(name: "sponsor", title: "主催者").layout {
            l in
            l.label.textAlignment = .left
            l.height(35).verticalCenter().leftMargin(10).width(90)
        }
        infoSource +++ MQForm.label(name: "name", title: event.organizer).layout {
            l in
            l.height(35).rightMost(withInset: 30).verticalCenter()
        }

        section <<< infoSource
        
        if event.contactTel != "" {
            let telRow = Row.LeftAligned().layout {
                r in
                r.fillHolizon().height(35)
            }
            
            
            telRow +++ MQForm.label(name: "tel", title: "☎️").layout {
                l in
                l.label.textAlignment = .left
                l.height(35).verticalCenter().leftMargin(10).width(90)
            }
            telRow +++ MQForm.label(name: "tel-value", title: event.contactTel).layout {
                l in
                l.height(35).rightMost(withInset: 30).verticalCenter()
            }
            
            
            section <<< telRow
        }
        
        if event.contactMail != "" {
            let mailRow = Row.LeftAligned().layout {
                r in
                r.fillHolizon().height(35)
            }
            mailRow +++ MQForm.label(name: "mail", title: "📩").layout {
                l in
                l.label.textAlignment = .left
                l.height(35).verticalCenter().leftMargin(10).width(90)
            }
            mailRow +++ MQForm.label(name: "mailvalue", title: event.contactMail).layout {
                l in
                l.height(35).rightMost(withInset: 30).verticalCenter()
            }
            section <<< mailRow
        }
        
        section <<< HL(MittyColor.healthyGreen, 0.5 ).leftMargin(10).rightMargin(10).upMargin(10)
        
        if event.contactTel != "" || event.contactMail != "" {
            let contactRow = Row.Intervaled()
                contactRow.spacing = 60
            
            if event.contactTel != "" {
                let contactButton = MQForm.button(name: "tel", title: "電話").layout { b in
                    b.height(35).verticalCenter()
                }
                contactButton.bindEvent(.touchUpInside) {
                    b in
                    super.callNumber(phoneNumber: self.event.contactTel)
                }
                
                contactRow +++ contactButton
            }
            
            if event.contactMail != "" {
                let mailButton = MQForm.button(name: "mail", title: "メール").layout { b in
                    b.height(35).verticalCenter()
                }
                mailButton.bindEvent(.touchUpInside) {
                    b in
                    super.sendEmail(sender: self, recipients: [self.event.contactMail])
                }
                contactRow +++ mailButton
            }
            section <<< contactRow
        }

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
        link.setTitleColor(MittyColor.sunshineRed, for: .normal)
        link.setTitle(event.sourceName, for: .normal)
        link.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        url +++ Control(name: "URL", view: link).layout {
            l in
            l.height(35).verticalCenter().rightMost(withInset: 10).leftMargin(5)
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
        
        section <<< HL(MittyColor.healthyGreen, 0.5 ).leftMargin(10).rightMargin(10).upMargin(30)

    }

    func showEditButton(_ section: Section) {
        if activity == nil {
            return
        }
        
        if (ApplicationContext.userSession.isLogedIn) {
            let session = ApplicationContext.userSession
            if event.publisherId == session.userId {
                let row = Row.LeftAligned()
                row.layout {
                    r in
                    r.fillHolizon().height(40).upMargin(20)
                }
                
                let editLabel = MQForm.button(name: "Edit", title: "編集する").layout {
                    l in
                    l.verticalCenter().rightMost(withInset: 40).leftMargin(40).height(35)
                }
                
                row +++ editLabel
                
                section <<< row
                editLabel.bindEvent(.touchUpInside) {
                    b in
                    let vc = EventModifyViewController(self.activity!)
                    vc.event = self.event
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                section <<< HL(MittyColor.healthyGreen, 0.5 ).leftMargin(50).rightMargin(50).upMargin(10)
            }
        }

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
            r.view.backgroundColor = .white
        }

        buttons.spacing = 10


        let subscribe = subscribeButton.layout {
            c in
            c.button.setTitleColor(MittyColor.healthyGreen, for: .normal)
            c.height(40).verticalCenter()
        }

        subscribe.bindEvent(.touchUpInside) {
            b in
            self.pressSubscribe(sender: b as! UIButton)
        }

        let invitation = invitationButton.layout {
            c in
            c.height(40).verticalCenter()
            c.button.setTitleColor(MittyColor.healthyGreen, for: .normal)
        }
        
        invitation.bindEvent(.touchUpInside) {
            b in
            self.invite(sender: b as! UIButton)
        }

        buttons +++ invitation


        if event.accessControl == "public" {
            if !event.participated() {
                buttons +++ subscribe
            }
        }

        form +++ buttons

    }

    
    func invite (sender: UIButton) {
        if notLogedIn {
            super.requestForLogin()
            return
        }
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
        if notLogedIn {
            super.requestForLogin()
            return
        }
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
