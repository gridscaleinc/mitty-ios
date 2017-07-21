//
//  WebPicker.swift
//  mitty
//
//  Created by gridscale on 2017/05/31.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import WebKit
import SwiftyJSON
import Alamofire

class PickedInfo {
    var hasError = false
    var imgUrl = ""
    var height = 0
    var width = 0
    
    var siteUrl = ""
    var siteTitle = ""
    var siteImage : UIImage? = nil
    
}

protocol WebPickerDelegate : class {
    func webpicker(_ picker: WebPicker?, _ info: PickedInfo) -> Void
}

class WebPicker : MittyViewController , UISearchBarDelegate {
    
    var initKey = ""
    
    var initUrl = ""
    
    // Search Box
    let searchBox : UISearchBar = {
        let t = UISearchBar()
        t.placeholder = "検索キー"
        t.showsCancelButton = false
        return t
    }()

    var webView: WKWebView!
    weak var bascket : PickedInfo? = nil
    weak var delegate : WebPickerDelegate?
    
    var form = MQForm.newAutoLayout()
    var container = Container(name:"scroll-view", view: UIScrollView.newAutoLayout())
    
    var siteTitle = MQForm.label(name: "siteTitle", title: "")
    var siteUrl = MQForm.label(name: "siteUrl", title: "")
    var siteImage = Control(name:"siteImage", view: UIImageView.newAutoLayout())
    let pickButton = MQForm.button(name: "pick", title: "pick").height(20).width(80)
    
    //
    // Viewの読み込み。
    //
    override func loadView() {
        
        super.loadView()
        self.navigationItem.title = "ウェブからイベント検索"
        self.view.backgroundColor = UIColor.white
        
        pickButton.bindEvent(.touchUpInside) {
            b in
            self.pickTheSite()
        }
        configureNavigationBar()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isToolbarHidden = true
        self.view.addSubview(searchBox)
        
        // init and load request in webview.
        webView = WKWebView(frame: CGRect.zero)
        
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        
        isDidSetupViewConstraints = false
        view.setNeedsUpdateConstraints()
        showSearchBox()
        
        if (initUrl != "") {
            let myURL = URL(string: initUrl)
            let myRequest = URLRequest(url: myURL!)

            webView.load(myRequest)
        } else if (initKey != "") {
            searchBox.text = initKey
            searchBarSearchButtonClicked(searchBox)
        }
    }
    
    
    // navigation bar の初期化をする
    private func configureNavigationBar() {
        
        let searchItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target:self, action:#selector(showSearchBox))
        
        let doneItem = UIBarButtonItem(customView: pickButton.button )
        
        let rightItems = [doneItem, searchItem]
        navigationItem.setRightBarButtonItems(rightItems, animated: true)
        
    }
    
    
    typealias SearchHandler = (_ searchBar: UISearchBar) -> Void
    
    var handleSearch : SearchHandler?
    
    func showSearchBox() {
        let naviItem = self.navigationItem
        let titleView = self.navigationItem.titleView
        self.navigationItem.titleView = searchBox
        // nest function　to serve search event
        form.isHidden = true
        func searchIt (_ searchBar: UISearchBar) -> Void {
            naviItem.titleView = titleView
            configureNavigationBar()
            
            let query = ((searchBar.text) ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            let myURL = URL(string: "https://www.google.co.jp/search?q=" + query!)
            let myRequest = URLRequest(url: myURL!)
            
            webView.load(myRequest)

        }
        
        handleSearch = searchIt
        
        searchBox.delegate = self
        navigationItem.setRightBarButtonItems([], animated: true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if handleSearch != nil {
            form.isHidden = true
            handleSearch! (searchBar)
        }
    }
    
    func pickTheSite() {
        if (pickButton.button.titleLabel?.text == "Done") {
            self.navigationController?.popViewController(animated: true)
            if (delegate != nil) {
                bascket?.siteUrl = self.siteUrl.label.text ?? ""
                bascket?.siteTitle = self.siteTitle.label.text ?? ""
                bascket?.siteImage = self.siteImage.image.image
                delegate?.webpicker(self, bascket!)
            }
            
            return
        }
        
        webView.evaluateJavaScript(
            "(function() {var images=document.querySelectorAll(\"img\");var imageList=[];[].forEach.call(images, function(el) { var img={}; img.width=el.width; img.height=el.height;img.url=el.src;imageList[imageList.length] = img;}); var result={images:imageList};result.title=document.title;result.location=document.URL;return JSON.stringify(result);})()") {
            json , error in
            let info = PickedInfo()
            
            if (error != nil) {
                info.hasError = true
            }
            
            self.loadForm(json as! String)
            self.view.setNeedsUpdateConstraints()
            self.view.updateConstraintsIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    func clearContainer() {
        form.removeFromSuperview()
        form = MQForm.newAutoLayout()
        form.backgroundColor = .white
        
        container = Container(name:"scroll-view", view: UIScrollView.newAutoLayout())
        
        siteTitle = MQForm.label(name: "siteTitle", title: "")
        siteUrl = MQForm.label(name: "siteUrl", title: "")
        siteImage = Control(name:"siteImage", view: UIImageView.newAutoLayout())
    }
    
    func loadForm(_ json: String) {
        
        clearContainer()
        
        view.addSubview(form)
        
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        let row = Row.LeftAligned()
        row +++ MQForm.label(name: "titleLabel", title: " タイトル：").layout {
            l in
            l.height(40).width(100).leftMost().fillVertical()
            l.label.adjustsFontSizeToFitWidth = true
            l.label.backgroundColor = MittyColor.healthyGreen
        }

        row +++ siteTitle.layout{
            l in
            l.upper().rightMost().height(40)
            l.label.numberOfLines = 2
            l.label.adjustsFontSizeToFitWidth = true
        }
        
        form +++ row.layout {
            r in
            r.height(40).fillHolizon().upper()
        }
        
        let row1 = Row.LeftAligned()
        
        row1 +++ MQForm.label(name: "titleLabel", title: " URL：").layout {
            l in
            l.height(40).width(100).leftMost().upper()
            l.label.adjustsFontSizeToFitWidth = true
            l.label.backgroundColor = MittyColor.healthyGreen
        }

        row1 +++ siteUrl.layout{
            l in
            l.fillVertical().rightMost().height(20)
            l.label.numberOfLines = 2
            l.label.adjustsFontSizeToFitWidth = true
        }
        
        form +++ row1.layout {
            r in
            r.height(40).fillHolizon().putUnder(of: row, withOffset: 3)

        }
        
        let row2 = Row.LeftAligned()
        
        row2 +++ MQForm.label(name: "titelImage", title: " 画 像：").layout {
            l in
            l.height(40).width(100).leftMost().upper()
            l.label.adjustsFontSizeToFitWidth = true
            l.label.backgroundColor = MittyColor.healthyGreen
        }
        
        row2 +++ siteImage.layout {
            img in
            img.height(150).rightMost().putUnder(of: row1)
            img.image.contentMode = .scaleAspectFit
        }
        
        form +++ row2.layout {
            r in
            r.height(150).fillHolizon().putUnder(of: row1, withOffset: 3)
            
        }
        
        form +++ container.layout {
            c in
            c.fillHolizon().putUnder(of: self.siteImage).height(150)
        }

        let section = Row.LeftAligned()
        container +++ section
        
        // print(json)
        print(JSON(json))
        let result = JSON.parse(json)
        print (result["images"])
        var resultMap = [String : PickedInfo]()
        siteTitle.label.text = result["title"].stringValue
        siteUrl.label.text = result["location"].stringValue
        
        for (_, img) in result["images"] {
            
            let p = PickedInfo()
            
            p.imgUrl = img["url"].stringValue
            p.width = img["width"].intValue
            p.height = img["height"].intValue
            if (p.width<50 || p.height<50) {
                continue
            }
            if (p.imgUrl == "") {
                continue
            }
            
            if let url = URL(string: p.imgUrl) {
                if url.scheme == "data" {
                    continue
                }
            }
            
            resultMap[p.imgUrl] = p
        }
        
        var picks = resultMap.sorted {
            p1, p2 in
            if (p1.value.height > p2.value.height) {
                return true
            } else if (p1.value.height == p2.value.height) {
                if (p1.value.width > p2.value.width) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
            
        }
        
        if picks.count > 100 {
            picks.removeSubrange(100..<picks.count)
        }
        
        DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
        for p in picks {
            let v = TapableUIImageView.newAutoLayout()
            v.contentMode = .scaleAspectFit
            
            v.af_setImage(withURL: URL(string: p.value.imgUrl)! , placeholderImage: UIImage(named:"downloading")) {
                image in
                if (image.result.isSuccess) {
                    v.image = image.result.value
                } else {
                    v.image = UIImage(named: "broken")
                }
            }
            
            let imgControl = Control(name:"image", view: v).layout{
                i in
                i.upper().height(150)
            }
            v.isUserInteractionEnabled = true
            v.underlyObj = p
            
            section +++ imgControl
            
            imgControl.bindEvent(.touchUpInside) {
                img in
                self.bascket = p.value
                self.siteImage.image.image = (img as! UIImageView).image
                self.pickButton.button.setTitle("Done", for: .normal)
            }
            
        }

        let c = MQForm.label(name: "dummy", title: "<End>")
        section +++ c
        section.layout {
            s in
            s.rightAlign(with: c).fillParent().height(150)
        }
        
        form.configLayout()
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    var firstTime = true
    
    var isDidSetupViewConstraints = false
    
    // Call super
    override func updateViewConstraints() {
        if (!isDidSetupViewConstraints) {
            webView.autoPin(toTopLayoutGuideOf: self, withInset: 0)
            webView.autoPinEdge(toSuperviewEdge: .left)
            webView.autoPinEdge(toSuperviewEdge: .right)
            webView.autoSetDimension(.height, toSize: UIScreen.main.bounds.height)
            
            isDidSetupViewConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
