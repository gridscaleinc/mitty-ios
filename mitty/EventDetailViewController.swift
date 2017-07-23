//
//  EventDetail.swift
//  mitty
//
//  Created by gridscale on 2017/04/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class EventDetailViewController: MittyViewController, UITextFieldDelegate {
    
    var event : Event
    
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
        if event.accessControl == "public" {
            if event.participated() {
                subscribeButton.setTitle("やめます", for: .normal)
            }
        }
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
        
        super.autoCloseKeyboard()
        
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
        //        scroll.layer.borderWidth = 1
        //        scroll.layer.borderColor = UIColor.blue.cgColor
        
        let scrollContainer = Container(name: "Detail-form", view: scroll).layout() { (container) in
            container.fillParent()
        }
        
        form +++ scrollContainer
        
        let detailForm = Section(name: "Content-Form", view: UIView.newAutoLayout())
        
        scrollContainer +++ detailForm
        
        let img = Control(name: "image", view: imageView).layout {
            i in
            i.width(UIScreen.main.bounds.size.width).upper().height(UIScreen.main.bounds.size.width)
        }
        
        if (event.coverImageUrl != "") {
            DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
            imageView.af_setImage(withURL: URL(string: event.coverImageUrl)!, placeholderImage: UIImage(named: "downloading"), completion : { image in
                if (image.result.isSuccess) {
                    self.imageView.image = image.result.value
                    img.height(UIScreen.main.bounds.size.width * (image.result.value?.size.ratio)!)
                }
            }
            )
        }
        
        detailForm +++ img
        
        let titleLabel = MQForm.label(name: "Title", title: event.title).layout {
            l in
            l.leftMost(withInset: 25).upper(withInset: 50).height(50)

            (l.view as! UILabel).font = UIFont.boldSystemFont(ofSize: 24)
            (l.view as! UILabel).textColor = .white
            (l.view as! UILabel).shadowColor = UIColor.black
            (l.view as! UILabel).shadowOffset = CGSize(width:0, height:1)
            (l.view as! UILabel).numberOfLines = 0
        }
        
        detailForm +++ titleLabel
        
        let imageIcon = MQForm.img(name: "image-icon", url: "timesquare").layout {
            i in
            i.width(35).height(35).topAlign(with: titleLabel).rightMost(withInset: 30)
        }
        detailForm +++ imageIcon
        

        let actionLabel = MQForm.label(name: "action", title: (event.action)).layout {
            c in
            c.putUnder(of: img, withOffset: 5).fillHolizon(10)
            let l = c.view as! UILabel
            l.numberOfLines = 0
            l.font = .boldSystemFont(ofSize: 18)
            l.layer.borderColor = UIColor.black.cgColor
        }
        
        detailForm +++ actionLabel
        
        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: actionLabel, withOffset: 5).height(35)
        }
        
        let likes = MQForm.label(name: "heart", title: "❤️ \(event.likes)  価格:\(event.priceShortInfo)").layout { l in
            l.height(35).width(330)
        }
        
        row +++ likes
        
        detailForm +++ row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: likes, withOffset: 5).height(35)
        }
        
        let dates = MQForm.label(name: "sheduledData", title: event.duration()).layout { l in
            l.height(35).width(250)
            l.label.adjustsFontSizeToFitWidth = true
            l.label.textColor = UIColor(white: 0.33, alpha: 1)
        }
        
        row +++ dates
        detailForm +++ row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: dates, withOffset: 5).height(40)
        }
        row +++ MQForm.label(name: "geoIcon", title:"📍").height(35).width(25)
        let location = MQForm.label(name: "isLand", title: "\(event.isLandName)").layout { l in
            l.height(40).width(210)
            l.label.adjustsFontSizeToFitWidth = true
            l.label.numberOfLines = 2
            if self.event.isValidGeoInfo {
                l.label.textColor = MittyColor.healthyGreen
            }
        }
        if (event.isValidGeoInfo) {
            location.bindEvent(.touchUpInside) {_ in 
                self.event.openGoogleMap()
            }
        }
        
        row +++ location
        
        let lacationIcon = MQForm.img(name: "locationIocn", url: "timesquare").layout {
            icon in
            icon.height(35).width(20).topAlign(with: location)
        }
        row +++ lacationIcon
        
        detailForm +++ row
        
        
        
        let contact = Row.Intervaled().layout {
            r in
            r.fillHolizon().putUnder(of: lacationIcon, withOffset: 5).height(35)
        }
        contact +++ MQForm.label(name: "tel", title: "☎️　" + event.contactTel).layout {
            l in
            l.height(35)
        }
        contact +++ MQForm.label(name: "fax", title: "📠 " + event.contactFax).layout {
            l in
            l.height(35)
        }
        detailForm +++ contact
        
        // TODO: Mail address
        
        let infoSource = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: contact, withOffset: 5).height(35)
        }
        infoSource +++ MQForm.label(name: "sponsor", title: "主催者").layout {
            l in
            l.height(35)
        }
        infoSource +++ MQForm.label(name: "name", title: event.organizer).layout {
            l in
            l.height(35)
        }
        detailForm +++ infoSource
        
        
        let url = Row.LeftAligned().layout {
            r in
            r.fillHolizon().putUnder(of: infoSource, withOffset: 5).height(35)
        }
        url +++ MQForm.label(name: "URL", title: "情報源").layout {
            l in
            l.height(35)
        }
        
        let link = UIButton.newAutoLayout()
        link.setTitleColor(.blue, for: .normal)
        link.setTitle(event.sourceName, for: .normal)
        url +++ Control(name:"URL", view:link).layout {
            l in
            l.height(35)
        }.bindEvent(.touchUpInside) { [ weak self]
            b in
            
            let urlString : String = (self?.event.sourceUrl)!
            
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        detailForm +++ url
        
        
        let description = event.description
        
        let descriptionLabel = MQForm.label(name: "detailDescription", title: description).layout {
            c in
            c.putUnder(of: url, withOffset: 5).fillHolizon(10)
            let l = c.view as! UILabel
            //            l.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
            l.numberOfLines = 0
            l.textColor = .black
            l.font = .systemFont(ofSize: 15)
            l.layer.cornerRadius = 2
            l.layer.borderWidth = 0.8
            l.layer.borderColor = UIColor.gray.cgColor
            l.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
        }
        
        detailForm +++ descriptionLabel
        
        let subscribe = Control(name: "subscribe", view: subscribeButton).layout {
            c in
            c.height(45).holizontalCenter().width(140).putUnder(of: descriptionLabel, withOffset: 30)
        }
        
        detailForm +++ subscribe
        
        subscribe.bindEvent(.touchUpInside) {
            b in
            let button = b as! UIButton
            self.pressSubscribe(sender: button)
        }
        
        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: subscribe)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height + 10, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
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
}
