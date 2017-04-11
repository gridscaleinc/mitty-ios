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

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    var welcomeLabel = UILabel()
    var usernameField = UITextField()
    var passwordField = UITextField()
    var signupButton = UIButton()
    var linkButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        welcomeLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        welcomeLabel.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2 - 100)
        welcomeLabel.text = "Mittyへようこそ / ユーザー登録"
        self.view.addSubview(welcomeLabel)
        
        
        usernameField.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        usernameField.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2 - 20)
        usernameField.placeholder = "ユーザーID"
        usernameField.delegate = self
        self.view.addSubview(usernameField)

        passwordField.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        passwordField.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2 + 20)
        passwordField.placeholder = "パスワード"
        passwordField.delegate = self
        
        self.view.addSubview(passwordField)
        
        signupButton.frame = CGRect(x: 0, y: 0, width: 140, height: 40)
        signupButton.setTitle("Signup", for: UIControlState.normal)
        signupButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        signupButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2+100)
        signupButton.addTarget(self, action: #selector(self.onClickSignupButton(_:)), for: .touchUpInside)
        signupButton.layer.borderWidth = 1
        signupButton.layer.cornerRadius = 10
        self.view.addSubview(signupButton)

        linkButton.frame = CGRect(x: 0, y: 0, width: 140, height: 40)
        linkButton.setTitle("SignIn", for: UIControlState.normal)
        linkButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        linkButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2+150)
        linkButton.addTarget(self, action: #selector(self.onClickLinkButton(_:)), for: .touchUpInside)
        linkButton.layer.borderWidth = 1
        linkButton.layer.cornerRadius = 10
        self.view.addSubview(linkButton)
        
        LoadingProxy.set(self)
        
    }
    
    func onClickSignupButton(_ sender: UIButton){
        let urlString = "http://dev.mitty.co/api/signup"
        let parameters: Parameters = [
            "user_name": usernameField.text!,
            "password": passwordField.text!
        ]
        Alamofire.request(urlString, method: .post, parameters: parameters, headers: nil).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                let vc = SigninViewController()
                self.present(vc, animated: true, completion: nil)
            case .failure(let error):
                LoadingProxy.off()
                self.signupButton.isEnabled = true
                print(error)
            }
        }
    }

    func onClickLinkButton(_ sender: UIButton){
        let vc = SigninViewController()
        self.present(vc, animated:true, completion:nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
