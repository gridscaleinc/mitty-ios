//
//  QuestViewController.swift
//  mitty
//
//  Created by gridscale on 2017/04/16.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

@objc(QuestViewController)
class QuestViewController: MittyViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var queryTargets : Control = {
        let c = UISegmentedControl(items: ["Event", "Request", "Web"])
        c.selectedSegmentIndex = 0
        c.translatesAutoresizingMaskIntoConstraints = false
        return Control (name: "queryTargets", view: c)
    }()
    
    let form = MQForm.newAutoLayout()
    let logo = MQForm.img(name: "Logo", url:"applogo")
    
    var searchBar: Control = {
        let bar = UISearchBar.newAutoLayout()
        bar.backgroundColor = .white
        bar.layer.borderColor = UIColor.black.cgColor
        bar.layer.borderWidth = 0.5
        bar.layer.cornerRadius = 5
        
        for view in bar.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor.white
                }
                if subview is UIImageView {
                    let imageView = subview as! UIImageView
                    imageView.removeFromSuperview()
                }
            }
        }
        bar.placeholder = "検索キーを入力"

        return Control(name:"searchbar", view: bar)
    } ()
    
    var query: String = ""

    let eventSearch = EventViewController()
    let requestSearch = RequestExplorerViewController()

    let postRequestButton = MQForm.button(name: "postrequest", title: "リクエスト登録")
    

    override func viewDidLoad() {

        super.autoCloseKeyboard()

        self.view.addSubview(form)
        form +++ queryTargets
        form +++ logo
        form +++ postRequestButton
        form +++ searchBar
        
        
        queryTargets.bindEvent(.valueChanged) {
            v in
            self.changeQuery(v as! UISegmentedControl)
        }
        
        
        postRequestButton.bindEvent(.touchUpInside) {
            p in
            self.postRequest()
        }
        
        self.navigationItem.title = "検索条件指定"

        (searchBar.view as! UISearchBar).delegate = self

        LoadingProxy.set(self)
        
        configViews()
        
        super.lockView()

    }
    
    func configViews() {
        self.view.backgroundColor = .white

        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        queryTargets.layout {
            q in
            q.upper(withInset: 5).fillHolizon(5).height(32)
        }
        
        logo.layout {
            l in
            l.putUnder(of: self.queryTargets, withOffset: 50)
            l.holizontalCenter().width(40).height(40)
        }
        
        searchBar.layout {
            s in
            s.putUnder(of: self.logo, withOffset: 10).leftMost(withInset: 30).rightMost(withInset: 30)
            s.height(35)
        }
        
        postRequestButton.layout {
            p in
            p.putUnder(of: self.searchBar, withOffset: 30).height(30).width(200).holizontalCenter()
        }
        
        
        form.configLayout()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
//        searchBar.becomeFirstResponder()
    }

    func postRequest() {
        let vc = RequestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func changeQuery(_ s: UISegmentedControl) {
        searchBarSearchButtonClicked(searchBar.view as! UISearchBar)
    }
}

// MARK: - UISearchBarDelegate
extension QuestViewController: UISearchBarDelegate, WebPickerDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false

        if (searchBar.text == "") {
            return
        }
        
        let targets = queryTargets.view as! UISegmentedControl
        if targets.selectedSegmentIndex == 0 {
            eventSearch.searchBar.text = searchBar.text
            eventSearch.shallWeSearch = true
            self.navigationController?.pushViewController(eventSearch, animated: true)
        } else if targets.selectedSegmentIndex == 1 {
            requestSearch.searchBar.text = searchBar.text
            requestSearch.shallWeSearch = true
            self.navigationController?.pushViewController(requestSearch, animated: true)

        } else if targets.selectedSegmentIndex == 2 {
            let wb = WebPicker()
            wb.delegate = self
            wb.initKey = searchBar.text!
            self.navigationController?.pushViewController(wb, animated: true)
        }

    }

    func webpicker(_ picker: WebPicker?, _ info: PickedInfo) -> Void {

        let vc = ActivityEntryViewController()
        vc.pickedInfo = info
        vc.activityTitle.textField.text = (searchBar.view as! UISearchBar).text

        self.navigationController?.pushViewController(vc, animated: true)
    }


    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        eventSearch.searchBar.text = searchBar.text
        self.navigationController?.pushViewController(eventSearch, animated: true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
