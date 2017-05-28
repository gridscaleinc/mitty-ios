//
//  ActivityTopViewController.swift
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//


//  活動タブのトップビューコントローラー
//  直近の活動一覧を表示し、フィルタにより絞り込み可能にする。
//  追加ボタンを押すと、活動の追加登録画面に遷移する。
//  一覧にある活動をタップすると、該当活動の詳細表示画面に遷varする。

//
//

import Foundation
import UIKit
import PureLayout

/**
 * Activity Top View Controller.
 *
 * 「Activity」タブのトップView Controller
 *
 */
@objc(ActivityTopViewController)
class ActivityTopViewController: MittyViewController, UISearchBarDelegate {
    
    
    // Search Box
    let searchBox : UISearchBar = {
        let t = UISearchBar()
        t.placeholder = "Input your search key here."
        t.showsCancelButton = false
        return t
    }()
    
    // activityList を作成する
    var form = ActivityListForm.newAutoLayout()
    
    //
    // Viewの読み込み。
    //
    override func loadView() {
        
        super.loadView()
        self.navigationItem.title = "活動予定"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(form)
        
        configureNavigationBar()
        
    }
    
    func loadForm(activities : [ActivityInfo]) {
    
        form.removeFromSuperview()
        self.form = ActivityListForm.newAutoLayout()

        self.view.addSubview(form)
        
        form.activityList.removeAll()
        form.activityList.insert(contentsOf: activities, at: 0)
        
        loadActivityList()

        self.form.load()
        
        
        let labels = form.quest("[name=activitylabel]")
        labels.forEach() { c in
            let l = c.view as! UILabel
            l.textColor = MittyColor.healthyGreen
            l.font = UIFont(name:"AppleGothic", size: 14)
        }
        
        labels.bindEvent(for: .touchUpInside) { [weak self] label in
            if !(label is TapableLabel) {
                return
            }
            let a = (label as! TapableLabel).underlyObj
            
            if !(a is ActivityInfo) {
                return
            }
            
            let detailViewController = ActivityPlanDetailsController(a as! ActivityInfo)
            self?.navigationItem.title = "..."
            self?.tabBarController?.tabBar.isHidden = true
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
        
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout

    }
    
    var didSetupConstraints = false
    
    //
    // 活動予定一覧の読み込み
    //
    func loadActivityList () {
        
        form.loadForm()
  
    
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            
            form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
            form.autoPinEdge(toSuperviewEdge: .left)
            form.autoPinEdge(toSuperviewEdge: .right)
            form.autoPin(toBottomLayoutGuideOf: self, withInset: 0)
            
            form.configLayout()
            didSetupConstraints = true
        }

        super.updateViewConstraints()
        

    }
    
    // navigation bar の初期化をする
    private func configureNavigationBar() {
        
        let searchItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target:self, action:#selector(showSearchBox))
        let additionItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target:self, action:#selector(addActivity))
        
        let rightItems = [additionItem, searchItem]
                navigationItem.setRightBarButtonItems(rightItems, animated: true)
        
    }
    
    
    typealias SearchHandler = (_ searchBar: UISearchBar) -> Void
    
    var handleSearch : SearchHandler?

    func showSearchBox() {
        let naviItem = self.navigationItem
        let titleView = self.navigationItem.titleView
        self.navigationItem.titleView = searchBox
        
        // nest function　to serve search event
        func searchIt (_ searchBar: UISearchBar) -> Void {
            naviItem.titleView = titleView
            configureNavigationBar()
        }
        
        handleSearch = searchIt
        
        searchBox.delegate = self
        navigationItem.setRightBarButtonItems([], animated: true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if handleSearch != nil {
            handleSearch! (searchBar)
        }
    }
    
    func addActivity() {
        
        let vc = ActivityEntryViewController()
        self.navigationItem.title = "戻る"
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    /// 子画面からモドたら、tabバーを戻す。
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "活動予定"

        ActivityService.instance.search(keys: "") { [weak self]
            activities in
            self?.loadForm(activities: activities)
            self?.didSetupConstraints = false
            self?.view.setNeedsUpdateConstraints()
            self?.view.updateConstraintsIfNeeded()
            self?.view.layoutIfNeeded()
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
    }
    
    override func viewDidLoad() {
        LoadingProxy.set(self)
    }
}



