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
            l.leftMost(withInset: 25).upper(withInset: 40).fillHolizon(10)
            l.view.backgroundColor = UIColor.white
            l.label.font = UIFont.boldSystemFont(ofSize: 24)
            l.label.textColor = MittyColor.healthyGreen
            l.label.numberOfLines = 0
            l.label.adjustsFontSizeToFitWidth = true
        }

        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        row +++ titleLabel

        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        let tagLabel = MQForm.label(name: "tag", title: "🏷 " + request.tag).layout {
            l in
            l.width(35).height(35).putUnder(of: titleLabel).fillHolizon(10).height(20)
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
            c.putUnder(of: tagLabel, withOffset: 5).fillHolizon(10).leftMargin(10)
            let l = c.view as! UILabel
            l.numberOfLines = 0
            l.textColor = UIColor.darkGray
            l.font = .systemFont(ofSize: 15)
            l.layer.cornerRadius = 2
            l.layer.borderWidth = 0.8
            l.layer.borderColor = UIColor.gray.cgColor
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
            l.width(25).height(25).leftMargin(10)
        }
        left +++ MQForm.label(name: "likes2", title: "\(request.numberOfLikes) いいね！").layout {
            l in
            l.height(25).width(80).leftMargin(5)
            let label = l.label
            label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
            label.textAlignment = .left
        }
        
        let right = Row.LeftAligned().layout {
            r in
            r.height(30)
        }
        row +++ right
        
        let expiryDays = (request.expiryDate.timeIntervalSinceNow) / 84600
        let expiry = MQForm.hilight(label: "\(Int(-expiryDays)) days before expiry", named: "expiry")
        
        right +++ expiry.layout {
            e in
            e.rightMargin(10).bottomMargin(3)
            e.label.adjustsFontSizeToFitWidth = true
        }
        
        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35).upMargin(10)
        }

        row +++ MQForm.label(name: "Term", title: "希望期間").height(35).width(100)
        let dates = MQForm.hilight(label: request.term(), named: "preferedDate").layout { l in
            l.height(35).width(180)
            l.margin.left = 20
            l.label.adjustsFontSizeToFitWidth = true
        }

        row +++ dates
        detailForm <<< row

        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(35)
        }

        row +++ MQForm.label(name: "Location", title: "希望エリア").height(35).width(100)
        let location = MQForm.hilight(label: "\(request.startPlace)", named: "isLand").layout { l in
            l.height(35).width(180)
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

        row +++ MQForm.label(name: "Price", title: "希望価格").height(35).width(100)
        let price = MQForm.hilight(label: request.price(), named: "price").layout { l in
            l.height(35).width(180)
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

        row +++ MQForm.label(name: "NumberOfPerson", title: "参加人数").height(35).width(100)
        let nop = MQForm.hilight(label: request.nop(), named: "NumberOfPerson").layout { l in
            l.height(35).width(180)
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

        row +++ proposalSection

        detailForm <<< row

        let proposol = Control(name: "scbscribe", view: proposolButton).layout {
            c in
            c.height(40).upMargin(30)
            c.button.setTitleColor(UIColor.white, for: .normal)
        }


        row = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(50)
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
            let row = seperator(section: proposalSection, caption: "提案一覧")
            row.margin.all(1)
        }

        for p in proposals {
            let row = Row.LeftAligned().layout {
                r in
                r.fillHolizon().height(35)
            }

            
            row +++ MQForm.tapableImg(name: "icon", url: "").layout {
                img in
                img.imageView.setMittyImage(url: p.proposerIconUrl)
                img.height(32).width(32)
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
                p.label.textColor = MittyColor.healthyGreen
                p.label.adjustsFontSizeToFitWidth = true
                p.label.minimumScaleFactor = 0.5
                p.rightMost(withInset: 100)
            }

            row +++ MQForm.label(name: "likes", title: "❤️ \(p.numberOfLikes)").layout {
                l in
                l.rightMost(withInset: 5)
                l.label.adjustsFontSizeToFitWidth = true
                l.label.minimumScaleFactor = 0.5
                l.label.textAlignment = .center
            }.bindEvent(.touchUpInside) {
                r in
                let vc = ProposalDetailsViewController()
                vc.proposal = p
                vc.request = self.request
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            proposalSection <<< row
            
            let infoRow = Row.LeftAligned().height(50)
            infoRow +++ MQForm.label(name: "info", title: p.proposerInfo).layout{
                l in
                l.margin.all(3)
            }
            
            proposalSection <<< infoRow
        }
        proposalSection.layout {
            s in
            s.fillHolizon()
        }
        proposalSection.configLayout()
        proposalSection.view.backgroundColor = MittyColor.lightYellow.withAlphaComponent(0.30)
        view.setNeedsUpdateConstraints()
    }
}
