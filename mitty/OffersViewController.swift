//
//  NamecardOffersViewController.swift
//  mitty
//
//  Created by gridscale on 2017/09/01.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class OffersViewController : MittyViewController {
    let form = MQForm.newAutoLayout()
    var offers = [Offer]()
    
    /// <#Description#>
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form.fillIn(vc: self)
        
        loadMyOffers {
           self.buildForm()
           self.form.configLayout()
           self.view.backgroundColor = .white
           self.view.setNeedsUpdateConstraints()
        }
    }
    
    func buildForm() {
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

        seperator(section: detailForm, caption: "名刺交換Offer")
        for offer in offers {
            let line1 = Row.LeftAligned().layout {
                row in
                row.fillHolizon().height(40)
            }
            let userName = MQForm.label(name: "name", title: "").layout {
                n in
                n.width(80).leftMargin(30).verticalCenter()
                n.label.textColor = MittyColor.healthyGreen
            }
            line1 +++ userName
            
            let userIcon = MQForm.img(name: "icon", url: "").layout {
                i in
                i.rightMost(withInset: 50).height(30).width(30).verticalCenter()
            }
            
            line1 +++ userIcon
            
            UserService.instance.getUserInfo(id: String(offer.fromMittyId)) {
                user, ok in
                if (ok) {
                    userName.label.text = user!.userName
                    userIcon.imageView.setMittyImage(url: user!.icon)
                }
            }
            
            detailForm <<< line1
            
            let line2 = Row.LeftAligned()
            let message = MQForm.label(name: "message", title: offer.message).layout {
                n in
                n.rightMost(withInset: 10).verticalCenter().leftMargin(30)
                n.label.numberOfLines = 3
                n.label.adjustsFontSizeToFitWidth = true
            }
            line2.layout {
                    row in
                    row.fillHolizon().bottomAlign(with: message)
            }
            line2 +++ message
            detailForm <<< line2
            
            let line3 = Row.Intervaled().layout() {
                l in
                l.fillHolizon().height(40)
            }
            line3.spacing = 30
            
            line3 +++ MQForm.button(name: "refuse", title: "拒否").layout{
                b in
                b.height(30)
                b.button.backgroundColor = MittyColor.healthyGreen
                b.button.setTitleColor(.white, for: .normal)
            }.bindEvent(.touchUpInside) {
                b in
                self.handleOffer(offer, "REFUESED")
                (b as! UIButton).isEnabled = false
                (b as! UIButton).backgroundColor = MittyColor.gray
                (b as! UIButton).setTitleColor(.lightGray, for: .normal)
            }
            
            line3 +++ MQForm.button(name: "ok", title: "承認").layout{
                b in
                b.height(30)
                b.button.backgroundColor = MittyColor.sunshineRed
                b.button.setTitleColor(.white, for: .normal)
            }.bindEvent(.touchUpInside) {
                b in
                self.handleOffer(offer, "ACCEPTED")
                (b as! UIButton).isEnabled = false
                
                (b as! UIButton).backgroundColor = MittyColor.gray
                (b as! UIButton).setTitleColor(.lightGray, for: .normal)
            }
            
            detailForm <<< line3
            
        }
        
        
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
    
    /// <#Description#>
    ///
    /// - Parameter onComplete: <#onComplete description#>
    func loadMyOffers(onComplete: @escaping () -> Void) {
        OffersService.instance.getMyOffers {
            offerList in
            self.offers.append(contentsOf: offerList)
            onComplete()
        }
    }
    
    //
    func handleOffer(_ offer: Offer, _ status: String) {
        OffersService.instance.accept(offer, status: status)
    }
}
