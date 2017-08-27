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
        }

        let publisherIcon = MQForm.img(name: "pushlisherIcon", url: "")

        publisherIcon.imageView.setMittyImage(url: req.ownerIconUrl)
        row +++ publisherIcon.width(30).height(30)

        let publisher = MQForm.label(name: "publisher", title: req.ownerName)
        row +++ publisher.layout {
            pub in
            let l = pub.label
            l.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.textColor = MittyColor.healthyGreen
        }


        let published = MQForm.label(name: "days", title: req.requestDays())

        row +++ published.layout {
            pub in
            let l = pub.label
            l.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
            l.textColor = UIColor.black
        }

        section <<< row

        // タイトルを表示
        // logoがある場合ロゴを表示
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(75)
        }
        let col = Col.BottomUpAligned().layout {
            c in
            c.height(75).width(25)
        }
        col +++ MQForm.label(name: "likes1", title: "🔺").width(25).height(25)
        col +++ MQForm.label(name: "likes2", title: String(describing: "\(req.numberOfLikes)")).width(25).height(25).layout {
            l in
            let label = l.label
            label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
            label.textAlignment = .center
        }

        col +++ MQForm.label(name: "likes3", title: "🔻").width(25).height(25)
        row +++ col

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
            l.fillParent()
            l.label.font = UIFont.systemFont(ofSize: 12)
            l.label.textColor = UIColor(white: 0.33, alpha: 1)
            l.label.numberOfLines = 0
        }
        row.layout {
            r in
            r.fillHolizon().height(40)
        }
        row +++ actionCtrl
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
