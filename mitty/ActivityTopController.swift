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
//  一覧にある活動をタップすると、該当活動の詳細表示画面に遷移する。

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
class ActivityTopViewController: MittyUIViewController, UISearchBarDelegate {
    
    var activityListDS :ActivityListDataSource? = nil
    let activityListDelegate :ActivityListDelegate
    
    // Search Box
    let searchBox : UISearchBar = {
        let t = UISearchBar()
        t.placeholder = "Input your search key here."
        t.showsCancelButton = false
        return t
    }()
    
    // activityList を作成する
     let form : ActivityListForm
    
    override init () {
        self.form = ActivityListForm.newAutoLayout()
        activityListDelegate = ActivityListDelegate()
        super.init()
        activityListDS = ActivityListDataSource(controller: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // Viewの読み込み。
    //
    override func loadView() {
        
        super.loadView()
        self.navigationItem.title = "活動予定"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(form)
        
        configureNavigationBar()
        
        loadActivityList()

        self.form.load()
        
        let mitty = form.quest()
        
        form["thisYear"]?.bindEvent(.touchUpInside ) {thisYearButton in
            thisYearButton.backgroundColor = .red
            print("This Year taped")
        }

        form.quest("[name=nextYear]").bindEvent(for: .touchUpInside) {[weak self](view) in
            view.backgroundColor = .yellow
            print("Next Year taped")
            self?.printFrames()
        }
        
        let indicator = mitty["[name=indicator]"]
        indicator.bindEvent(for: .touchUpInside) {(view) in
            view.backgroundColor = .blue
            print("Indicator Button taped")
        }
        var showOrHide = true
        
        mitty["[name=stepper]"].bindEvent(for: .valueChanged) {(view) in
            view.backgroundColor = .blue
            let stepper = (view as! UIStepper).value
            let indicatorButton = indicator.control()?.view as! UIButton
            indicatorButton.setTitle("\(Int(stepper))" + "年", for: .normal)
            indicatorButton.isHidden = !showOrHide
            showOrHide = !showOrHide
            print("stepper changed")
        }
        
//        form.quest().forEach { (c) in
//            c.view.layer.borderWidth=1
//        }
        
        let labels = form.quest("[name=activitylabel]")
        labels.forEach() { c in
            let l = c.view as! UILabel
            l.textColor = UIColor(red: 0.3, green: 0.6, blue: 0.4, alpha: 0.9)
            l.font = UIFont(name:"AppleGothic", size: 12)
        }
        
        labels.bindEvent(for: .touchUpInside) { [weak self] label in
            let detailViewController = ActivityPlanDetailsController()
            self?.navigationItem.title = "..."
            self?.tabBarController?.tabBar.isHidden = true
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
        
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout

    }
    
    var firstTime = true
    
    func printFrames() {
        if (!firstTime) {
            return
        }
        form.quest().forEach() { c in
            print("---------")
            print(c.name + ":")
            print(c.view.bounds)
        }
        firstTime = true
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
            form.autoPinEdge(toSuperviewEdge: .bottom)
            
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        form.quest().forEach() {
            c in
            print(c.name)
            print(c.view.bounds)
        }
    }
}



