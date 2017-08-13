//
//  PersonalInfoViewController
//  mitty
//
//  Created by gridscale on 2017/04/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class PersonalInfoViewController: MittyViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var userInfo = UserInfo()
    var profile = Profile()
    var socialIdList = [SocialId]()
    var nameCardBox = [NameCard]()

    var form = MQForm.newAutoLayout()

    let picture: Control = MQForm.button(name: "m2", title: "aa")
    let signOut: Control = MQForm.button(name: "signOut", title: "Sign Out")

    let idLabel = MQForm.label(name: "mitty-id", title: "")
    let nameLabel = MQForm.label(name: "name", title: "秘密")
    let genderLabel = MQForm.label(name: "gender", title: "秘密")
    let ageGroupLabel = MQForm.label(name: "age-group", title: "秘密")

    let sppeech = MQForm.textView(name: "speech")

    let constellationLabel = MQForm.label(name: "constellation", title: "秘密")

    let homeIslandLabel = MQForm.label(name: "home-island", title: "秘密")
    let birthIslandLabel = MQForm.label(name: "birth-island", title: "秘密")

    let appearanceLabel = MQForm.label(name: "appearence", title: "秘密")

    let occupationLabel1 = MQForm.label(name: "occupation1", title: "未設定")
    let occupationLabel2 = MQForm.label(name: "occupation2", title: "未設定")
    let occupationLabel3 = MQForm.label(name: "occupation3", title: "未設定")

    let hobbyLabel1 = MQForm.label(name: "hobby1", title: "未設定")
    let hobbyLabel2 = MQForm.label(name: "hobby2", title: "未設定")
    let hobbyLabel3 = MQForm.label(name: "hobby3", title: "未設定")
    let hobbyLabel4 = MQForm.label(name: "hobby4", title: "未設定")
    let hobbyLabel5 = MQForm.label(name: "hobby5", title: "未設定")

    let nameCardSection = Section(name: "namecard-section")
    let socialIdSection = Section(name: "social-id-section")


    override func viewDidLoad() {
        super.viewDidLoad()

        super.autoCloseKeyboard()

        self.view.backgroundColor = UIColor.white

        buildform()
        self.view.addSubview(form)


        picture.bindEvent(.touchUpInside) {
            p in
            self.pickImage()
        }


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

        scrollContainer +++ detailForm

        loadPicture()


        // bild Identity
        buildIdentity(detailForm)

        // build Speech
        buildSpeech(detailForm)

        // build biography
        buildBiography(detailForm)

        // build Social Links
        buildSocialLinks(detailForm)

        // build name cards
        buildNameCards(detailForm)

        let row = Row.Intervaled().height(40)
        row.spacing = 90
        row +++ signOut.layout {
            b in
            b.height(40)
        }.bindEvent(.touchUpInside) { _ in
            ApplicationContext.killSession()
        }

        detailForm <<< row

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
        if userInfo.icon != "" {
            DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
            picture.button.af_setImage(for: .normal, url: URL(string: userInfo.icon)!, placeholderImage: UIImage(named: "downloading"))
        } else {
            picture.button.setImage(UIImage(named: "pengin2"), for: .normal)
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
        let iconimage = chosenImage.af_imageScaled(to: CGSize(width: 80, height: 80))
        self.dismiss(animated: false, completion: nil)

        // upload
        ContentService.instance.uploadContent(img: iconimage) {
            contentId in
            UserService.instance.setUserIcon(contentId)
        }

    }

    func buildIdentity(_ section: Section) {

        var row = seperator(section: section, caption: "基本情報", LeftRight.left)

        row +++ MQForm.img(name: "aaa", url: "editpen").layout {
            i in
            i.rightMost().height(20).width(20)
        }

        row.bindEvent(.touchUpInside) {
            v in
            let vc = EditBasicInfoViewController(self.profile)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        section <<< row

        row = Row.LeftAligned()
        row.layout {
            r in
            r.height(100).fillHolizon()
        }

        let col1 = Col.UpDownAligned()
        col1.layout {
            c in
            c.leftMost().height(100).width(100)
        }
        col1 +++ picture
        picture.layout {
            p in
            p.fillParent()
        }
        row +++ col1

        let col2 = Col.UpDownAligned()
        col2.layout {
            c in
            c.righter(than: self.picture).rightMost()
            c.topAlign(with: self.picture)
            c.height(100)
        }

        let idRow = Row.LeftAligned()
        idRow.layout {
            r in
            r.fillHolizon().height(20)
        }

        idRow +++ MQForm.label(name: "id", title: "ID:")

        col2 +++ idRow

        let nameRow = Row.LeftAligned()
        nameRow.layout {
            r in
            r.fillHolizon().height(20)
        }

        nameRow +++ MQForm.label(name: "name", title: "名前:")
        col2 +++ nameRow

        let genderRow = Row.LeftAligned()
        genderRow.layout {
            r in
            r.fillHolizon().height(20)
        }

        genderRow +++ MQForm.label(name: "gender", title: "性別:")
        col2 +++ genderRow


        let ageGroupRow = Row.LeftAligned()
        ageGroupRow.layout {
            r in
            r.fillHolizon().height(20)
        }

        ageGroupRow +++ MQForm.label(name: "age-group", title: "年齢層:")
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
        row1 +++ sppeech.layout {
            s in
            s.fillParent(withInset: 2)
        }

        section <<< row1

    }

    func buildBiography(_ section: Section) {

        var row = seperator(section: section, caption: "Biography", LeftRight.left)

        row +++ MQForm.img(name: "aaa", url: "editpen").layout {
            i in
            i.rightMost().height(20).width(20)
        }
        row.bindEvent(.touchUpInside) {
            r in
            let vc = EditBiographyViewController(self.profile)
            self.navigationController?.pushViewController(vc, animated: true)

        }
        section <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }

        row +++ MQForm.label(name: "constellationLabel", title: "星座").height(38).width(70)
        row +++ constellationLabel.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }

        section <<< row
        section <<< HL(.gray, 0.4)

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }

        row +++ MQForm.label(name: "appearanceLabel", title: "外見").height(38).width(70)
        row +++ appearanceLabel.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }

        section <<< row

        row = Row.LeftAligned()
        row.layout {
            r in
            r.height(20).fillHolizon()
        }

        row = seperator(section: section, caption: "職業")

        section <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }
        row +++ MQForm.label(name: "occupationLabel1", title: "職業1").height(38).width(70)
        row +++ occupationLabel1.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }
        section <<< row
        section <<< HL(.gray, 0.4)

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }
        row +++ MQForm.label(name: "occupationLabel2", title: "職業2").height(38).width(70)
        row +++ occupationLabel2.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }
        section <<< row
        section <<< HL(.gray, 1.0)

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }
        row +++ MQForm.label(name: "occupationLabel3", title: "職業3").height(38).width(70)
        row +++ occupationLabel3.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }
        section <<< row

        row = seperator(section: section, caption: "趣味")

        section <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }
        row +++ MQForm.label(name: "occupationLabel1", title: "趣味1").height(38).width(70)
        row +++ hobbyLabel1.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }
        section <<< row
        section <<< HL(.gray, 0.4)

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }
        row +++ MQForm.label(name: "hobbyLabel2", title: "趣味2").height(38).width(70)
        row +++ hobbyLabel2.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }
        section <<< row
        section <<< HL(.gray, 1.0)

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }
        row +++ MQForm.label(name: "hobbyLabel3", title: "趣味3").height(38).width(70)
        row +++ hobbyLabel3.layout {
            l in
            l.height(38).rightMost(withInset: 10)
            l.label.textAlignment = .right
        }
        section <<< row

    }


    func buildSocialLinks(_ section: Section) {
        let row = seperator(section: section, caption: "ソーシャルID", LeftRight.left)

        row +++ MQForm.img(name: "aaa", url: "editpen").layout {
            i in
            i.rightMost().height(20).width(20)
        }

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
        let row = seperator(section: section, caption: "名刺", LeftRight.left)
        row +++ MQForm.img(name: "aaa", url: "editpen").layout {
            i in
            i.rightMost().height(20).width(20)
        }

        section <<< row

        let row1 = Row.LeftAligned()
        row1.layout {
            r in
            r.height(30).fillHolizon()
        }
        row1 +++ MQForm.label(name: "namecard", title: "グリッドスケール株式会社").layout {
            s in
            s.fillParent(withInset: 2)
        }

        section <<< row1

    }



}

