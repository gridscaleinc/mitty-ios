//
//  LoginViewController.swift
//  mitty
//
//  Created by tyori on 2016/10/16.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let goBackBtn = UIButton()
        goBackBtn.frame = CGRect(x: 298, y: 42, width: 46, height: 30)
        goBackBtn.tintColor = UIColor.blue
        goBackBtn.setTitle("Back", for: UIControlState.normal)
        goBackBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
        goBackBtn.addTarget(self, action: #selector(self.goBackBtnDo), for: .touchUpInside)
        
        let goRigistBtn = UIButton()
        goRigistBtn.frame = CGRect(x: 47, y: 472, width: 27, height: 461)
        goRigistBtn.tintColor = UIColor.blue
        goRigistBtn.setTitle("登録", for: UIControlState.normal)
        goRigistBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
        goRigistBtn.addTarget(self, action: #selector(self.goRigistBtnDo), for: .touchUpInside)

        self.view.addSubview(goBackBtn)
        self.view.addSubview(goRigistBtn)
    }
    func goBackBtnDo() {
        let nextViewController: RegistViewController = RegistViewController()
        present(nextViewController, animated:true, completion:nil)
    }
    func goRigistBtnDo() {
        let nextViewController: MainTabBarController = MainTabBarController()
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
