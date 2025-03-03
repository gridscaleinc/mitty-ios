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

class SignupViewController: MittyViewController, UITextFieldDelegate {


    var signupForm = MQForm.newAutoLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        super.autoCloseKeyboard()

        self.view.backgroundColor = UIColor.white

        buildLoginForm()
        self.view.addSubview(signupForm)

        signupForm.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        signupForm.autoPinEdge(toSuperviewEdge: .left)
        signupForm.autoPinEdge(toSuperviewEdge: .right)
        signupForm.autoPinEdge(toSuperviewEdge: .bottom)

        signupForm.configLayout()

        LoadingProxy.set(self)

    }

    func buildLoginForm () {

        let header = Header()
        header.title = "Title"
        signupForm += header

        header.layout() { (v) in
            v.upper().height(30)
        }

        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 600)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false

        let signupContainer = Container(name: "Signup-container", view: scroll)

        signupForm +++ signupContainer

        signupContainer.layout() { (container) in
            container.putUnder(of: header).fillHolizon().down(withInset: 10)
        }

        let inputForm = Section(name: "Input-Form", view: UIView.newAutoLayout())
        signupContainer +++ inputForm

        inputForm.layout() { c in
            c.upper().width(UIScreen.main.bounds.size.width).height(600)
        }

        var row = Row.LeftAligned()

        row +++ MQForm.img(name: "icon", url: "AppIcon").layout() { c in
            c.height(50).width(50).leftMargin(30).verticalCenter()
        }
        row +++ MQForm.label(name: "welcome-message", title: "Mittyへようこそ").layout() {
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
        row +++ MQForm.text(name: "userId", placeHolder: "👩 ユーザーID").width(200).layout() {
            c in
            c.height(50).leftMargin(30).verticalCenter()
        }

        row.layout() {
            r in
            r.height(70).fillHolizon()
        }
        inputForm <<< row

        row = Row.LeftAligned()
        row +++ MQForm.text(name: "password", placeHolder: "🔐 パスワード").width(200).layout() {
            c in
            (c.view as! UITextField).isSecureTextEntry = true
            c.height(50).leftMargin(30).verticalCenter()
        }

        row.layout() {
            r in
            r.height(70).fillHolizon()
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
        let signupButton = MQForm.button(name: "Signup", title: "Sign up").layout() {
            c in
            c.height(30).width(140).leftMargin(30).verticalCenter()
        }
        row +++ signupButton

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

        row = Row.RightAligned()

        let instantUse = MQForm.label(name: "using-withoudid", title: "ログインなしで利用へ").layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.systemFont(ofSize: 15)
            l.textColor = UIColor.brown
            l.textAlignment = .right

            c.width(350).height(50).rightMargin(-35).verticalCenter()
        }

        row +++ instantUse
        row.layout() {
            r in
            r.height(100).fillHolizon(40)
        }

        inputForm <<< row

        signupButton.bindEvent(.touchUpInside) { [weak self] b in
            self!.onClickSignupButton(b as! UIButton)
        }

        instantUse.bindEvent(.touchUpInside) { v in
            let vc = MittyNavigatorViewController()
            self.present(vc, animated: true, completion: nil)
        }
    }

    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    func onClickSignupButton(_ sender: UIButton) {
        
        let urlString = MITTY_SERVICE_BASE_URL + "/signup"
        let usernameField = signupForm.quest("[name=userId]").control()?.view as! UITextField
        let passwordField = signupForm.quest("[name=password]").control()?.view as! UITextField
        let mail_address = signupForm.quest("[name=mailAddress]").control()?.view as! UITextField
        
        if (usernameField.text == "" || passwordField.text == "" || mail_address.text == "") {
            showError("ユーザー名、password、mail addressを入力してください。")
        }
    
        let parameters: Parameters = [
            "user_name": usernameField.text!.trimmingCharacters(in: .whitespaces),
            "password": passwordField.text!.trimmingCharacters(in: .whitespaces),
            "mail_address": mail_address.text!.trimmingCharacters(in: .whitespaces)
        ]

        let api = APIClient(path: "/signup", method: .post, parameters: parameters)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let vc = SigninViewController()
            self.present(vc, animated: true, completion: nil)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
            let errorMessage = self.signupForm.quest("[name=errormessage]").control()?.view as! UILabel
            errorMessage.text = "ユーザーIDやパスワード、メールアドレスを確認してください。"
            let signupButton = self.signupForm.quest("[name=Signup]").control()?.view as! UIButton
            signupButton.isEnabled = true
        })
    }

}
