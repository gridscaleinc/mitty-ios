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

class RequestDetailViewController: UIViewController, UITextFieldDelegate {
    
    var request : RequestInfo
    var images = ["event1", "event6", "event4","event10.jpeg","event5", "event9.jpeg"]
    
    
    var form = MQForm.newAutoLayout()
    
    
    
    ///
    ///
    let proposolButton : UIButton = {
        
        let b = UIButton.newAutoLayout()
        b.setTitle("提案", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .orange
        
        return b
    } ()
    
    
    init (req: RequestInfo) {
        self.request = req
        
        super.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        form.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)
        let anchor = MQForm.label(name: "dummy", title: "").layout {
            a in
            a.height(0).leftMost().rightMost()
        }
        form +++ anchor
        
        // スクロールViewを作る
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:900)
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
            l.view.backgroundColor = MittyColor.healthyGreen
            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 24)
            (l.view as! UILabel).textColor = .white
            (l.view as! UILabel).numberOfLines = 0
        }
        
        detailForm +++ titleLabel
        
        let tagLabel = MQForm.label(name: "tag", title: "🏷 " + request.tag).layout {
            l in
            l.width(35).height(35).putUnder(of: titleLabel).fillHolizon(10).height(20)
            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 15)
            (l.view as! UILabel).textColor = .gray
            (l.view as! UILabel).numberOfLines = 1
        }
        detailForm +++ tagLabel
        
        
        let actionLabel = MQForm.label(name: "action", title: (request.desc)).layout {
            c in
            c.putUnder(of: tagLabel, withOffset: 5).fillHolizon(10)
            let l = c.view as! UILabel
            l.numberOfLines = 0
            l.textColor = .black
            l.font = .systemFont(ofSize: 15)
            l.layer.cornerRadius = 2
            l.layer.borderWidth = 0.8
            l.layer.borderColor = UIColor.gray.cgColor
            l.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
        }
        
        detailForm +++ actionLabel
        
        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: actionLabel, withOffset: 5).height(35)
        }
        
        let likes = MQForm.label(name: "heart", title: "❤️ request.likes" ).layout { l in
            l.height(35).width(330)
        }
        
        row +++ likes
        
        detailForm +++ row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: likes, withOffset: 5).height(35)
        }
        
        row +++ MQForm.label(name: "Term", title: "希望期間:").height(35)
        let dates = MQForm.label(name: "preferedDate", title: request.term()).layout { l in
            l.height(35).width(250)
            l.label.adjustsFontSizeToFitWidth = true
            l.label.textColor = UIColor(white: 0.33, alpha: 1)
        }
        
        row +++ dates
        detailForm +++ row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: dates, withOffset: 5).height(35)
        }
        
        row +++ MQForm.label(name: "Location", title: "希望エリア:").height(35)
        let location = MQForm.label(name: "isLand", title: "\(request.startPlace)").layout { l in
            l.height(35).width(210)
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
        }
        
        row +++ location
        
        detailForm +++ row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: location, withOffset: 5).height(35)
        }
        
        row +++ MQForm.label(name: "Price", title: "希望価格:").height(35)
        let price = MQForm.label(name: "price", title: request.price()).layout { l in
            l.height(35).width(210)
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
        }
        
        row +++ price
        
        detailForm +++ row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: price, withOffset: 5).height(35)
        }
        
        row +++ MQForm.label(name: "NumberOfPerson", title: "人数:").height(35)
        let nop = MQForm.label(name: "NumberOfPerson", title: request.nop()).layout { l in
            l.height(35).width(210)
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
        }
        
        row +++ nop
        
        detailForm +++ row
        
        let proposol = Control(name: "scbscribe", view: proposolButton).layout {
            c in
            c.height(45).holizontalCenter().width(140).putUnder(of: nop, withOffset: 30)
        }
        
        detailForm +++ proposol
        
        proposol.bindEvent(.touchUpInside) {
            b in
            let button = b as! UIButton
            self.pressProposol(sender: button)
        }
        
        let bottom = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: proposol, withOffset: 5)
        }
        
        detailForm +++ bottom

        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }
    }
    
    
    func pressProposol (sender:UIButton){
        let vc = ProposalViewController()
        vc.relatedRequest = request
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
