//
//  CheckinViewController.swift
//  mitty
//
//  Created by gridscale on 2017/05/27.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class CheckinViewController : MittyViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicked = false
    let picture : Control = {
        let i = MQForm.img(name: "picture", url: "beauty.jpeg")
        i.image.contentMode = .scaleAspectFit
        return i
    } ()
    
    let cameraButton = MQForm.button(name: "cameraButton", title: "+ Your photo")
    
    let form = MQForm.newAutoLayout()
    
    // ビューが表に戻ったらタイトルを設定。
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = LS(key: "operation_center")
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // ビューが非表示になる直前にタイトルを「...」に変える。
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "..."
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(form)
        
        loadForm()
        view.setNeedsUpdateConstraints()
    }
    
    var didSetupConstraints = false
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        if (!didSetupConstraints) {
            form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
            form.autoPin(toBottomLayoutGuideOf: self, withInset: 0)
            form.autoPinEdge(toSuperviewEdge: .left)
            form.autoPinEdge(toSuperviewEdge: .right)
            
            form.configLayout()
            didSetupConstraints = true
        }
        
        picture.widthConstraints?.autoRemove()
        picture.width(161*picture.image.image!.size.ratio)
    }
    
    func loadForm () {
        form.backgroundColor = .white
        
        form +++ picture.layout {
            p in
            p.height(161).width(100).leftMost(withInset: 30).upper(withInset: 30)
        }
        
        form +++ cameraButton.layout {
            c in
            c.height(40).width(130).down(withInset: 10).leftMost(withInset: 50)
        }
        
        cameraButton.bindEvent(.touchUpInside) {
            b in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                imagePicker.cameraDevice = .front
                imagePicker.cameraFlashMode = .off
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("\(info)")
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let ratio = chosenImage.size.ratio
            picture.image.image = chosenImage.af_imageScaled(to: CGSize(width: 100, height: 100 * ratio))
            self.dismiss(animated: false, completion: nil)
            imagePicked = true
            self.view.needsUpdateConstraints()
        }
    }
}
