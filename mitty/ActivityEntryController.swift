//
//  ActivityEntryController.swift
//  mitty
//
//  Created by gridscale on 2017/05/02.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class ActivityEntryViewController : UIViewController {
    var pageTitle = "活動作成"
    var form = MQForm.newAutoLayout()
    
    let activityTitle = MQForm.text(name: "title", placeHolder: "タイトルを入力してください")
    
    let memo = MQForm.textView(name: "memo")
    
    let doneButton = MQForm.button(name: "done", title: "Done")
    
    override func loadView() {
        
        // navigation bar の初期化をする
        
        // activityList を作成する
        
        // 線を引いて、対象年のフィルタボタンを設定する
        
        super.loadView()
        
        self.form.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(form)
        
        
        form +++ activityTitle.layout {
            t in
            t.upper(withInset: 10).leftMost(withInset: 10).rightMost(withInset: 10).height(50)
            
        }
        
        form +++ memo.layout { [weak self]
            m in
            m.putUnder(of: (self?.activityTitle)!, withOffset: 10)
                .leftMost(withInset: 10).rightMost(withInset: 10).height(80)
        }
        
        form +++ doneButton.layout { [ weak self] b in
            b.holizontalCenter().width(130).height(50).putUnder(of: (self?.memo)!, withOffset: 10)
        }
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
        
    }
    
    
    override func updateViewConstraints() {
        form.autoPin(toTopLayoutGuideOf: self, withInset:0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        form.configLayout()
        super.updateViewConstraints()
        
    }
    
    override func viewDidLoad() {
        
        self.navigationItem.title = pageTitle
        
        self.view.backgroundColor = UIColor.white
        
        doneButton.bindEvent(.touchUpInside) {
            [weak self] b in
            
            self?.registerActivity()
            
        }
        
        LoadingProxy.set(self)
    }
    
    func registerActivity() {
        
        let urlString = "http://dev.mitty.co/api/new/activity"
        
        let parameters: Parameters = [
            "title": activityTitle.textField.text!,
            "memo": memo.textView.text!,
            "mainEventId": "0"
        ]

        print(parameters)
        Alamofire.request(urlString, method: .post, parameters: parameters, headers: nil).validate(statusCode: 200..<300).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    DispatchQueue.main.async {
                        let activityId = json["activityId"].stringValue
                        
                        let activityInfo = ActivityInfo()
                        activityInfo.title = parameters["title"] as! String
                        activityInfo.memo = parameters["memo"] as? String
                        activityInfo.id = activityId
                        
                        let vc = ActivityPlanDetailsController(activityInfo)
                        vc.status = 1
                        self?.navigationController?.pushViewController(vc, animated: true)
       
                    }
                }
                
            case .failure(let error):
                print(response.debugDescription)
                print(response.data ?? "No Data")
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    
                } catch {
                    print("Serialize Error")
                }
                
                print(response.description)
                

                LoadingProxy.off()
                print(error)
                let count = self?.navigationController?.viewControllers.count
                let vc = self?.navigationController?.viewControllers[count!-2]
                self?.navigationController?.popToViewController(vc!, animated: true)
                
            }
        }
    }
}
