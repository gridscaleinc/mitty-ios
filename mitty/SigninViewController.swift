//
//  SigninViewController.swift
//  mitty
//
//  Created by D on 2017/04/11.
//  Copyright © 2017 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class SigninViewController: UIViewController, UITextFieldDelegate {

    var loginForm = MQForm.newAutoLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        buildLoginForm()
        self.view.addSubview(loginForm)

        loginForm.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        loginForm.autoPinEdge(toSuperviewEdge: .left)
        loginForm.autoPinEdge(toSuperviewEdge: .right)
        loginForm.autoPinEdge(toSuperviewEdge: .bottom)

        loginForm.configLayout()

        LoadingProxy.set(self)

    }

    func buildLoginForm () {

        let header = Header()
        header.title = "Title"
        loginForm += header

        header.layout() { (v) in
            v.upper().height(30)
        }

        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 600)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false

        let loginContainer = Container(name: "Login-form", view: scroll)

        loginForm +++ loginContainer

        loginContainer.layout() { (container) in
            container.putUnder(of: header).fillHolizon().down(withInset: 10)
        }

        let inputForm = Section(name: "Input-Form", view: UIView.newAutoLayout())
        loginContainer +++ inputForm

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
        let loginButton = MQForm.button(name: "Login", title: "Login").layout() {
            c in
            c.height(30).width(140).leftMargin(30).verticalCenter()
        }
        row +++ loginButton

        row.layout() {
            r in
            r.height(50).fillHolizon()
        }

        inputForm <<< row

        row = Row.LeftAligned()
        let errorMessage = MQForm.label(name: "errormessage", title: "").layout() {
            c in
            let l = c.view as! UILabel
            l.textColor = UIColor.red

            c.width(350).height(50).leftMargin(35).verticalCenter()
        }

        row +++ errorMessage
        row.layout() {
            r in
            r.height(50).fillHolizon(40)
        }

        inputForm <<< row

        row = Row.LeftAligned()
        let resetPassword = MQForm.label(name: "forget-password", title: ".Passwordを忘れた場合").layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.boldSystemFont(ofSize: 15)
            l.textColor = MittyColor.healthyGreen

            c.width(350).height(50).leftMargin(35).verticalCenter()
        }
        row +++ resetPassword
        row.layout() {
            r in
            r.height(50).fillHolizon(40)
        }

        inputForm <<< row

        row = Row.LeftAligned()
        let signUpLabel = MQForm.label(name: "forget-password", title: ".初めて利用の方へ").layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.boldSystemFont(ofSize: 15)
            l.textColor = MittyColor.sunshineRed

            c.width(350).height(40).leftMargin(35).verticalCenter()
        }
        row +++ signUpLabel
        row.layout() {
            r in
            r.height(40).fillHolizon(40)
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

        loginButton.bindEvent(.touchUpInside) { [weak self] b in
            self!.onClickSigninButton(b as! UIButton)
        }

        signUpLabel.bindEvent(.touchUpInside) { [weak self] v in
            self!.onClickLinkButton(v as! UILabel)
        }

        resetPassword.bindEvent(.touchUpInside) { [weak self] v in
            self!.resetPassword()
        }
        
        instantUse.bindEvent(.touchUpInside) { v in
            let mainTabBarController: MainTabBarController = MainTabBarController()
            self.present(mainTabBarController, animated: true, completion: nil)
        }
    }

    func onClickSigninButton(_ sender: UIButton) {

        let userName = loginForm.quest("[name=userId]").control()?.view as! UITextField
        let pwd = loginForm.quest("[name=password]").control()?.view as! UITextField

        UserService.instance.signin(userName: userName.text!.trimmingCharacters(in: .whitespaces), pwd: pwd.text!, onComplete: {
            uid, accessToken in
            ApplicationContext.userSession.accessToken = accessToken
            ApplicationContext.userSession.userId = uid
            ApplicationContext.userSession.userName = userName.text!
            ApplicationContext.userSession.isLogedIn = true
            ApplicationContext.saveSession()

            let mainTabBarController: MainTabBarController = MainTabBarController()
            self.present(mainTabBarController, animated: true, completion: nil)
        }, onError : {
           error in
           let errorMessage = self.loginForm.quest("[name=errormessage]").control()?.view as! UILabel
           errorMessage.text = error
           print(error)
        }
        )
    }

    func onClickLinkButton(_ sender: UILabel) {
        let vc = SignupViewController()
        self.present(vc, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resetPassword() {
        let vc = ResetPasswordViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
