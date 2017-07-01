//
//  SampleViewController.swift
//  mitty
//
//  Created by gridscale on 2016/10/31.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class PersonalInfoViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let picture : Control = MQForm.button(name: "m2", title: "aa")
    
    let signOut : Control = MQForm.button(name: "signOut", title: "Sign Out")
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "個人情報詳細表示"
        
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.9)
        
        self.view.addSubview(picture.button)
        picture.button.setImage(UIImage(named: "pengin2")?.af_imageRoundedIntoCircle(), for: .normal)
        picture.layout {
            p in
            p.button.autoPin(toTopLayoutGuideOf: self, withInset: 70)
            p.button.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            p.height(80).width(80)
            p.button.backgroundColor  = .clear
        }
        
        picture.bindEvent(.touchUpInside) { _ in
            self.pictureTaped()
        }
        
        
        self.view.addSubview(signOut.view)
        signOut.button.autoPin(toBottomLayoutGuideOf: self, withInset: 5)
        signOut.button.autoPinEdge(toSuperviewEdge: .left, withInset: 60)
        signOut.button.autoPinEdge(toSuperviewEdge: .right, withInset: 60)
        signOut.height(50)
        
        signOut.bindEvent(.touchUpInside) { b in
            ApplicationContext.killSession()
        }
        
        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()
        
    }
    
    func pictureTaped() {
        pickImage()
    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        if (!didSetupConstraints) {
            picture.configLayout()
            
            didSetupConstraints = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pickImage () {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    //MARK: - Delegates
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("\(info)")
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let iconimage = chosenImage.af_imageScaled(to: CGSize(width: 80, height: 80))
        self.dismiss(animated: false, completion: nil)

        // upload
        ContentService.instance.uploadContent(img: iconimage) { 
            contentId in
            UserService.instance.setUserIcon(contentId)
        }
        
    }
    
}
