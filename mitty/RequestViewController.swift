//
//  RequestViewController.swift
//  mitty
//
//  Created by gridscale on 2017/04/18.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class RequestViewController : MittyViewController {
    
    var relatedActivity : ActivityInfo? = nil
    
    let form : MQForm = MQForm.newAutoLayout()
    
    let titleText = MQForm.text(name: "title-text", placeHolder: "タイトルを入力")
    let tag = MQForm.text(name: "tag", placeHolder: "TAG")
    
    let descriptionText = MQForm.textView(name: "desciption")
    let locationText = MQForm.text(name: "locationInfo", placeHolder: "エリア、場所")
    let preferredDatetime1 = MQForm.text(name: "startDate", placeHolder: "この日から")
    let preferredDatetime2 = MQForm.text(name: "endDate", placeHolder: "この日の間")
    
    let startPrice = MQForm.text(name: "startPrice", placeHolder: "ここから")
    let limitedPrice = MQForm.text(name: "limitedPrice", placeHolder: "ここまで")
    let numOfPerson = MQForm.text(name: "numOfPerson", placeHolder: "人数")
    let expiryDate = MQForm.text(name: "expiryDate", placeHolder: "提案締切日")
    let postButton = MQForm.button(name: "Post", title: "Post Request")
    
    override func viewDidLoad() {
        
        super.autoCloseKeyboard()
        
        buildForm()
        
        self.view.addSubview(form)
        self.view.backgroundColor = .white
        form.autoPinEdgesToSuperviewEdges()
        form.configLayout()

    }
    
    func buildForm() {
        
        let height_normal : CGFloat = 60.0
        let height_tall : CGFloat = 100.0
        let height_middle : CGFloat = 80.0
        
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:900)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        
        let loginContainer = Container(name: "Request-form", view: scroll)
        
        form +++ loginContainer
        
        loginContainer.layout() { (container) in
            container.upper().fillHolizon().down(withInset: 10)
        }

        let inputForm = Section(name: "Input-Form", view: UIView.newAutoLayout())
        loginContainer +++ inputForm
        
        inputForm.layout() { c in
            c.upper().width(UIScreen.main.bounds.size.width).height(900)
        }
        
        var row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(0).height(40)
            r.view.backgroundColor = .red
        }
        
        row +++ MQForm.label(name: "Postrequest", title: "Post request").layout {
            c in
            c.height(40).width(300)
            c.leftMost(withInset: 20)
            let l = c.view as! UILabel
            l.textColor = .white
            l.font = .systemFont(ofSize: 18)
        }
        
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_normal)
        }
        
        row +++ MQForm.label(name: "Title", title: "タイトル").layout {
            c in
            c.height(height_normal).width(70)
            c.leftMost(withInset: 20)
        }
        
        row +++ titleText.width(350).layout {
            t in
            t.height(height_normal).rightMost()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_normal)
        }
        
        row +++ MQForm.label(name: "TagLabel", title: "Tag").layout {
            c in
            c.height(height_normal).width(70)
            c.leftMost(withInset: 20)
        }
        
        row +++ tag.width(350).layout {
            t in
            t.height(height_normal).rightMost()
        }
        inputForm <<< row

        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(120)
        }
        
        row +++ MQForm.label(name: "detail", title: "内容").layout {
            c in
            c.height(height_middle).width(70)
            c.leftMost(withInset: 20)
        }
        
        row +++ descriptionText.width(350).layout {
            t in
            t.height(height_tall).rightMost()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_tall)
        }
        
        row +++ MQForm.label(name: "lacation", title: "場所").layout {
            c in
            c.height(height_middle).width(70)
            c.leftMost(withInset: 20)
        }
        
        row +++ locationText.width(350).layout {
            t in
            t.height(height_tall).rightMost()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_normal)
        }
        row +++ MQForm.label(name: "Title", title: "希望日程").layout {
            c in
            c.height(height_normal).width(65)
            c.leftMost(withInset: 20)
        }
        row +++ preferredDatetime1.width(120).layout {
            t in
            t.height(height_normal)
        }
        row +++ preferredDatetime2.width(120).layout {
            t in
            t.height(height_normal)
        }
        
        let dp1 = UIDatePicker.newAutoLayout()
        dp1.datePickerMode = .date
        preferredDatetime1.textField.inputView = dp1
        
        let dp2 = UIDatePicker.newAutoLayout()
        dp2.datePickerMode = .date
        preferredDatetime2.textField.inputView = dp2
        
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_normal)
        }
        row +++ MQForm.label(name: "priceTitle", title: "価格範囲").layout {
            c in
            c.height(height_normal).width(65)
            c.leftMost(withInset: 20)
        }
        row +++ startPrice.width(90).layout {
            t in
            t.height(height_normal)
        }
        row +++ limitedPrice.width(120).layout {
            t in
            t.height(height_normal)
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(20).height(height_middle)
        }
        row +++ MQForm.label(name: "title2", title: "人数").layout {
            c in
            c.height(height_normal).width(65)
            c.leftMost(withInset: 20)
        }
        
        row +++ numOfPerson.width(70).layout {
            t in
            t.height(height_normal)
        }
        row +++ MQForm.label(name: "title3", title: "締切").layout {
            c in
            c.height(height_normal).width(40)
        }
        row +++ expiryDate.width(120).layout {
            t in
            t.height(height_normal)
        }
        let dp3 = UIDatePicker.newAutoLayout()
        dp3.datePickerMode = .date
        expiryDate.textField.inputView = dp3
        
        inputForm <<< row
        
        row = Row.Intervaled()
        row.layout {
            r in
            r.fillHolizon().height(height_middle)
        }
        row +++ postButton.layout { button in
            button.fillHolizon(60).height(50)
            let b = button.view as! UIButton
            b.backgroundColor = .orange
        }
        
        row["Post"]?.bindEvent(.touchUpInside) { [weak self] btn in
            self?.postRequest()
        }
        
        inputForm <<< row
        
    }
    
    func postRequest () {
        
        let newRequest = NewRquestReq()
        
        if (titleText.textField.text == nil || titleText.textField.text == "") {
            showError("タイトルを入力してください")
            return
        }
        
        if (descriptionText.textView.text == nil || descriptionText.textView.text == "") {
            showError("内容を入力してください")
            return
        }

        if (tag.textField.text == nil || tag.textField.text == "") {
            showError("TAGを入力してください")
            return
        }
        
        newRequest.setStr(.title, titleText.textField.text)
        newRequest.setStr(.tagList, tag.textField.text)
        newRequest.setStr(.description, descriptionText.textView.text)
        newRequest.setStr(.startPlace, locationText.textField.text)
        
        if (preferredDatetime2.textField.text != "") {
            let dp = preferredDatetime1.textField.inputView as! UIDatePicker
            newRequest.setDate(.preferredDatetime1, dp.date)
        }
        
        if (preferredDatetime2.textField.text != "") {
            let dp = preferredDatetime2.textField.inputView as! UIDatePicker
            newRequest.setDate(.preferredDatetime2, dp.date)
        }
        
        if let price = startPrice.textField.text {
            newRequest.setInt(.preferredPrice1, price)
        }
        
        if let price = limitedPrice.textField.text {
            newRequest.setInt(.preferredPrice2, price)
        }
        
        let urlString = "http://dev.mitty.co/api/new/request"
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        print(newRequest.parameters)
        Alamofire.request(urlString, method: .post, parameters: newRequest.parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { [weak self] response in

            LoadingProxy.off()

            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    
                    let requestId = json["id"].stringValue
 
                    print(requestId)
                    
                }
                
                self?.navigationController?.popViewController(animated: false)
                
            case .failure(let error):
                print(response.debugDescription)
                print(response.data ?? "No Data")
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    
                    self?.showError("error occored" + (json as AnyObject).description)
                    
                } catch {
                    print("Serialize Error")
                }
                
                print(response.description)
                
                print(error)
            }
        }
        
    }
    
}
