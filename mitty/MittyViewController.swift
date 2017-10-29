//
//  MittyViewController.swift
//  mitty
//
//  Created by gridscale on 2017/05/14.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MittyViewController: UIViewController {

    var error: Control?
    var lock = NSLock()

    override var hidesBottomBarWhenPushed: Bool {
        get {
            if let c = self.navigationController {
                if c.viewControllers.count > 1 {
                    return true
                }
            }
            return super.hidesBottomBarWhenPushed
        }
        set (v) {
            super.hidesBottomBarWhenPushed = v
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        if navigationController == nil {
            return
        }
        if navigationController!.viewControllers.count < 3 {
            return
        }
        navigationItem.setRightBarButtonItems([homeItem()], animated: true)
    }
    
    /// build home item
    func homeItem() -> UIBarButtonItem {
        let home = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(gotoRootView))
        return home
    }
    
    func gotoRootView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.title = "..."
    }
    
    override func viewDidLayoutSubviews() {
        if let v = self.navigationController?.topViewController {
            print ("viewDidLayoutSubviews")
            print(v.description)
            print(v.topLayoutGuide)
        }
    }

    func showError(_ errorMsg: String) {
        lock.lock()
        defer { lock.unlock() }

        if error != nil {
            return
        }
        let message = UILabel.newAutoLayout()
        message.backgroundColor = .yellow
        message.text = errorMsg
        message.textAlignment = .center
        self.view.addSubview(message)

        error = Control(name: "error", view: message).layout {
            e in
            e.upper(withInset: 80).fillHolizon().height(40)
        }
        error?.configLayout()

        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(clearMessage), userInfo: nil, repeats: true)
    }

    func clearMessage() {
        lock.lock()
        defer { lock.unlock() }

        if (error != nil) {
            error?.view.removeFromSuperview()
            error = nil
        }
    }

    func autoCloseKeyboard(view: UIView) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tap(_:)))

        view.addGestureRecognizer(tapGesture)

    }

    func autoCloseKeyboard() {
        autoCloseKeyboard(view: self.view)
    }
    
    func tap(_ sender: UITapGestureRecognizer) {
        endEdit(self.view)
    }

    func endEdit(_ v: UIView) {
        if (v.isFirstResponder) {
            v.endEditing(true)
            return
        }

        for sv in v.subviews {
            endEdit(sv)
        }
    }

    func manageKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        notificationCenter.addObserver(self, selector: #selector(onKeyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func onKeyboardShow(_ notification: NSNotification) {


    }


    @objc
    func onKeyboardHide(_ notification: NSNotification) {
        //サブクラスで実装
    }

    // 同じ場所が存在しなければ、登録する。
    func checkAndRegist(_ pickedIsland: IslandPick) {

        let service = IslandService.instance
        service.fetchIslandInfo(pickedIsland.name!, callback: {
            islands in
            for island in islands {
                if self.isSameInfo(island, pickedIsland) {
                    // TODO int64 -> int
                    pickedIsland.id = Int(island.id)
                    return
                }
            }

            IslandService.instance.registerNewIsland(pickedIsland) {
                error in
                self.showError(error as! String)
            }

        }) {
            error in
            self.showError(error as! String)
        }

    }

    // change to uitily
    func isSameInfo(_ islandInfo: IslandInfo, _ pickedInfo: IslandPick) -> Bool {
        if (islandInfo.name != pickedInfo.name) {
            return false
        }

        let location = CLLocation(latitude: islandInfo.latitude, longitude: islandInfo.longitude)

        if let picklocation = pickedInfo.placeMark?.location {
            // 同じ名称で、距離が１００メートル以内であれば、同じ場所とみなす。
            print("location:", location)
            print("picklocation:", picklocation)
            let distance = location.distance(from: picklocation)
            print("distance:", distance)
            if (distance < 100) {
                return true
            }
        }

        return false
    }

    @discardableResult
    func seperator(section: Section, caption: String, _ distribution: LeftRight? = .atIntervals, color : UIColor? = MittyColor.black) -> Row {
        let row = Row().layout() {
            r in
            r.height(35).fillHolizon()
        }

        row.distribution = distribution!

        let c = MQForm.label(name: "caption", title: caption).layout {
            c in
            c.height(30).verticalCenter()
            c.label.textColor = color
            c.label.textAlignment = .center
            c.label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        row +++ c
        section <<< row

        return row
    }
    
    var lockForm = LockForm()
    
    func lockView () {
        ApplicationContext.startUp()
        if ApplicationContext.userSession.isLogedIn {
            return
        }
        
        self.view.addSubview(lockForm)
        lockForm.load()
        lockForm.configLayout()
        lockForm.unlockButton.bindEvent(.touchUpInside) {
            b in
            let vc = SigninViewController()
            self.present(vc, animated: true, completion: {})
        }
    }
}
