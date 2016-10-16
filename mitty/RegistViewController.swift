//
//  RegistViewController.swift
//  mitty
//
//  Created by tyori on 2016/10/16.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "初期登録"
        
        let goRigistBtn = UIButton()
        goRigistBtn.frame = CGRect(x: 259, y: 402, width: 83, height: 45)
        goRigistBtn.tintColor = UIColor.blue
        goRigistBtn.setTitle("登録へ", for: UIControlState.normal)
        goRigistBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
        goRigistBtn.addTarget(self, action: #selector(self.goRigistBtnDo), for: .touchUpInside)
        
        let goLoginBtn = UIButton()
        goLoginBtn.frame = CGRect(x: 62, y: 596, width: 278, height: 51)
        goLoginBtn.tintColor = UIColor.blue
        goLoginBtn.setTitle("既存IDで登録", for: UIControlState.normal)
        goLoginBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
        goLoginBtn.addTarget(self, action: #selector(self.goLoginBtnDo), for: .touchUpInside)
        
        self.view.addSubview(goRigistBtn)
        self.view.addSubview(goLoginBtn)
    }
    
    func goRigistBtnDo() {
        let nextViewController: MainTabBarController = MainTabBarController()
        present(nextViewController, animated:true, completion:nil)
    }
    func goLoginBtnDo() {
        let nextViewController: LoginViewController = LoginViewController()
        present(nextViewController, animated:true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
