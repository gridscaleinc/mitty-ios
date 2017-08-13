//
//  ContentPicker.swift
//  mitty
//
//  Created by gridscale on 2017/08/09.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import MapKit
import Alamofire


@available(iOS 9.3, *)
class ContentPicker: MittyViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pickedContent: Content? = nil
    let pickedImg: Control = {
        let selectedImage = UIImageView()
        selectedImage.contentMode = .scaleAspectFit
        let c = Control(name: "selectedImg", view: selectedImage)

        return c
    } ()

    var candidates: [Content] = []
    var form = MQForm.newAutoLayout()

    let cameraButton = MQForm.button(name: "camera", title: "カメラ")
    let libButton = MQForm.button(name: "library", title: "ライブラリ")

    let okButton = MQForm.button(name: "ok", title: "OK")


    weak var delegate: ContentPickerDelegate? = nil

    var contentTable: Control = {
        let searchResultsTableView: UITableView = UITableView.newAutoLayout()
        let c = Control(name: "searchResult", view: searchResultsTableView)
        return c
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false

        // super.autoCloseKeyboard()

        self.view.backgroundColor = .white
        self.view.addSubview(form)

        form.autoPin(toTopLayoutGuideOf: self, withInset: 10)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        buildForm()
        form.configLayout()

        self.navigationItem.title = "画像選択"

        let tableView = contentTable.view as! UITableView
        tableView.delegate = self
        tableView.dataSource = self


        okButton.bindEvent(.touchUpInside) { [weak self]
            v in
            if (self?.delegate != nil && self?.pickedContent != nil) {
                self?.delegate?.pickedContent(content: (self?.pickedContent)!)
                self?.navigationController?.popViewController(animated: true)
            }
        }

        //
        libButton.bindEvent(.touchUpInside) {
            b in
            self.pickImage ()
        }


        loadContents()

    }

    //
    func buildForm () {

        let selectedRow = Row.LeftAligned().layout {
            r in
            r.fillHolizon(10).upper()
            r.bottomAlign(with: self.pickedImg)
            r.view.backgroundColor = .black
        }

        selectedRow +++ pickedImg.layout {
            i in
            i.leftMost(withInset: 10).height(120).width(120)
        }

        form +++ selectedRow

        // TODO
        form +++ contentTable.layout {
            m in
            m.fillHolizon(10).putUnder(of: selectedRow, withOffset: 4).down(withInset: 90)
        }

        let row = Row.Intervaled().layout {
            r in
            r.fillHolizon(10).height(50).down(withInset: 10)
        }

        row.spacing = 2
        row +++ cameraButton.layout {
            b in
            b.height(50)
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
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }

        row +++ libButton.layout {
            b in
            b.height(50)
        }

        row +++ okButton.layout {
            b in
            b.height(50)
        }

        form +++ row
    }

    func loadContents () {
        ContentService.instance.myContents() {
            contents in
            self.candidates = contents
            let searchResultsTableView = self.contentTable.view as! UITableView
            searchResultsTableView.reloadData()
        }
    }

    func pickImage () {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }

    }

    //MARK: - Delegates
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {

    }

    // image をとったらどうする。
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        NSLog("\(info)")
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        pickedImg.imageView.image = chosenImage
        picker.dismiss(animated: true)
    }

}

extension ContentPicker: UITableViewDelegate, UITableViewDataSource {

    // セルの作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let content = candidates[indexPath.row]

        // セルの作成とテキストの設定
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = content.title
        cell.textLabel?.textAlignment = .right

        DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
        cell.imageView?.af_setImage(withURL: URL(string: content.linkUrl!)!, placeholderImage: UIImage(named: "downloading"), completion: { image in
            if (image.result.isSuccess) {
                cell.imageView?.image = image.result.value
            }
        }
        )

        return cell
    }

    // セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let _ = tableView.cellForRow(at: indexPath) {
            pickedContent = candidates[indexPath.row]
            pickedImg.imageView.image = tableView.cellForRow(at: indexPath)?.imageView?.image
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.candidates.count
    }
}

protocol ContentPickerDelegate: class {
    func pickedContent(content: Content)
    func clearPickedContent()
}
