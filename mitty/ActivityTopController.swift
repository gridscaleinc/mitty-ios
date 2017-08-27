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

    var activityTypes: UISegmentedControl = UISegmentedControl(items: ["Activity", "Request", "Invitation"])

    // Search Box
    let searchBox: UISearchBar = {
        let t = UISearchBar()
        t.placeholder = "Input your search key here."
        t.showsCancelButton = false
        return t
    }()

    // activityList を作成する
    var activityform = ActivityListForm.newAutoLayout()

    var reqform = RequestListForm.newAutoLayout()
    
    //
    // Viewの読み込み。
    //
    override func loadView() {

        super.loadView()
        self.navigationItem.title = "活動予定"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(activityform)
        self.view.addSubview(activityTypes)

        configureNavigationBar()

    }

    func loadActivityForm(activities: [ActivityInfo]) {

        activityform.removeFromSuperview()
        self.activityform = ActivityListForm.newAutoLayout()

        self.view.addSubview(activityform)

        activityform.activityList.removeAll()
        activityform.activityList.insert(contentsOf: activities, at: 0)

        loadActivityList()

        self.activityform.load()


        let labels = activityform.quest("[name=activitylabel]")
        labels.forEach() { c in
            let l = c.view as! UILabel
            l.textColor = MittyColor.healthyGreen
            l.font = UIFont(name: "AppleGothic", size: 14)
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

    func loadRequestForm(requests: [RequestInfo]) {
        
        reqform.removeFromSuperview()
        self.reqform = RequestListForm.newAutoLayout()
        
        self.view.addSubview(reqform)
        
        reqform.requestList.removeAll()
        reqform.requestList.insert(contentsOf: requests, at: 0)
        
        loadRequestList()
        
        self.reqform.load()
        
        
        let labels = reqform.quest("[name=requestlabel]")
        labels.forEach() { c in
            let l = c.view as! UILabel
            l.textColor = MittyColor.healthyGreen
            l.font = UIFont(name: "AppleGothic", size: 14)
        }
        
        labels.bindEvent(for: .touchUpInside) { [weak self] label in
            if !(label is TapableLabel) {
                return
            }
            let a = (label as! TapableLabel).underlyObj
            
            if !(a is RequestInfo) {
                return
            }
            
            let detailViewController = RequestDetailViewController(req: a as! RequestInfo)
            
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

        activityform.loadForm()


    }

    func loadRequestList () {
        
        reqform.loadForm()
    
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            
            activityTypes.translatesAutoresizingMaskIntoConstraints = false
            activityTypes.autoPin(toTopLayoutGuideOf: self, withInset: 5)
            activityTypes.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
            activityTypes.autoPinEdge(toSuperviewEdge: .right, withInset: 5)

            if activityTypes.selectedSegmentIndex == 0 {
                activityform.autoPinEdge(.top, to: .bottom, of: activityTypes, withOffset: 5)
                
                activityform.autoPinEdge(toSuperviewEdge: .left)
                activityform.autoPinEdge(toSuperviewEdge: .right)
                activityform.autoPin(toBottomLayoutGuideOf: self, withInset: 0)
                
                activityform.configLayout()
            } else if activityTypes.selectedSegmentIndex == 1 {
                reqform.autoPinEdge(.top, to: .bottom, of: activityTypes, withOffset: 5)
                
                reqform.autoPinEdge(toSuperviewEdge: .left)
                reqform.autoPinEdge(toSuperviewEdge: .right)
                reqform.autoPin(toBottomLayoutGuideOf: self, withInset: 0)
                
                reqform.configLayout()

            }
            didSetupConstraints = true
        }

        super.updateViewConstraints()


    }

    // navigation bar の初期化をする
    private func configureNavigationBar() {

        let searchItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(showSearchBox))
        let additionItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addActivity))

        let rightItems = [additionItem, searchItem]
        navigationItem.setRightBarButtonItems(rightItems, animated: true)

    }


    typealias SearchHandler = (_ searchBar: UISearchBar) -> Void

    var handleSearch: SearchHandler?

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
        
        changeType(activityTypes)
        
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {


    }

    override func viewDidLoad() {

        super.autoCloseKeyboard()
        activityTypes.selectedSegmentIndex = 1
        activityTypes.addTarget(self, action: #selector(changeType(_:)), for: .valueChanged)

        LoadingProxy.set(self)
    }

    // 選択した種類によて、一覧表示を変える。
    func changeType(_ s: UISegmentedControl) {
        if (activityTypes.selectedSegmentIndex == 0) {
            ActivityService.instance.search(keys: "") { [weak self]
                activities in
                self?.loadActivityForm(activities: activities)

            }
        } else if activityTypes.selectedSegmentIndex == 1 {
            RequestService.instance.getMyRequests(key: "") { [weak self]
                requests in
                self?.loadRequestForm(requests: requests)
            }
        }
        self?.didSetupConstraints = false
        self?.view.setNeedsUpdateConstraints()
        self?.view.updateConstraintsIfNeeded()
        self?.view.layoutIfNeeded()
    }
}



