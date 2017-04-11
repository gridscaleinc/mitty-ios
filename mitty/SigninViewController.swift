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
    
    var welcomeLabel = UILabel()
    var usernameField = StyledTextField()
    var passwordField = StyledTextField()
    var signupButton = UIButton()
    var linkButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        welcomeLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        welcomeLabel.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2 - 100)
        welcomeLabel.text = "Mittyへようこそ / ユーザーログイン"
        self.view.addSubview(welcomeLabel)
        
        
        usernameField.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        usernameField.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2 - 20)
        usernameField.placeholder = "👩 ユーザーID"
        usernameField.delegate = self
        self.view.addSubview(usernameField)
        
        passwordField.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        passwordField.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2 + 20)
        passwordField.placeholder = "🔐 パスワード"
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        self.view.addSubview(passwordField)
        
        signupButton.frame = CGRect(x: 0, y: 0, width: 140, height: 40)
        signupButton.setTitle("Login", for: UIControlState.normal)
        signupButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        signupButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2+100)
        signupButton.addTarget(self, action: #selector(self.onClickSignupButton(_:)), for: .touchUpInside)
        signupButton.layer.borderWidth = 1
        signupButton.layer.cornerRadius = 10
        self.view.addSubview(signupButton)
        
        linkButton.frame = CGRect(x: 0, y: 0, width: 140, height: 40)
        linkButton.setTitle("SignUp", for: UIControlState.normal)
        linkButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        linkButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2+150)
        linkButton.addTarget(self, action: #selector(self.onClickLinkButton(_:)), for: .touchUpInside)
        linkButton.layer.borderWidth = 1
        linkButton.layer.cornerRadius = 10
        self.view.addSubview(linkButton)

        LoadingProxy.set(self)
        
    }
    
    func onClickSignupButton(_ sender: UIButton){
        let urlString = "http://dev.mitty.co/api/signin"
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
                let av = UIAlertView(title: "Error", message:error.localizedDescription, delegate: nil, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                av.show()
                print(error)
            }
        }
    }
    
    func onClickLinkButton(_ sender: UIButton){
        let vc = SignupViewController()
        self.present(vc, animated:true, completion:nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
