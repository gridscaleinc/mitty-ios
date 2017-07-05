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
    
    let presenceForm = PresenceForm.newAutoLayout()
    
    let footmarkForm = FootMarkForm.newAutoLayout()
    
    let nameCardForm = NameCardForm.newAutoLayout()
    
    let cameraButton = MQForm.button(name: "cameraButton", title: "+写真")
    
    let nameCardBUtton = MQForm.button(name: "cameraButton", title: "+名刺")
    
    let okButton = MQForm.button(name: "cameraButton", title: "Check in")

    let form = MQForm.newAutoLayout()
    
    
    
    // ビューが表に戻ったらタイトルを設定。
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = LS(key: "operation_center")
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
        
        self.view.addSubview(presenceForm)
        
        presenceForm.load()
        
        self.view.addSubview(footmarkForm)
        footmarkForm.load()
        
        self.view.addSubview(nameCardForm)
        nameCardForm.load()
        
        view.setNeedsUpdateConstraints()
        
        print(self.topLayoutGuide)
    }
    
    var didSetupConstraints = false
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
            form.autoPin(toBottomLayoutGuideOf: self, withInset: 0)
            form.autoPinEdge(toSuperviewEdge: .left)
            form.autoPinEdge(toSuperviewEdge: .right)
            
            form.configLayout()
            
            presenceForm.autoPinEdge(.left, to: .right, of: picture.view, withOffset: 10)
            presenceForm.autoPinEdge(.top , to: .top, of:  picture.view)
            presenceForm.autoSetDimensions(to: CGSize(width: 100, height:100))
            
            presenceForm.configLayout()
            
            footmarkForm.autoPinEdge(.top, to: .bottom, of: picture.view, withOffset: 0)
            footmarkForm.autoPinEdge(.left , to: .left, of:  picture.view)
            footmarkForm.autoSetDimensions(to: CGSize(width: 200, height:70))
            
            footmarkForm.configLayout()
            
            nameCardForm.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            nameCardForm.autoPinEdge(.top, to: .bottom, of: footmarkForm, withOffset: 30)
            nameCardForm.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            nameCardForm.autoSetDimension(.height, toSize: 230)
            // nameCardForm.clipsToBounds = true
            
            nameCardForm.configLayout()
            
            didSetupConstraints = true
        }
        
        picture.widthConstraints?.autoRemove()
        picture.width(161*picture.image.image!.size.ratio)
        
        super.updateViewConstraints()
        
    }
    
    func loadForm () {
        form.backgroundColor = .white
        
        form +++ picture.layout {
            p in
            p.height(100).width(100).leftMost(withInset: 30).upper(withInset: 10)
        }
        
        let row = Row.Intervaled().height(50)
        
        row +++ cameraButton.layout {
            c in
            c.height(40)
            c.button.backgroundColor = MittyColor.healthyGreen
        }
        
        row +++ nameCardBUtton.layout {
            c in
            c.height(40)
            c.button.backgroundColor = MittyColor.healthyGreen
        }

        row +++ okButton.layout {
            c in
            c.height(40)
        }

        row.layout {
            r in
            r.down(withInset: 10).fillHolizon()
        }
        
        form +++ row
        
        cameraButton.bindEvent(.touchUpInside) {
            b in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                imagePicker.cameraDevice = .front
                imagePicker.cameraFlashMode = .off
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        nameCardBUtton.bindEvent(.touchUpInside) { [weak self]
            b in
            self?.nameCardForm.isHidden = !(self?.nameCardForm.isHidden)!
        }
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("\(info)")
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let ratio = chosenImage.size.ratio
            picture.image.image = chosenImage.af_imageScaled(to: CGSize(width: 100, height: 100 * ratio))
            imagePicked = true
            self.view.needsUpdateConstraints()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        print(self.topLayoutGuide)
    }
}
