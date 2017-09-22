//
//  CheckinViewController.swift
//  mitty
//
//  Created by gridscale on 2017/05/27.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class CheckinViewController: MittyViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicked = false
    let picture: Control = {
        let i = MQForm.img(name: "picture", url: "pengin1")
        i.imageView.contentMode = .scaleAspectFit
        return i
    } ()

    var userInfo: UserInfo!
    var destination: Destination!

    let presenceForm = PresenceForm.newAutoLayout()

    let footmarkForm = FootMarkForm.newAutoLayout()

    let nameCardForm = NameCardForm()

    let cameraButton = MQForm.button(name: "cameraButton", title: "+写真")

    let nameCardBUtton = MQForm.button(name: "cameraButton", title: "+名刺")

    let okButton = MQForm.button(name: "cameraButton", title: "Check in")

    let form = MQForm.newAutoLayout()

    var namecard = NameCardInfo()

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

        super.autoCloseKeyboard()

        self.view.addSubview(form)

        loadForm()

        self.view.addSubview(presenceForm)

        presence()

        self.view.addSubview(footmarkForm)
        footmarkForm.load()

        self.view.addSubview(nameCardForm.view)
        nameCardForm.load(NameCardInfo())
        // nameCardForm.view.transform = CGAffineTransform(scaleX: 0.52, y: 0.52);
        view.setNeedsUpdateConstraints()

        okButton.bindEvent(.touchUpInside) {
            _ in
            self.doCheckin()
        }

    }

    var didSetupConstraints = false

    override func updateViewConstraints() {

        if (!didSetupConstraints) {
            form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
            form.autoPin(toBottomLayoutGuideOf: self, withInset: 0)
            form.autoPinEdge(toSuperviewEdge: .left)
            form.autoPinEdge(toSuperviewEdge: .right)

            form.configLayout()

            presenceForm.autoPinEdge(.left, to: .right, of: picture.view, withOffset: 20)
            presenceForm.autoPinEdge(toSuperviewEdge: .right, withInset: 10)

            presenceForm.autoPinEdge(.top, to: .top, of: picture.view)
            presenceForm.autoSetDimension(.height, toSize: 100)
            presenceForm.configLayout()

            footmarkForm.autoPinEdge(.top, to: .bottom, of: picture.view, withOffset: 0)
            footmarkForm.autoPinEdge(.left, to: .left, of: picture.view)
            footmarkForm.autoSetDimensions(to: CGSize(width: 200, height: 70))

            footmarkForm.configLayout()

            nameCardForm.view.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            nameCardForm.view.autoPinEdge(.top, to: .bottom, of: footmarkForm, withOffset: 10)
            nameCardForm.view.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            nameCardForm.view.autoSetDimension(.height, toSize: 250)
            // nameCardForm.clipsToBounds = true

            nameCardForm.configLayout()

            didSetupConstraints = true
        }

        picture.widthConstraints?.autoRemove()
        picture.width(70 * picture.imageView.image!.size.ratio)

        super.updateViewConstraints()

    }

    func loadForm () {
        form.backgroundColor = .white


        form +++ picture.layout {
            p in
            p.height(70).width(70).leftMost(withInset: 30).upper(withInset: 10)
        }

        let row = Row.Intervaled().height(50)
        row.spacing = 10

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
            let picker = NamecardPicker(onSelected: { card in
                self?.namecard = card
                self?.nameCardForm.load(card)
            }, onClear: {
                self?.namecard = NameCardInfo()
                self?.nameCardForm.load((self?.namecard)!)
            })

            self?.navigationController?.pushViewController(picker, animated: true)
        }
    }

    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        NSLog("\(info)")
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let ratio = chosenImage.size.ratio
            picture.imageView.image = chosenImage.af_imageScaled(to: CGSize(width: 70, height: 70 * ratio))
            imagePicked = true
            self.view.needsUpdateConstraints()
        }
        self.dismiss(animated: false, completion: nil)
    }

    override func viewWillLayoutSubviews() {
        print(self.topLayoutGuide)
    }

    func presence () {
        let uid = String(ApplicationContext.userSession.userId)

        UserService.instance.getUserInfo(id: uid, callback: {
            uinfo, exists in
            if exists {
                self.userInfo = uinfo!
                self.presenceForm.id(String(uinfo!.id))
                self.presenceForm.name(uinfo!.userName)
                self.presenceForm.load()
                self.presenceForm.configLayout()
                self.picture.imageView.setMittyImage(url: uinfo!.icon)
            }
        })
    }

    func footmark(_ destination: Destination) {
        self.destination = destination
        footmarkForm.event(destination.eventTitle)
        footmarkForm.island(destination.islandName)
    }

    func doCheckin() {
        PresenceService.instance.checkIn(destination,
                                         self.namecard.id,
                                         picId: 0,
                                         info: self.footmarkForm.addInfo.textField.text,
                                         onError: { error in
                                             self.showError("Ccheck in error!")
                                         })
        self.navigationController?.popViewController(animated: true)
    }
}
