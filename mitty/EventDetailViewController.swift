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
        
        self.view.addSubview(scrollView)
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)

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
            
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

}
