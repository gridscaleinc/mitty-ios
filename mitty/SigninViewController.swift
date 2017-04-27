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
        
        loginForm.autoPin(toTopLayoutGuideOf: self, withInset:0)
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
        scroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:600)
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
        
        row +++ loginForm.img(name: "icon" , url:"pengin4").layout() { c in
            c.height(50).width(50).leftMargin(30)
        }
        row +++ loginForm.label(name:"welcome-message", title: "Mittyへようこそ" ).layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.boldSystemFont(ofSize: 22)
            c.width(350).height(50).leftMargin(20)
        }

        row.layout() {
            r in
            r.height(70).fillHolizon(40)
        }
        inputForm <<< row
        
        
        row = Row.LeftAligned()
        row +++ loginForm.text(name: "userId" , placeHolder: "👩 ユーザーID" ).width(200).layout() {
            c in
            c.height(50).leftMargin(30)
        }
        
        row.layout() {
            r in
            r.height(70).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ loginForm.text(name: "password" , placeHolder: "🔐 パスワード" ).width(200).layout() {
            c in
            (c.view as! UITextField).isSecureTextEntry = true
            c.height(50).leftMargin(30)
        }
        
        row.layout() {
            r in
            r.height(70).fillHolizon()
        }
        inputForm <<< row
        
        
        row = Row.LeftAligned()
        let loginButton = loginForm.button(name: "Login" , title: "Login").layout() {
            c in
            c.height(30).width(140).leftMargin(30)
        }
        row +++ loginButton
        
        row.layout() {
            r in
            r.height(50).fillHolizon()
        }
        
        inputForm <<< row
        
        row = Row.LeftAligned()
        let errorMessage = loginForm.label(name:"errormessage", title: "" ).layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.systemFont(ofSize: 12)
            l.textColor = UIColor.red
            
            c.width(350).height(50).leftMargin(35)
        }
        
        row +++ errorMessage
        row.layout() {
            r in
            r.height(50).fillHolizon(40)
        }
        
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ loginForm.label(name:"forget-password", title: ".Passwordを忘れた場合" ).layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.systemFont(ofSize: 15)
            l.textColor = UIColor.blue
            
            c.width(350).height(50).leftMargin(35)
        }
        row.layout() {
            r in
            r.height(50).fillHolizon(40)
        }
        
        inputForm <<< row
        
        row = Row.LeftAligned()
        let signUpLabel = loginForm.label(name:"forget-password", title: ".初めて利用の方へ" ).layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.systemFont(ofSize: 15)
            l.textColor = UIColor.blue
            
            c.width(350).height(40).leftMargin(35)
        }
        row +++ signUpLabel
        row.layout() {
            r in
            r.height(40).fillHolizon(40)
        }
        
        inputForm <<< row

        
        row = Row.RightAligned()
        
        let instantUse = loginForm.label(name:"using-withoudid", title: "ログインなしで利用へ" ).layout() {
            c in
            let l = c.view as! UILabel
            l.font = UIFont.systemFont(ofSize: 15)
            l.textColor = UIColor.brown
            l.textAlignment = .right
            
            c.width(350).height(50).rightMargin(-35)
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
        
        signUpLabel.bindEvent(.touchUpInside) {[weak self] v in
            self!.onClickLinkButton(v as! UILabel)
        }

        
        instantUse.bindEvent(.touchUpInside) { v in
            let mainTabBarController: MainTabBarController = MainTabBarController()
            self.present(mainTabBarController, animated:true, completion:nil)
        }
    }
    
    func onClickSigninButton(_ sender: UIButton){
        let urlString = "http://dev.mitty.co/api/signin"
        
        let usernameField = loginForm.quest("[name=userId]").control()?.view as! UITextField
        let passwordField = loginForm.quest("[name=password]").control()?.view as! UITextField
        
        let parameters: Parameters = [
            "user_name": usernameField.text!,
            "password": passwordField.text!
        ]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, headers: nil).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    DispatchQueue.main.async {
                        let accessToken = json["access_token"].stringValue
                        let av = UIAlertView(title: "AccessToken", message:accessToken, delegate: nil, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                        av.show()
                        
                        let mainTabBarController: MainTabBarController = MainTabBarController()
                        self.present(mainTabBarController, animated:true, completion:nil)
                    }
                }
            case .failure(let error):
                LoadingProxy.off()
                let errorMessage = self.loginForm.quest("[name=errormessage]").control()?.view as! UILabel
                errorMessage.text = "ユーザーIDまたはパスワードが正しくない。"
                print(error)
            }
        }
    }
    
    func onClickLinkButton(_ sender: UILabel){
        let vc = SignupViewController()
        self.present(vc, animated:true, completion:nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
