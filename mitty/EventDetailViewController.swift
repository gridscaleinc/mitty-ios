//
//  EventDetailViewController.swift
//  mitty
//
//  Created by gridscale on 2016/11/03.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit
import PureLayout

@objc (EventDetailViewController)
class EventDetailViewController : UIViewController {
    
    var event : Event
    
    //
    // Purelayout流の画面パーツ作り方、必ずnewAutoLayoutを一度呼び出す。
    // 画面を構成するパーツだから、methoの中ではなく、インスタンス変数として持つ。
    //
    let scrollView  = UIScrollView.newAutoLayout()
    let contentView = UIView.newAutoLayout()
    
    let imageView : UIImageView = {
        
        let itemImageView = UIImageView.newAutoLayout()
        itemImageView.clipsToBounds=true
        itemImageView.contentMode = UIViewContentMode.scaleToFill
        return itemImageView
    } ()
    
    let label = UILabel()

    ///
    ///
    let subscribeButton : UIButton = {
        
        let b = UIButton.newAutoLayout()
        b.setTitle("参加", for: .normal)
        return b
    } ()
    
    init (event: Event) {
        self.event = event
        super.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Autolayout済みフラグ
    var didSetupConstraints = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = UIView()
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        self.navigationItem.title = "Event Detail"
        
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.9)
        
        label.text = "イベントの詳細を表示します。ID:" + event.eventId
        imageView.image = UIImage(named: event.imageUrl)
        
        subscribeButton.addTarget(self, action: #selector(EventDetailViewController.pressSubscribe), for: .touchUpInside)
        
        self.view.addSubview(scrollView)
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.addSubview(subscribeButton)


        view.setNeedsUpdateConstraints()
    }

    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {

            scrollView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
            
            contentView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
            contentView.autoMatch(.width, to: .width, of: view)
            
            imageView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            imageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            imageView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
            
            label.autoPinEdge(.top, to: .bottom, of :imageView, withOffset: 10)
            
            label.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            label.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
            label.autoSetDimension(.height, toSize: 40)
            
            subscribeButton.autoPinEdge(.top, to: .bottom, of: label, withOffset: 10)
            subscribeButton.autoCenterInSuperview()
            subscribeButton.autoSetDimension(.width, toSize: 100)
            subscribeButton.autoSetDimension(.height, toSize: 40)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
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
            print("OK," + self.event.eventId + " に参加します。")
            
            self.confirmCalendarRegister()
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel" + self.event.eventId + " に参加しません。")
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
            print("実名公開," + self.event.eventId + " 。")
        })
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "プライベート予定なのでやめます。", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("やめる," + self.event.eventId + " を公開にしません。")
        })
        // キャンセルボタン
        let anonymousAction: UIAlertAction = UIAlertAction(title: "名前を出さないで公開します。", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("匿名公開" + self.event.eventId + "。")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(openAction)
        alert.addAction(anonymousAction)
        alert.addAction(defaultAction)

        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)

    }


}
