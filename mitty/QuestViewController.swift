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

    var queryTargets: UISegmentedControl = UISegmentedControl(items: ["Event", "Request", "Web"])
    let logo = UIImageView(image: UIImage(named: "applogo"))
    var searchBar: UISearchBar = UISearchBar.newAutoLayout()
    var query: String = ""

    let eventSearch = EventViewController()
    let requestSearch = RequestExplorerViewController()

    let postRequestButton: UIButton = {
        let b = UIButton.newAutoLayout()
        b.setTitle(".Post request", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        return b
    } ()

    override func viewDidLoad() {

        super.autoCloseKeyboard()

        self.view.addSubview(queryTargets)
        self.view.addSubview(logo)
        self.view.addSubview(searchBar)
        self.view.addSubview(postRequestButton)

        searchBar.backgroundColor = .white
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 5

        setColor(searchBar, UIColor.white)

        searchBar.placeholder = "イベント検索!"

        self.navigationItem.title = "検索条件指定"

        searchBar.delegate = self

        configViews()

        LoadingProxy.set(self)
        
        super.lockView()

    }

    func setColor(_ v: UIView, _ color: UIColor) {
        for view in v.subviews {
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
    }

    func configViews() {
        self.view.backgroundColor = .white
        queryTargets.selectedSegmentIndex = 0
        queryTargets.translatesAutoresizingMaskIntoConstraints = false
        queryTargets.autoPin(toTopLayoutGuideOf: self, withInset: 10)
        queryTargets.autoPinEdge(toSuperviewEdge: .left, withInset: 40)
        queryTargets.autoPinEdge(toSuperviewEdge: .right, withInset: 40)

        queryTargets.addTarget(self, action: #selector(changeQuery(_:)), for: .valueChanged)
        logo.autoPinEdge(.top, to: .bottom, of: queryTargets, withOffset: 50)
        logo.autoAlignAxis(.vertical, toSameAxisOf: self.view)
        logo.autoSetDimensions(to: CGSize(width: 40, height: 40))

        searchBar.autoPinEdge(.top, to: .bottom, of: logo, withOffset: 10)
        searchBar.autoPinEdge(toSuperviewEdge: .leading, withInset: 30)
        searchBar.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        searchBar.autoSetDimension(.height, toSize: 35)

        postRequestButton.autoPinEdge(toSuperviewEdge: .left, withInset: 50)
        postRequestButton.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 30)
        postRequestButton.autoSetDimension(.height, toSize: 30)
        postRequestButton.autoSetDimension(.width, toSize: 200)

        postRequestButton.addTarget(self, action: #selector(postRequest(_:)), for: .touchUpInside)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
//        searchBar.becomeFirstResponder()
    }

    func postRequest(_ b: UILabel) {
        let vc = RequestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func changeQuery(_ s: UISegmentedControl) {
        searchBarSearchButtonClicked(searchBar)
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

        if queryTargets.selectedSegmentIndex == 0 {
            eventSearch.searchBar.text = searchBar.text
            eventSearch.shallWeSearch = true
            self.navigationController?.pushViewController(eventSearch, animated: true)
        } else if queryTargets.selectedSegmentIndex == 1 {
            requestSearch.searchBar.text = searchBar.text
            requestSearch.shallWeSearch = true
            self.navigationController?.pushViewController(requestSearch, animated: true)

        } else if queryTargets.selectedSegmentIndex == 2 {
            let wb = WebPicker()
            wb.delegate = self
            wb.initKey = searchBar.text!
            self.navigationController?.pushViewController(wb, animated: true)
        }

    }

    func webpicker(_ picker: WebPicker?, _ info: PickedInfo) -> Void {

        let vc = ActivityEntryViewController()
        vc.pickedInfo = info
        vc.activityTitle.textField.text = searchBar.text

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
