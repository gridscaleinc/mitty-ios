//
//  ProfileViewController.swift
//  mitty
//
//  Created by gridscale on 2017/08/24.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

// todo 改造中
class ProfileViewController: MittyViewController {

    var mittyId: Int!

    var userInfo = UserInfo()
    var profile = Profile()
    var socialIdList = [SocialId]()
    var nameCardBox = [ContacteeNamecard]()
    var content: Content? = Content()

    var form = MQForm.newAutoLayout()

    let picture: Control = MQForm.button(name: "m2", title: "")

    let idLabel = MQForm.label(name: "mitty-id", title: "")
    let nameLabel = MQForm.label(name: "name", title: "秘密")
    let genderLabel = MQForm.hilight(label: "秘密", named: "gender")
    let ageGroupLabel = MQForm.hilight(label: "秘密", named: "age-group")
    let speech = MQForm.textView(name: "speech")

    let constellationLabel = MQForm.hilight(label: "秘密", named: "constellation")
    let homeIslandLabel = MQForm.hilight(label: "秘密", named: "home-island")

    let birthIslandLabel = MQForm.hilight(label: "秘密", named: "birth-island")

    let appearanceLabel = MQForm.hilight(label: "秘密", named: "appearence")

    let occupationLabel1 = MQForm.hilight(label: "未設定", named: "occupation1")
    let occupationLabel2 = MQForm.hilight(label: "未設定", named: "occupation2")
    let occupationLabel3 = MQForm.hilight(label: "未設定", named: "occupation3")

    let hobbyLabel1 = MQForm.hilight(label: "未設定", named: "hobby1")
    let hobbyLabel2 = MQForm.hilight(label: "未設定", named: "hobby2")
    let hobbyLabel3 = MQForm.hilight(label: "未設定", named: "hobby3")
    let hobbyLabel4 = MQForm.hilight(label: "未設定", named: "hobby4")
    let hobbyLabel5 = MQForm.hilight(label: "未設定", named: "hobby5")
    let blank = MQForm.label(name: "blank", title: "")

    let nameCardSection = Section(name: "namecard-section")

    let socialIdSection = Section(name: "social-id-section")


    override func viewDidLoad() {
        super.viewDidLoad()

        super.autoCloseKeyboard()

        self.view.backgroundColor = UIColor.white

        buildform()
        self.view.addSubview(form)

        UserService.instance.getUserInfo(id: String(mittyId), callback: {
            uinfo, exists in
            if exists {
                self.userInfo = uinfo!
                ProfileService.instance.profile(of: self.mittyId, onComplete: {
                    p in
                    self.profile = p

                    SocialContactService.instance.contactedNamecards(of: p.mittyId, onComplete: {
                        cardlist in
                        self.nameCardBox = cardlist
                        p.addObserver(handler: { o in
                            self.setUserProfile()
                        })
                        p.notify()
                        self.addCardList()
                    }, onError: { error in
                        self.showError(error)
                    })
                }, onError: { error in
                    self.showError(error)
                })
            } else {
                self.showError("User Not Exists")
            }
        })



    }

    override func viewDidAppear(_ animated: Bool) {
        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {

        super.updateViewConstraints()

        form.autoPin(toTopLayoutGuideOf: self, withInset: 10)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        form.configLayout()

    }

    func buildform () {

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
        //        scroll.layer.borderWidth = 1
        //        scroll.layer.borderColor = UIColor.blue.cgColor

        let scrollContainer = Container(name: "Detail-form", view: scroll).layout() { (container) in
            container.fillParent()
        }

        form +++ scrollContainer

        let detailForm = Section(name: "Content-Form", view: UIView.newAutoLayout())
        detailForm.lineSpace = 3

        scrollContainer +++ detailForm

        loadPicture()


        // bild Identity
        buildIdentity(detailForm)

        // build Speech
        buildSpeech(detailForm)
        
        // build Social Links
        buildSocialLinks(detailForm)
        
        // build name cards
        buildNameCards(detailForm)

        // build biography
        buildBiography(detailForm)

        let bottom = Row.LeftAligned()
        detailForm <<< bottom

        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }
    }

    func loadPicture() {
        picture.height(30).width(30)
        picture.button.contentMode = .scaleAspectFit
        picture.button.backgroundColor = .clear
        if userInfo.icon != "" {
            DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
            picture.button.af_setBackgroundImage(for: .normal, url: URL(string: userInfo.icon)!, placeholderImage: UIImage(named: "downloading"))
        } else {
            picture.button.setBackgroundImage(UIImage(named: "pengin2"), for: .normal)
        }

    }


    func buildIdentity(_ section: Section) {

        var row = seperator(section: section, caption: "基本情報")

        section <<< row

        row = Row.LeftAligned()
        row.layout {
            r in
            r.height(120).fillHolizon()
        }

        let col1 = Col.UpDownAligned()
        col1.layout {
            c in
            c.leftMost().height(120).width(120)
        }
        col1 +++ picture
        picture.layout {
            p in
            p.fillParent(withInset: 30)
        }
        row +++ col1

        let col2 = Col.UpDownAligned()
        col2.layout {
            c in
            c.fillVertical().rightMost()
        }

        let idRow = Row.LeftAligned()
        idRow.layout {
            r in
            r.fillHolizon().height(25)
        }

        idRow +++ MQForm.label(name: "id", title: "ID:")
        idRow +++ idLabel.layout {
            l in
            l.label.textAlignment = .center
            l.rightMost(withInset: 10).height(25)
        }


        col2 +++ idRow

        let nameRow = Row.LeftAligned()
        nameRow.layout {
            r in
            r.fillHolizon().height(25)
        }

        nameRow +++ MQForm.label(name: "name", title: "名前")
        nameRow +++ nameLabel.layout {
            l in
            l.label.textAlignment = .center
            l.rightMost(withInset: 10).height(25).width(120)
        }


        col2 +++ nameRow

        let genderRow = Row.LeftAligned()
        genderRow.layout {
            r in
            r.fillHolizon().height(30)
        }

        genderRow +++ MQForm.label(name: "gender", title: "性別")
        genderRow +++ genderLabel.layout {
            l in
            l.label.textAlignment = .center
            l.rightMost(withInset: 10).height(25).width(120)
        }


        col2 +++ genderRow


        let ageGroupRow = Row.LeftAligned()
        ageGroupRow.layout {
            r in
            r.fillHolizon().height(30)
        }

        ageGroupRow +++ MQForm.label(name: "age-group", title: "年齢層")
        ageGroupRow +++ ageGroupLabel.layout {
            l in
            l.label.textAlignment = .center
            l.rightMost(withInset: 10).height(25).width(120)
        }

        col2 +++ ageGroupRow


        row +++ col2

        section <<< row


    }

    func buildSpeech(_ section: Section) {

        let row = seperator(section: section, caption: "One word of speech")

        section <<< row

        let row1 = Row.LeftAligned()
        row1.layout {
            r in
            r.height(50).fillHolizon()
        }
        row1.spacing = 10
        speech.textView.text = profile.oneWordSpeech
        row1 +++ speech.layout {
            s in
            s.fillParent(withInset: 5)
        }

        section <<< row1

    }

    func buildBiography(_ section: Section) {

        var row = seperator(section: section, caption: "Biography")


        section <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }

        row +++ MQForm.label(name: "constellationLabel", title: "星座").height(30).width(70)
        row +++ constellationLabel.layout {
            l in
            l.height(30).width(120)
            l.margin.left = 80
        }

        section <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }

        row +++ MQForm.label(name: "appearanceLabel", title: "外見").height(35).width(70)
        row +++ appearanceLabel.layout {
            l in
            l.height(30).width(120)
            l.margin.left = 80
        }

        section <<< row

        row = seperator(section: section, caption: "職業")

        section <<< row

        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(42)
        }
        row.spacing = 5
        section <<< row

        row +++ occupationLabel1
        row +++ occupationLabel2
        row +++ occupationLabel3

        row = seperator(section: section, caption: "趣味")

        section <<< row

        // Hobby Line1
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(42)
        }
        row.spacing = 5
        section <<< row

        row +++ hobbyLabel1
        row +++ hobbyLabel2
        row +++ hobbyLabel3

        // Hobby Line2
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(42)
        }
        row.spacing = 5
        section <<< row

        row +++ hobbyLabel4
        row +++ hobbyLabel5
        row +++ blank
    }

    /// <#Description#>
    ///
    /// - Parameter section: <#section description#>
    func buildSocialLinks(_ section: Section) {
        let row = seperator(section: section, caption: "ソーシャルID")

        section <<< row

        let row1 = Row.LeftAligned()
        row1.layout {
            r in
            r.height(30).fillHolizon()
        }
        row1 +++ MQForm.label(name: "Line", title: "LINE").layout {
            s in
            s.fillParent(withInset: 2)
        }

        section <<< row1

    }

    func buildNameCards(_ section: Section) {
        let row = seperator(section: section, caption: "名刺")

        section <<< row

        let row1 = Row.LeftAligned()
        row1.layout {
            r in
            r.bottomAlign(with: self.nameCardSection).fillHolizon()
        }

        row1 +++ nameCardSection

        section <<< row1

    }


    /// <#Description#>
    func setUserProfile() {

        // Basic Info
        idLabel.label.text = String(format: "%010d", userInfo.id)
        nameLabel.label.text = userInfo.userName
        genderLabel.label.text = profile.gender == "" ? "秘密" : gendre(of: profile.gender)?.value
        ageGroupLabel.label.text = profile.ageGroup == "" ? "秘密" : agegroup(of: profile.ageGroup)?.value
        if userInfo.icon != "" {
            picture.button.setMittyImage(url: userInfo.icon)
        }

        speech.textView.text = profile.oneWordSpeech

        // Biography
        constellationLabel.label.text = profile.constellation == "" ? "秘密" : CONSTELLATION(of: profile.constellation)?.value

        appearanceLabel.label.text = profile.appearanceTag == "" ? "秘密" : appearance(of: profile.appearanceTag)?.value

        occupationLabel1.label.text = profile.occupationTag1 == "" ? LS(key: "not-set") : occupation(of: profile.occupationTag1)?.value
        occupationLabel2.label.text = profile.occupationTag2 == "" ? LS(key: "not-set") : occupation(of: profile.occupationTag2)?.value
        occupationLabel3.label.text = profile.occupationTag3 == "" ? LS(key: "not-set") : occupation(of: profile.occupationTag3)?.value

        hobbyLabel1.label.text = profile.hobbyTag1 == "" ? LS(key: "not-set") : hobby(of: profile.hobbyTag1)?.value
        hobbyLabel2.label.text = profile.hobbyTag2 == "" ? LS(key: "not-set") : hobby(of: profile.hobbyTag2)?.value
        hobbyLabel3.label.text = profile.hobbyTag3 == "" ? LS(key: "not-set") : hobby(of: profile.hobbyTag3)?.value
        hobbyLabel4.label.text = profile.hobbyTag4 == "" ? LS(key: "not-set") : hobby(of: profile.hobbyTag4)?.value
        hobbyLabel5.label.text = profile.hobbyTag5 == "" ? LS(key: "not-set") : hobby(of: profile.hobbyTag5)?.value


    }

    func addCardList() {
        var last: Row? = nil
        for card in nameCardBox {
            let row = Row.LeftAligned().layout {
                r in
                r.height(30).fillHolizon()
            }

            row +++ MQForm.img(name: "businessLogo", url: "").layout {
                i in
                i.imageView.setMittyImage(url: card.businessLogoUrl)
                i.height(25).width(25).leftMost(withInset: 8)
            }
            row +++ MQForm.label(name: "namecard", title: card.businessName).layout {
                l in
                l.height(30).rightMost(withInset: 30).leftMargin(5)
                l.label.textColor = UIColor.orange
            }
            
            row +++ MQForm.tapableImg(name: "exchange", url: "excard").layout {
                l in
                l.rightMost(withInset: 8).width(22).height(20)
            }.bindEvent(.touchUpInside) {
                b in
                let vc = NamecardExchangeViewController()
                vc.contacteeCard = card
                vc.contacteeUser = self.userInfo
                self.navigationController?.pushViewController(vc, animated: true)
            }

            last = row
            nameCardSection <<< row
        }


        if (last != nil) {
            nameCardSection.layout {
                s in
                s.bottomAlign(with: last!).fillHolizon()
            }
            nameCardSection.configLayout()
            self.view.setNeedsUpdateConstraints()
        }
    }

}
