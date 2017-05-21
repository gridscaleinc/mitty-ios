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
class QuestViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var queryTargets : UISegmentedControl = UISegmentedControl(items: ["Event", "Request"])
    let logo = UIImageView(image: UIImage(named: "applogo"))
    var searchBar : UISearchBar = UISearchBar.newAutoLayout()
    var query : String = ""

    let eventSearch = EventViewController()
    let requestSearch = EventViewController()
    
    let postRequestButton : UIButton = {
        let b = UIButton.newAutoLayout()
        b.setTitle(".Post request", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        return b
    } ()
    
    
    let postGalleryButton : UIButton = {
        let b = UIButton.newAutoLayout()
        b.setTitle(".Post Gallery Content", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        return b
    } ()

    override func viewDidLoad() {
        self.view.addSubview(queryTargets)
        self.view.addSubview(logo)
        self.view.addSubview(searchBar)
        self.view.addSubview(postRequestButton)
        self.view.addSubview(postGalleryButton)

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
        
    }
    
    func setColor(_ v: UIView, _ color: UIColor) {
        for view in v.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor.white
                }
                if subview is UIImageView  {
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
        queryTargets.autoPinEdge(toSuperviewEdge: .left, withInset: 90)
        queryTargets.autoPinEdge(toSuperviewEdge: .right, withInset: 90)
        
        logo.autoPinEdge(.top, to: .bottom, of: queryTargets, withOffset: 50)
        logo.autoAlignAxis(.vertical, toSameAxisOf: self.view)
        logo.autoSetDimensions(to: CGSize(width: 40, height: 40))
        
        searchBar.autoPinEdge(.top, to: .bottom, of: logo, withOffset : 10)
        searchBar.autoPinEdge(toSuperviewEdge: .leading, withInset: 30)
        searchBar.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        searchBar.autoSetDimension(.height, toSize: 35)
        
        postRequestButton.autoPinEdge(toSuperviewEdge: .left, withInset: 50)
        postRequestButton.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 30)
        postRequestButton.autoSetDimension(.height, toSize: 30)
        postRequestButton.autoSetDimension(.width, toSize: 200)

        postRequestButton.addTarget(self, action: #selector(postRequest(_:)), for: .touchUpInside)

        
        postGalleryButton.autoPinEdge(toSuperviewEdge: .left, withInset: 50)
        postGalleryButton.autoPinEdge(.top, to: .bottom, of: postRequestButton, withOffset: 30)
        postGalleryButton.autoSetDimension(.height, toSize: 30)
        postGalleryButton.autoSetDimension(.width, toSize: 200)
        
        postGalleryButton.addTarget(self, action: #selector(postGallery(_:)), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
//        searchBar.becomeFirstResponder()
    }
    
    func postRequest(_ b: UILabel) {
        let vc = RequestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func postGallery(_ b: UILabel) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - Delegates
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("\(info)")
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData:NSData = UIImagePNGRepresentation(chosenImage)! as NSData
        let strBase64 = imageData.base64EncodedString()

        let parameters = [
            "gallery": [
                "id": 1,
                "seq": 2,
                "caption": "hoge caption",
                "briefInfo": "hoge briefInfo",
                "freeText": "hoge freeText",
                "eventId": 1,
                "islandId": 1
            ],
            "content": [
                "mime": "hoge mime",
                "name": "hoge name",
                "link_url": "hoge link url",
                "data": strBase64
            ]
        ]
        
        LoadingProxy.on()
        
        let urlString = "http://dev.mitty.co/api/gallery/content"
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseString { response in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    self.dismiss(animated:true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    
    
}

// MARK: - UISearchBarDelegate
extension QuestViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
        // 非同期方式で処理を呼び出す。
        eventSearch.searchBar.text = searchBar.text
        eventSearch.shallWeSearch = true
        self.navigationController?.pushViewController(eventSearch, animated: true)
        
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
