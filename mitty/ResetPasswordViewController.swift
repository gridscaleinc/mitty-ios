//
//  ResetPasswordViewController.swift
//  mitty
//
//  Created by gridscale on 2017/10/15.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

//
//  SignupViewController.swift
//  mitty
//
//  Created by D on 2017/04/11.
//  Copyright © 2017 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ResetPasswordViewController: MittyViewController, UITextFieldDelegate {
    
    
    var form = MQForm.newAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.autoCloseKeyboard()
        
        self.view.backgroundColor = UIColor.white
        
        buildLoginForm()
        self.view.addSubview(form)
        
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        form.configLayout()
        
        LoadingProxy.set(self)
        
    }
    
    func buildLoginForm () {
        
        let header = Header()
        header.title = "Title"
        form += header
        
        header.layout() { (v) in
            v.upper().height(30)
        }
        
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 600)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        
        let container = Container(name: "container", view: scroll)
        
        form +++ container
        
        container.layout() { (container) in
            container.putUnder(of: header).fillHolizon().down(withInset: 10)
        }
        
        let inputForm = Section(name: "Input-Form", view: UIView.newAutoLayout())
        container +++ inputForm
        
        inputForm.layout() { c in
            c.upper().width(UIScreen.main.bounds.size.width).height(600)
        }
        
        var row = Row.LeftAligned()
        
        row +++ MQForm.img(name: "icon", url: "AppIcon").layout() { c in
            c.height(50).width(50).leftMargin(30).verticalCenter()
        }
        row +++ MQForm.label(name: "message", title: "パスワード初期化").layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.boldSystemFont(ofSize: 22)
            c.width(350).height(50).leftMargin(20).verticalCenter()
        }
        
        row.layout() {
            r in
            r.height(70).fillHolizon(40)
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ MQForm.text(name: "mailAddress", placeHolder: "📩 yourmail@yourdomain").width(200).layout() {
            c in
            c.height(50).leftMargin(30).verticalCenter()
        }
        
        row.layout() {
            r in
            r.height(70).fillHolizon()
        }
        inputForm <<< row
        
        
        row = Row.LeftAligned()
        let resetButton = MQForm.button(name: "send", title: "確定").layout() {
            c in
            c.height(30).width(140).leftMargin(30).verticalCenter()
        }
        row +++ resetButton
        
        row.layout() {
            r in
            r.height(50).fillHolizon()
        }
        
        inputForm <<< row
        
        row = Row.LeftAligned()
        let errorMessage = MQForm.label(name: "errormessage", title: "").layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.systemFont(ofSize: 12)
            l.numberOfLines = 0
            l.textColor = UIColor.red
            
            c.width(250).height(70).leftMargin(35).verticalCenter()
        }
        
        row +++ errorMessage
        row.layout() {
            r in
            r.height(50).fillHolizon(40)
        }
        
        inputForm <<< row
        
        resetButton.bindEvent(.touchUpInside) { [weak self] b in
            self!.onClickResetButton(b as! UIButton)
        }
        
        inputForm <<< Row.LeftAligned()
        
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    func onClickResetButton(_ sender: UIButton) {
        
        let urlString = MITTY_SERVICE_BASE_URL + "/reset_password/send"
        let mail_address = form.quest("[name=mailAddress]").control()?.view as! UITextField
        
        if (mail_address.text == "") {
            showError("mail addressを入力してください。")
            return
        }
        
        let parameters: Parameters = [
            "email": mail_address.text!.trimmingCharacters(in: .whitespaces)
        ]
        print(parameters)
        Alamofire.request(urlString, method: .post, parameters: parameters, headers: nil).validate(statusCode: 200..<300).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                self?.dismiss(animated: true, completion: nil)
            case .failure(let error):
                LoadingProxy.off()
                let errorMessage = self?.form.quest("[name=errormessage]").control()?.view as! UILabel
                errorMessage.text = "メールアドレスを確認してください。"
                print(error)
            }
        }

        call(url: urlString, method: .post, parameters: parameters) { (response) in
            switch response.result {
            case .success:
                LoadingProxy.off()
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                LoadingProxy.off()
                let errorMessage = self.form.quest("[name=errormessage]").control()?.view as! UILabel
                errorMessage.text = "メールアドレスを確認してください。"
                print(error)
            }
        }
    }
    
    func call(url: String, method: HTTPMethod, parameters: Parameters, callback: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url, method: method, parameters: parameters, headers: nil).validate(statusCode: 200..<300).responseJSON { response in
            callback(response)
        }
    }
}
