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

    var imageRow = Row()
    
    ///
    ///
    let acceptButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("受け入れ", for: .normal)
        return b
    } ()

    let confirmTel = MQForm.text(name: "confirmTel", placeHolder: "確認電話")
    let confirmMail = MQForm.text(name: "confirmMail", placeHolder: "メール")
    ///
    ///
    let refuseButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("遠慮する", for: .normal)

        return b
    } ()

    ///
    ///
    let approveButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("確定", for: .normal)

        return b
    } ()

    ///
    ///
    let rejectButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("取り止め", for: .normal)

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

        GalleryService.instance.galleryContents(of: proposal.galleryID, onCompletion: {
            list in
            if let g = list.first {
                self.setImage(g)
            }
        })

    }
    
    func setImage(_ gallery: GalleryContent) {
        
        let image = MQForm.img(name: "proposalImg", url: "")
        image.imageView.setMittyImage(url: gallery.linkURL)
        
        imageRow +++ image
        image.height(UIScreen.main.bounds.width).width(UIScreen.main.bounds.width)
        image.verticalCenter()
        imageRow.fillHolizon().height(UIScreen.main.bounds.width)
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
        }

        row +++ MQForm.label(name: "title-request", title: "リクエスト情報").layout {
            c in
            c.height(25).verticalCenter().leftMargin(10)
            c.leftMost(withInset: 20)
            let l = c.view as! UILabel
            l.textColor = MittyColor.healthyGreen
            l.font = .boldSystemFont(ofSize: 18)
        }
        detailForm <<< row
        detailForm <<< HL(MittyColor.healthyGreen, 1.2).leftMargin(10).rightMargin(10)

        row = Row.LeftAligned()

        row.layout {
            r in
            r.fillHolizon(0).height(25)
        }

        let titleLabel = MQForm.label(name: "Title", title: request.title).layout {
            l in
            l.fillHolizon(10).height(25).verticalCenter().leftMargin(10)
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
            l.width(35).height(35).fillHolizon(10).verticalCenter().leftMargin(10)
            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 15)
            (l.view as! UILabel).textColor = .gray
            (l.view as! UILabel).numberOfLines = 1
        }
        row +++ tagLabel
        detailForm <<< row

        row = Row.LeftAligned()

        let actionLabel = MQForm.label(name: "action", title: (request.desc)).layout {
            c in
            c.fillHolizon(10).verticalCenter().leftMargin(10)
            let l = c.view as! UILabel
            l.numberOfLines = 3
            l.textColor = .black
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
        }
        
        row +++ MQForm.label(name: "title-request", title: "提案内容").layout {
            c in
            c.height(25).verticalCenter().leftMargin(10)
            c.leftMost(withInset: 20)
            let l = c.view as! UILabel
            l.textColor = MittyColor.orange
            l.font = .boldSystemFont(ofSize: 18)
        }
        detailForm <<< row
        
        detailForm <<< HL(MittyColor.orange, 1.2).leftMargin(10).rightMargin(10)
        
        detailForm <<< imageRow
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }
        
        row +++ MQForm.label(name: "Term", title: "⏰").height(35).width(50).layout {
            l in
            l.verticalCenter().leftMargin(10)
        }
        
        let dates = MQForm.label(name: "preferedDate", title:proposal.term() ).layout { l in
            l.height(35).rightMost(withInset: 10).verticalCenter()
            l.margin.left = 20
            l.label.adjustsFontSizeToFitWidth = true
        }
        
        row +++ dates
        detailForm <<< row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }
        
        row +++ MQForm.label(name: "Price", title: "価格").height(35).width(50).layout {
            l in
            l.verticalCenter().leftMargin(10)
        }
        
        let price = MQForm.label( name: "price", title: proposal.price()).layout { l in
            l.height(35).rightMost(withInset: 10).verticalCenter()
            l.margin.left = 20
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
        }
        
        row +++ price
        
        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(40)
        }
        
        row +++ MQForm.label(name: "islandNamelabel", title: "📍").layout {
            l in
            l.verticalCenter().leftMargin(10)
        }
        
        row +++ MQForm.label(name: "islandName", title: proposal.islandName).layout {
            l in
            l.verticalCenter().leftMargin(5).rightMost(withInset: 10)
            l.label.numberOfLines = 2
            l.label.adjustsFontSizeToFitWidth = true
            l.label.textColor = UIColor.darkText
        }
        
        detailForm <<< row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(60)
        }

        let infoLabel = MQForm.label(name: "info", title: (proposal.additionalInfo)).layout {
            c in
            c.fillParent(withInset: 10).margin.all(10)
            let l = c.view as! UILabel
            l.numberOfLines = 0
            l.textColor = .black
            l.font = .systemFont(ofSize: 15)
            l.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
        }

        row +++ infoLabel
        detailForm <<< row

        
        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(35)
        }
        row.spacing = 30

        let likes = MQForm.label(name: "likes", title: "❤️ \(proposal.numberOfLikes) likes").layout { l in
            l.height(35).width(100).verticalCenter().leftMargin(5)
        }

        row +++ likes

        let likeButton = MQForm.button(name: "likeIt", title: "いいね").layout { b in
            b.height(30).verticalCenter()
            b.view.backgroundColor = .white
            b.view.layer.borderColor = UIColor.orange.cgColor
            b.view.layer.borderWidth = 0.7
            b.button.setTitleColor(UIColor.orange, for: .normal)
            b.button.setTitleColor(.gray, for: UIControlState.disabled)
        }
        
        var liked = false
        likeButton.bindEvent(.touchUpInside) { b in
            if liked {
                if self.proposal.numberOfLikes > 0 {
                    self.proposal.numberOfLikes -= 1
                }
                liked = false
                likes.label.text = "❤️ \(self.proposal.numberOfLikes) likes"
                LikesService.instance.removeLike("PROPOSAL", id: Int64(self.proposal.id))
                likeButton.button.setTitleColor(.blue, for: .normal)
            } else {
                self.proposal.numberOfLikes += 1
                likes.label.text = "❤️ \(self.proposal.numberOfLikes) likes"
                LikesService.instance.sendLike("PROPOSAL", id: Int64(self.proposal.id))
                likeButton.button.setTitleColor(.gray, for: .normal)
                liked = true
            }
        }
        
        row +++ likeButton
        
        detailForm <<< row

        let accept = Control(name: "accept", view: acceptButton).layout {
            c in
            c.height(40).verticalCenter()
//            c.button.setTitleColor(UIColor.orange, for: .normal)
        }.bindEvent(.touchUpInside) {
            b in
            self.pressAccept()
        }

        let refuse = Control(name: "refuse", view: refuseButton).layout {
            c in
            c.height(40).verticalCenter()
            c.button.setTitleColor(UIColor.white, for: .normal)
            c.button.backgroundColor = MittyColor.gray
        }.bindEvent(.touchUpInside) {
            b in
            self.pressRefuse()
        }

        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(40).upMargin(30)
        }
        row.spacing = 30

        // Proposerの場合
        if ApplicationContext.userSession.userId == proposal.proposerId
            && proposal.isApprovable {
            showConfirm(detailForm)
            
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
                c.button.backgroundColor = MittyColor.gray
            }.bindEvent(.touchUpInside) {
                b in
                self.pressReject()
            }

        } else if request.ownerId == ApplicationContext.userSession.userId && proposal.isAcceptable {
            showConfirm(detailForm)

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
            f.view.backgroundColor = MittyColor.white
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
    
    func showConfirm(_ section: Section) {

        section <<< Row.LeftAligned().height(10)
        
        seperator(section: section, caption: "確認情報", color: MittyColor.orange)

        let confirmRow = Row.Intervaled().height(50)
        confirmRow.spacing = 30
        confirmTel.textField.text = proposal.confirmTel
        confirmRow +++ confirmTel.height(40)
        
        confirmMail.textField.text = proposal.confirmEmail
        confirmRow +++ confirmMail.height(40)
        section <<< confirmRow
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
