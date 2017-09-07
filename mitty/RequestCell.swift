//
//  RequestCell.swift
//  mitty
//
//  Created by gridscale on 2017/07/06.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//
import Foundation
import UIKit
import PureLayout

class RequestCell: UICollectionViewCell {
    static let id = "request-search-result-cell"

    // MARK: - View Elements
    var request: RequestInfo?

    var form = MQForm.newAutoLayout()

    // MARK: - Initializers
    override init(frame: CGRect) {

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addConstraints() {


    }

    func configureView(req: RequestInfo) {

        self.request = req
        form = MQForm.newAutoLayout()
        self.addSubview(form)
        form.autoPinEdgesToSuperviewEdges()

        let section = Section(name: "request-cell", view: UIView.newAutoLayout())
        section.layout {
            s in
            s.fillParent()
        }
        form +++ section

        // 誰かポストしたのか
        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(30)
            r.view.backgroundColor = MittyColor.lightYellow.withAlphaComponent(0.15)
        }

        let publisherIcon = MQForm.img(name: "pushlisherIcon", url: "")

        publisherIcon.imageView.setMittyImage(url: req.ownerIconUrl)
        row +++ publisherIcon.width(30).height(30)

        let publisher = MQForm.label(name: "publisher", title: req.ownerName)
        row +++ publisher.layout {
            pub in
            pub.upMargin(5).leftMargin(5)
            let l = pub.label
            l.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.textColor = MittyColor.healthyGreen
        }


        let published = MQForm.label(name: "days", title: req.requestDays())

        row +++ published.layout {
            pub in
            pub.leftMargin(5).upMargin(5)
            let l = pub.label
            l.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
            l.textColor = UIColor.black
        }

        section <<< row

        // タイトルを表示
        // logoがある場合ロゴを表示
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(50)
        }
        
        let titleLabel = MQForm.label(name: "titleLabel", title: req.title).layout { t in
            t.label.numberOfLines = 2
            t.label.font = UIFont.boldSystemFont(ofSize: 18)
            t.rightMost().height(50)
            t.label.textColor = MittyColor.healthyGreen
        }
        row +++ titleLabel
        section <<< row

        // リクエスト情報を設定
        row = Row.LeftAligned()
        let actionLabel = UILabel.newAutoLayout()
        actionLabel.text = req.desc
        let actionCtrl = Control(name: "actionLabel", view: actionLabel).layout {
            l in
            l.fillHolizon(10)
            l.label.font = UIFont.systemFont(ofSize: 12)
            l.label.textColor = UIColor(white: 0.33, alpha: 1)
            l.label.numberOfLines = 0
        }
        row.layout {
            r in
            r.fillHolizon().bottomAlign(with: actionCtrl)
        }
        row +++ actionCtrl
        section <<< row

        
        row = Row.Intervaled().layout {
            r in
            r.height(40)
        }
        
        let left = Row.LeftAligned().height(30)
        row +++ left
        left +++ MQForm.label(name: "likes1", title: "❤️").layout {
            l in
            l.width(25).height(25).leftMargin(10)
        }
        left +++ MQForm.label(name: "likes2", title: "\(request?.numberOfLikes ?? 0) いいね！").layout {
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
        
        let expiryDays = (request?.expiryDate.timeIntervalSinceNow)! / 84600
        let expiry = MQForm.hilight(label: "\(Int(-expiryDays)) days before expiry", named: "expiry")
        
        right +++ expiry.layout {
            e in
            e.rightMargin(10).bottomMargin(3)
            e.label.adjustsFontSizeToFitWidth = true
        }
    
        section <<< row
        
        form.configLayout()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for v in contentView.subviews {
            v.removeFromSuperview()
        }
        form.removeFromSuperview()
    }
}
