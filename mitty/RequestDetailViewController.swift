//
//  RequestDetailViewController.swift
//  mitty
//
//  Created by gridscale on 2017/07/08.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class RequestDetailViewController: MittyViewController, UITextFieldDelegate {

    var request: RequestInfo


    var form = MQForm.newAutoLayout()


    var proposals = [ProposalInfo]()
    var proposalSection = MQForm.section(name: "Proposals")

    ///
    ///
    let proposolButton: UIButton = {

        let b = UIButton.newAutoLayout()
        b.setTitle("提案", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .orange

        return b
    } ()


    init (req: RequestInfo) {
        self.request = req

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

        form.autoPin(toTopLayoutGuideOf: self, withInset: 10)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        form.configLayout()
        configNavigationBar()

        loadProposals()
        
        view.setNeedsUpdateConstraints()

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

    func buildform () {

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

        let titleLabel = MQForm.label(name: "Title", title: request.title).layout {
            l in
            l.verticalCenter().fillHolizon(10).leftMargin(5).height(50)
            l.view.backgroundColor = UIColor.white
            l.label.font = UIFont.boldSystemFont(ofSize: 24)
            l.label.textColor = MittyColor.healthyGreen
            l.label.numberOfLines = 2
            l.label.adjustsFontSizeToFitWidth = true
        }

        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(50)
        }

        row +++ titleLabel

        detailForm <<< row

        detailForm <<< HL(MittyColor.orange, 1.2).leftMargin(10).rightMargin(10)
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        let tagLabel = MQForm.label(name: "tag", title: "🏷 " + request.tag).layout {
            l in
            l.width(35).height(35).fillHolizon(10).verticalCenter().leftMargin(10)
            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 15)
            (l.view as! UILabel).textColor = .orange
            (l.view as! UILabel).numberOfLines = 1
        }
        row +++ tagLabel
        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(60)
        }

        let actionLabel = MQForm.label(name: "action", title: (request.desc)).layout {
            c in
            c.upper(withInset: 5).fillHolizon(10).leftMargin(10)
            let l = c.view as! UILabel
            l.numberOfLines = 0
            l.textColor = UIColor.darkGray
            l.font = .systemFont(ofSize: 15)
        }

        row +++ actionLabel
        detailForm <<< row

        row = Row.Intervaled().layout {
            r in
            r.height(40).fillHolizon()
        }
        
        let left = Row.LeftAligned().height(30)
        row +++ left
        left +++ MQForm.label(name: "likes1", title: "❤️").layout {
            l in
            l.width(25).height(25).leftMargin(10).verticalCenter()
        }
        left +++ MQForm.label(name: "likes2", title: "\(request.numberOfLikes) likes！").layout {
            l in
            l.height(25).width(80).leftMargin(5).verticalCenter()
            let label = l.label
            label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
            label.textAlignment = .left
        }
        
        var right = Row.LeftAligned().layout {
            r in
            r.height(30).verticalCenter()
        }
        row +++ right
        
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
            LikesService.instance.sendLike("REQUEST", id: Int64(self.request.id))
            (b as! UIButton).isEnabled = false
        }
        
        right +++ likeButton
        
        detailForm <<< row
        
        row = Row.Intervaled().layout {
            r in
            r.height(40).fillHolizon()
        }
        
        let expiryRow = Row.LeftAligned().height(30)
        row +++ expiryRow
        
        expiryRow +++ MQForm.label(name: "expiryLabel", title: "締切").layout {
            l in
            l.verticalCenter().leftMargin(10)
        }
        
        expiryRow +++ MQForm.label(name: "expiryDate", title: request.expiryDate.ymd).layout {
            l in
            l.verticalCenter().leftMargin(15).height(30).width(100)
        }
        
        right = Row.LeftAligned().layout {
            r in
            r.height(30).verticalCenter()
        }
        row +++ right
        
        
        let expiryDays = request.expiryDate.timeIntervalSinceNow / 84600
        let expiryLabel = expiryDays<0 ? "期限過ぎ" : "締切まで\(Int(expiryDays))日"
        let expiry = MQForm.label(name: "expiry", title: expiryLabel)
        
        right +++ expiry.layout {
            e in
            e.rightMargin(10).bottomMargin(3).verticalCenter().width(140)
            e.label.adjustsFontSizeToFitWidth = true
            e.label.textColor = MittyColor.orange
        }
        
        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35).upMargin(10)
        }

        row +++ MQForm.label(name: "Term", title: "希望期間").height(35).width(100).layout {
            l in
            l.verticalCenter().leftMargin(10)
        }
        let dates = MQForm.label(name:"preferedDate", title: request.term()).layout { l in
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

        row +++ MQForm.label(name: "Location", title: "希望エリア").height(35).width(100).layout {
            l in
            l.verticalCenter().leftMargin(10)
        }

        let location = MQForm.label(name: "isLand", title: "\(request.startPlace)").layout { l in
            l.height(35).width(180).verticalCenter()
            l.margin.left = 20
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
        }

        row +++ location

        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        row +++ MQForm.label(name: "Price", title: "希望価格").height(35).width(100).layout {
            l in
            l.verticalCenter().leftMargin(10)
        }

        let price = MQForm.label(name: "price", title: request.price()).layout { l in
            l.height(35).width(180).verticalCenter()
            l.margin.left = 20
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
        }

        row +++ price

        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        row +++ MQForm.label(name: "NumberOfPerson", title: "参加人数").height(35).width(100).layout {
            l in
            l.verticalCenter().leftMargin(10)
        }

        let nop = MQForm.label(name:"NumberOfPerson", title: request.nop()).layout { l in
            l.height(35).width(180).verticalCenter()
            l.margin.left = 20
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
        }

        row +++ nop

        detailForm <<< row

        // TODO 提案がないなら、何かを表示。　リクエストした人の場合は、表示内容がちょっと違うでしょう。

        // 提案者、　島名、　提案内容
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().bottomAlign(with: self.proposalSection)
        }

        row +++ proposalSection.layout{
            p in
            p.upper()
        }

        detailForm <<< row

        let proposol = Control(name: "scbscribe", view: proposolButton).layout {
            c in
            c.height(40).verticalCenter()
            c.button.setTitleColor(UIColor.white, for: .normal)
        }


        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(50).upMargin(30)
        }
        row.spacing = 100

        row +++ proposol

        detailForm <<< row

        proposol.bindEvent(.touchUpInside) {
            b in
            let button = b as! UIButton
            self.pressProposol(sender: button)
        }

        let bottom = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }

        detailForm <<< bottom

        detailForm.layout {
            f in
            f.fillParent().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }
    }


    func pressProposol (sender: UIButton) {
        let vc = ProposalViewController()
        vc.relatedRequest = request
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func loadProposals() {
        ProposalService.instance.getProposalsOf(reqId: request.id, callback: {
            proposalList in
            self.proposals = proposalList

            self.setProposals()

        })
    }

    func setProposals() {

        if proposals.count > 0 {
            let row = Row.LeftAligned()
            
            row.layout {
                r in
                r.fillHolizon(0).height(25)
            }
            
            row +++ MQForm.label(name: "title-proposals", title: "提案一覧").layout {
                c in
                c.height(30).verticalCenter().leftMargin(10)
                c.leftMost(withInset: 20)
                let l = c.view as! UILabel
                l.textColor = MittyColor.orange
                l.font = .boldSystemFont(ofSize: 18)
            }
            
            proposalSection <<< row
            proposalSection <<< HL(MittyColor.orange, 1.2).leftMargin(10).rightMargin(10)
            
            proposalSection <<< Row.LeftAligned().height(20)
        }

        for p in proposals {
            let row = Row.LeftAligned().layout {
                r in
                r.fillHolizon().height(35)
            }

            
            row +++ MQForm.tapableImg(name: "icon", url: "").layout {
                img in
                img.imageView.setMittyImage(url: p.proposerIconUrl)
                img.height(32).width(32).verticalCenter()
                img.margin.left = 10
            }.bindEvent(.touchUpInside) {
                r in
                let vc = ProfileViewController()
                vc.mittyId = p.proposerId
                self.navigationController?.pushViewController(vc, animated: true)
            }


            row +++ MQForm.label(name: "proposal", title: p.islandName).layout {
                p in
                p.margin.left = 10
                p.label.numberOfLines = 0
                p.rightMost(withInset: 100).verticalCenter()
            }.bindEvent(.touchUpInside) {
                    r in
                    let vc = ProposalDetailsViewController()
                    vc.proposal = p
                    vc.request = self.request
                    self.navigationController?.pushViewController(vc, animated: true)
            }

            row +++ MQForm.label(name: "likes", title: "❤️ \(p.numberOfLikes)").layout {
                l in
                l.rightMost(withInset: 5).verticalCenter()
                l.label.adjustsFontSizeToFitWidth = true
                l.label.minimumScaleFactor = 0.5
                l.label.textAlignment = .center
            }
            
            proposalSection <<< row
            
            let infoRow = Row.LeftAligned().height(50)
            infoRow +++ MQForm.label(name: "info", title: p.proposerInfo).layout{
                l in
                l.verticalCenter()
            }
            
            proposalSection <<< infoRow
        }
        proposalSection.layout {
            s in
            s.fillHolizon()
        }
        proposalSection.configLayout()
        proposalSection.view.backgroundColor = UIColor.white
        view.setNeedsUpdateConstraints()
    }
}
