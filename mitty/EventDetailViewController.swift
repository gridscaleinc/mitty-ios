//
//  EventDetail.swift
//  mitty
//
//  Created by gridscale on 2017/04/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
//
//  SigninViewController.swift
//  mitty
//
//  Created by D on 2017/04/11.
//  Copyright © 2017 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class EventDetailViewController: UIViewController, UITextFieldDelegate {
    
    var event : Event
    var images = ["event1", "event6", "event4","event10.jpeg","event5", "event9.jpeg"]
    

    var form = MQForm.newAutoLayout()
    //
    // Purelayout流の画面パーツ作り方、必ずnewAutoLayoutを一度呼び出す。
    // 画面を構成するパーツだから、methoの中ではなく、インスタンス変数として持つ。
    //
    
    let imageView : UIImageView = {
        
        let itemImageView = UIImageView.newAutoLayout()
        itemImageView.clipsToBounds=true
        itemImageView.contentMode = UIViewContentMode.scaleAspectFill
        return itemImageView
    } ()
    
    
    ///
    ///
    let subscribeButton : UIButton = {
        
        let b = UIButton.newAutoLayout()
        b.setTitle("参加", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .orange
        
        return b
    } ()
    

    init (event: Event) {
        self.event = event
        super.init(nibName: nil, bundle:nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        buildDummyEvent(e:event)
        
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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.view.backgroundColor = .clear
        //        self.navigationController?.navigationBar.isHidden = true
    }
    
    func buildform () {
        
        let height_normal : CGFloat = 60.0
        
        let anchor = form.label(name: "dummy", title: "").layout {
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
        //        scroll.layer.borderWidth = 1
        //        scroll.layer.borderColor = UIColor.blue.cgColor
        
        let scrollContainer = Container(name: "Detail-form", view: scroll).layout() { (container) in
            container.fillParent()
        }
        
        form +++ scrollContainer
        
        let detailForm = Section(name: "Content-Form", view: UIView.newAutoLayout()).layout() { c in
            
            //            c.view.layer.borderWidth = 1
            //            c.view.layer.borderColor = UIColor.yellow.cgColor
            c.upper()
            c.width(UIScreen.main.bounds.size.width).height(500)
        }
        
        scrollContainer +++ detailForm
        
        imageView.image = UIImage(named: images[Int(event.id)])
        let img = Control(name: "image", view: imageView).layout {
            i in
            i.width(UIScreen.main.bounds.size.width).upper().fillHolizon()
        }
        
        detailForm +++ img
        
        let titleLabel = form.label(name: "Title", title: event.title!).layout {
            l in
            l.leftMost(withInset: 25).upper(withInset: 30).height(20)

            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 16)
            (l.view as! UILabel).textColor = .white
            (l.view as! UILabel).shadowColor = UIColor.black
            (l.view as! UILabel).shadowOffset = CGSize(width:0, height:1)
            (l.view as! UILabel).numberOfLines = 0
        }
        
        detailForm +++ titleLabel
        
        let imageIcon = form.img(name: "image-icon", url: "timesquare").layout {
            i in
            i.width(35).height(35).topAlign(with: titleLabel).rightMost(withInset: 30)
        }
        detailForm +++ imageIcon
        
        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: img, withOffset: 5)
        }
        
        let likes = form.label(name: "heart", title: "❤️ 134 👁 430 Like率: 35%　　　価格:¥1000.").layout { l in
            l.height(20).width(300)
        }
        
        row +++ likes
        
        detailForm +++ row
        
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: likes, withOffset: 5).height(35)
        }
        
        let location = form.label(name: "isLand", title: "📍　ビッグサイト").layout { l in
            l.height(20).width(250)
        }
        
        row +++ location
        
        let lacationIcon = form.img(name: "locationIocn", url: "timesquare").layout {
            icon in
            icon.height(20).width(20).topAlign(with: location)
        }
        row +++ lacationIcon
        
        detailForm +++ row
        
        let actionLabel = form.label(name: "action", title: (event.action ?? "")).layout {
            c in
            c.putUnder(of: location, withOffset: 5).fillHolizon(10)
            let l = c.view as! UILabel
//            l.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
            l.numberOfLines = 0
            l.textColor = .black
            l.font = .systemFont(ofSize: 12)
            l.layer.cornerRadius = 5
            l.layer.borderWidth = 1
            l.layer.borderColor = UIColor.black.cgColor
        }
        
        detailForm +++ actionLabel
        
        let contact = Row.Intervaled().layout {
            r in
            r.fillHolizon().putUnder(of: actionLabel, withOffset: 5).height(20)
        }
        contact +++ form.label(name: "tel", title: "☎️　03-3733-0987").layout {
            l in
            l.height(20)
        }
        contact +++ form.label(name: "fax", title: "📠　03-3733-0989").layout {
            l in
            l.height(20)
        }
        detailForm +++ contact
        
        let infoSource = Row.Intervaled().layout {
            r in
            r.fillHolizon().putUnder(of: contact, withOffset: 5).height(20)
        }
        infoSource +++ form.label(name: "sponsor", title: "主催者").layout {
            l in
            l.height(20)
        }
        infoSource +++ form.label(name: "name", title: "先端金融情報研究会").layout {
            l in
            l.height(20)
        }
        detailForm +++ infoSource
        
        
        let url = Row.Intervaled().layout {
            r in
            r.fillHolizon().putUnder(of: infoSource, withOffset: 5).height(20)
        }
        url +++ form.label(name: "URL", title: "URL").layout {
            l in
            l.height(20)
        }
        url +++ form.label(name: "URL-value", title: "http://abc.com").layout {
            l in
            l.height(20)
        }
        detailForm +++ url
        
        let subscribe = Control(name: "scbscribe", view: subscribeButton).layout {
            c in
            c.height(45).leftMost(withInset: 60).width(140).putUnder(of: url, withOffset: 30)
        }
        detailForm +++ subscribe
        
        subscribe.event(.touchUpInside) {
            b in
            let button = b as! UIButton
            self.pressSubscribe(sender: button)
        }
    }
    
    
    func pressSubscribe2 (sender: UIButton) {
        // 共有する項目
        let shareText = "Apple - Apple Watch"
        let shareWebsite = NSURL(string: "https://www.apple.com/jp/watch/")!
        let shareImage = UIImage(named: "penginland")!
        
        let activityItems = [shareText, shareWebsite, shareImage] as [Any]
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityType.postToFacebook,
            UIActivityType.postToTwitter,
            UIActivityType.message,
            UIActivityType.saveToCameraRoll,
            UIActivityType.print
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    func pressSubscribe (sender:UIButton){
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "確認", message: "このイベントをカレンダーに登録しますか？", preferredStyle:  UIAlertControllerStyle.actionSheet)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK,\(self.event.id)に参加します。")
            
            self.confirmCalendarRegister()
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel\(self.event.id)に参加しません。")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    func confirmCalendarRegister () {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "確認", message: "イベントの参加をネットで公開しますか？", preferredStyle:  UIAlertControllerStyle.actionSheet)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let openAction: UIAlertAction = UIAlertAction(title: "実名でネットで公開します。", style: UIAlertActionStyle.destructive, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("実名公開,\(self.event.id) 。")
        })
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "プライベート予定なのでやめます。", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("やめる,\(self.event.id) を公開にしません。")
        })
        // キャンセルボタン
        let anonymousAction: UIAlertAction = UIAlertAction(title: "名前を出さないで公開します。", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("匿名公開\(self.event.id)。")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(openAction)
        alert.addAction(anonymousAction)
        alert.addAction(defaultAction)
        
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    
    func buildDummyEvent(e : Event) {
        e.action = "専門家と話し合って、金融の最先端を覗いてみよう！きっと勉強になる。特別価格で提供します。専門家と話し合って、金融の最先端を覗いてみよう！きっと勉強になる。特別価格で提供します。専門家と話し合って、金融の最先端を覗いてみよう！きっと勉強になる。特別価格で提供します。専門家と話し合って、金融の最先端を覗いてみよう！きっと勉強になる。特別価格で提供します。専門家と話し合って、金融の最先端を覗いてみよう！きっと勉強になる。特別価格で提供します。専門家と話し合って、金融の最先端を覗いてみよう！きっと勉強になる。特別価格で提供します。専門家と話し合って、金融の最先端を覗いてみよう！きっと勉強になる。特別価格で提供します。"
        e.title = "フィンテックの話"
        e.iconId = 1
    }
}
