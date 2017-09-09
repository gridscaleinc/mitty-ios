//
//  ProposalDetailsViewController.swift
//  mitty
//
//  Created by gridscale on 2017/08/24.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MapKit


/// <#Description#>
class ProposalDetailsViewController: MittyViewController {
    var proposal: ProposalInfo!
    var request: RequestInfo!

    let form = MQForm.newAutoLayout()

    ///
    ///
    let acceptButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("受け入れ", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .orange

        return b
    } ()

    let confirmTel = MQForm.text(name: "confirmTel", placeHolder: "確認電話")
    let confirmMail = MQForm.text(name: "confirmMail", placeHolder: "メール")
    ///
    ///
    let refuseButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("遠慮する", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .orange

        return b
    } ()

    ///
    ///
    let approveButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("確定", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .orange

        return b
    } ()

    ///
    ///
    let rejectButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("取り止め", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .orange

        return b
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        super.autoCloseKeyboard()

        self.view.backgroundColor = UIColor.white

        buildForm()
        self.view.addSubview(form)

        form.autoPin(toTopLayoutGuideOf: self, withInset: 10)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        form.configLayout()
        configNavigationBar()


    }

    func buildForm () {
//        form.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)
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
            c.height(25).verticalCenter()
            c.leftMost(withInset: 20)
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

        let titleLabel = MQForm.label(name: "Title", title: request.title).layout {
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
        let tagLabel = MQForm.label(name: "tag", title: "🏷 " + request.tag).layout {
            l in
            l.width(35).height(35).fillHolizon(10).verticalCenter()
            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 15)
            (l.view as! UILabel).textColor = .gray
            (l.view as! UILabel).numberOfLines = 1
        }
        row +++ tagLabel
        detailForm <<< row

        row = Row.LeftAligned()

        let actionLabel = MQForm.label(name: "action", title: (request.desc)).layout {
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

        seperator(section: detailForm, caption: "提案内容")

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(60)
        }

        let infoLabel = MQForm.label(name: "info", title: (proposal.proposerInfo)).layout {
            c in
            c.fillParent().margin.all(4)
            let l = c.view as! UILabel
            l.numberOfLines = 0
            l.textColor = .black
            l.font = .systemFont(ofSize: 15)
            l.layer.cornerRadius = 2
            l.layer.borderWidth = 0.8
            l.layer.borderColor = UIColor.white.cgColor
            l.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
        }

        row +++ infoLabel
        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        let likes = MQForm.label(name: "likes", title: "❤️ \(proposal.numberOfLikes)").layout { l in
            l.height(35).width(330).verticalCenter()
        }

        row +++ likes

        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        row +++ MQForm.label(name: "Term", title: "期間").height(35).width(100)
        let dates = MQForm.hilight(label: proposal.term(), named: "preferedDate").layout { l in
            l.height(35).width(180).verticalCenter()
            l.margin.left = 20
            l.label.adjustsFontSizeToFitWidth = true
        }

        row +++ dates
        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        row +++ MQForm.label(name: "Price", title: "価格").height(35).width(100).layout {
            l in
            l.verticalCenter()
        }

        let price = MQForm.hilight(label: proposal.price(), named: "price").layout { l in
            l.height(35).width(180)
            l.margin.left = 20
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
        }

        row +++ price

        detailForm <<< row


        let accept = Control(name: "accept", view: acceptButton).layout {
            c in
            c.height(40).verticalCenter()
            c.button.setTitleColor(UIColor.orange, for: .normal)
        }.bindEvent(.touchUpInside) {
            b in
            self.pressAccept()
        }

        let refuse = Control(name: "refuse", view: refuseButton).layout {
            c in
            c.height(40).verticalCenter()
            c.button.setTitleColor(UIColor.white, for: .normal)
            c.button.backgroundColor = MittyColor.lightYellow
        }.bindEvent(.touchUpInside) {
            b in
            self.pressRefuse()
        }

        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(50).upMargin(30)
        }
        row.spacing = 30

        // Requesterの場合
        if ApplicationContext.userSession.userId == Int64(proposal.proposerId)
            && proposal.isApprovable {
            row +++ Control(name: "approve", view: approveButton).layout {
                c in
                c.height(40)
                c.button.setTitleColor(UIColor.white, for: .normal)
            }.bindEvent(.touchUpInside) {
                b in
                self.pressApprove()
            }

            row +++ Control(name: "deny", view: rejectButton).layout {
                c in
                c.height(40)
                c.button.setTitleColor(UIColor.white, for: .normal)
                c.button.backgroundColor = MittyColor.lightYellow
            }.bindEvent(.touchUpInside) {
                b in
                self.pressReject()
            }

        } else if request.ownerId == ApplicationContext.userSession.userId && proposal.isAcceptable {
            seperator(section: detailForm, caption: "連絡情報（受入の場合必要）")
            let confirmRow = Row.Intervaled().height(50)
            confirmRow.spacing = 30
            confirmRow +++ confirmTel.height(40)
            confirmRow +++ confirmMail.height(40)
            detailForm <<< confirmRow

            row +++ accept
            row +++ refuse
        }


        detailForm <<< row


        let bottom = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }

        detailForm <<< bottom

        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = MittyColor.lightYellow.withAlphaComponent(0.2)
        }
    }

    func configNavigationBar() {
        // TODO: 他の画面への影響をなくす。この画面から出たら、モドに戻す。
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.black

        self.navigationController?.view.backgroundColor = .clear
        //        self.navigationController?.navigationBar.isHidden = true
    }

    func pressAccept () {
        if confirmMail.textField.text == "" && confirmTel.textField.text == "" {
            self.showError("連絡情報を入力してください。")
            return
        }

        proposal.confirmEmail = confirmMail.textField.text ?? ""
        proposal.confirmTel = confirmTel.textField.text ?? ""

        ProposalService.instance.accept(proposal, status: .Accepted, onSuccess: {
            self.showError("受け入れました")
        }, onError: {
            error in
            self.showError(error)
        })

    }

    func pressRefuse () {
        ProposalService.instance.accept(proposal, status: .Refused, onSuccess: {
            self.showError("拒否しました")
        }, onError: {
            error in
            self.showError(error)
        })
    }

    func pressApprove () {
        ProposalService.instance.approve(proposal, status: .Approved, onSuccess: {
            self.showError("承認しました")
        }, onError: {
            error in
            self.showError(error)
        })
    }

    func pressReject () {
        ProposalService.instance.approve(proposal, status: .Rejected, onSuccess: {
            self.showError("否認しました")
        }, onError: {
            error in
            self.showError(error)
        })

    }
}
