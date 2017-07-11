//
//  ExplorerTopViewController.swift
//  mitty
//
//  Created by gridscale on 2017/02/15.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

@objc(ExplorerTopViewController1)
class ExplorerTopViewController1 : MittyViewController , UISearchBarDelegate {
    
    var id = 1
    let explorerViewController = EventViewController()
    
    // Search Box
    let searchBox : UISearchBar = {
        let t = UISearchBar()
        t.placeholder = "Input your search key here."
        t.showsCancelButton = false
        return t
    }()
    
    // Recommendation
    // Title
    let eventTitle : UILabel = {
        let label = UILabel.newAutoLayout()
        label.numberOfLines=0
        label.text = "ようこそ沖縄へ、島祭り、楽しもう。ようこそ美しい島へ"
        label.textColor = UIColor.white
        label.shadowColor = UIColor.black
        label.shadowOffset = CGSize(width:0, height:1)
        let pointSize = UIFont.systemFontSize*2.2
        label.font = UIFont.systemFont(ofSize: pointSize)
        return label
    }()

    
    // icon
    let eventIcon : UIImageView = {
        let img = UIImageView.newAutoLayout()
        img.image = UIImage(named: "timesquare")
        
        return img
    } ()
    
    // image
    let eventImage : UIImageView = {
        let img = UIImageView.newAutoLayout()

        let images =
        [
            UIImage(named: "event9.jpeg")!,
            UIImage(named: "event10.jpeg")!,
            UIImage(named: "Guide1")!,
            UIImage(named: "Guide2")!,
            UIImage(named: "Guide3")!,
            UIImage(named: "event11")!
        ]
        
        img.animationImages = images
        img.clipsToBounds=true
        img.contentMode = UIViewContentMode.scaleAspectFill
        img.animationDuration = Double(images.count) * Double(5)
        
        return img
    } ()
    
    // Swipe recognization
    
    
    // init
    
    
    // indicator
    let indicator : BaguaIndicator =  {
        let rect = CGRect(x:100, y:100, width:UIScreen.main.bounds.width * 0.512, height: UIScreen.main.bounds.width * 0.512 / 1.414)
        let indicator = BaguaIndicator(frame: rect)
        indicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        return indicator
    } ()
    
    override func viewDidAppear(_ animated: Bool) {
        eventImage.startAnimating()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        super.autoCloseKeyboard()
        
        customNavigationBar()
        
        configSwipeRecognizer()
        
        self.view.addSubview(eventImage)
        self.view.addSubview(eventTitle)
        self.view.addSubview(eventIcon)
        
        // 色のビュルド仕方
        let swiftColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 1)
        self.view.backgroundColor = swiftColor

        loadRecommendation()
    
    }
    
    func customNavigationBar () {
        self.navigationItem.title = "島たん"
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.titleView = searchBox
//        self.navigationController?.navigationBar.isHidden = true
        searchBox.delegate = self
//        self.tabBarController?.tabBar.isHidden = true

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        eventImage.stopAnimating()
        self.navigationController?.pushViewController(explorerViewController, animated: true)
    }
    
    func configSwipeRecognizer () {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self,
                                                         action:#selector(ExplorerTopViewController1.swipeGesture(handler:)))
        leftSwipe.direction = .left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self,
                                                 action:#selector(ExplorerTopViewController1.swipeGesture(handler:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
    }
    
    func swipeGesture(handler: UISwipeGestureRecognizer) {
        if (handler.direction == .right) {
            eventImage.image = UIImage(named:"event9.jpeg")
            
        } else if (handler.direction == .left) {
            eventImage.image = UIImage(named:"event10.jpeg")
            id = 2
        }
    }
    
    //
    //
    //
    func loadRecommendation () {
        
        showIndicator()
        
//        searchBox.autoPin(toTopLayoutGuideOf: self, withInset: 10)
//        searchBox.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
//        searchBox.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
//        searchBox.autoSetDimension(.height, toSize: 30)

        eventTitle.autoPin(toTopLayoutGuideOf: self,  withInset: 130)
        eventTitle.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
//        eventTitle.autoSetDimension(.height, toSize: 70)
        eventTitle.autoSetDimension(.width, toSize: 250)

        eventIcon.autoPinEdge(.top, to: .top, of: eventTitle, withOffset: 0)
        eventIcon.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        eventIcon.autoSetDimension(.height, toSize: 35)
        eventIcon.autoSetDimension(.width, toSize: 50)
        
        // image
//        eventImage.autoPin(toTopLayoutGuideOf: self, withInset: 0)
//        eventImage.autoPinEdge(.top, to: .bottom, of: searchBox, withOffset: 00)
        eventImage.autoPinEdge(toSuperviewEdge: .top)
        eventImage.autoPinEdge(toSuperviewEdge: .leading)
        eventImage.autoPinEdge(toSuperviewEdge: .trailing)
        eventImage.autoPinEdge(toSuperviewEdge: .bottom)
        
        eventImage.startAnimating()

        
        // load Service
        stopIndicator()
    }
    
    //
    //
    //
    func showIndicator () {
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    //
    //
    //
    func stopIndicator () {
        indicator.removeFromSuperview()
        indicator.stopAnimating()
    }
    
}
