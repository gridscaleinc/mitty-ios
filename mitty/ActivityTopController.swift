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
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "活動予定"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(form)
        
        configureNavigationBar()
        
        loadActivityList()
        form.configLayout()
        self.form.collectionView.dataSource = self.activityListDS
        self.form.collectionView.delegate = self.activityListDelegate
        self.form.collectionView.register(ActivityCell.self, forCellWithReuseIdentifier:ActivityCell.id)
        self.form.collectionView.register(ActivityListHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ActivityListHeaderCell.id)
        
        self.form.load()
        
        self.view.setNeedsLayout()
        
        let mitty = form.mitty()
        
        mitty["[name=thisYear]"].bindEvent( for: .touchUpInside ) {thisYearButton in
            thisYearButton.backgroundColor = .red
            print("This Year taped")
        }

        mitty["[name =nextYear]"].bindEvent(for: .touchUpInside) {(view) in
            view.backgroundColor = .yellow
            print("Next Year taped")
        }
        let indicator = mitty["[name=indicator]"]
        indicator.bindEvent(for: .touchUpInside) {(view) in
            view.backgroundColor = .blue
            print("Indicator Button taped")
        }
        
        mitty["[name=stepper]"].bindEvent(for: .valueChanged) {(view) in
            view.backgroundColor = .blue
            let stepper = (view as! UIStepper).value
            indicator.forEach() {(c) in
                (c.view as! UIButton).setTitle("\(Int(stepper))" + "年", for: .normal)
            }
            print("stepper changed")
        }
        
    }
    
    //
    // 活動予定一覧の読み込み
    //
    func loadActivityList () {
        
        form.loadForm()
        
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        // 線を引いて、対象年のフィルタボタンを設定する
        
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
        
        let vc = ActivitySelectionViewController()
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
    
}



