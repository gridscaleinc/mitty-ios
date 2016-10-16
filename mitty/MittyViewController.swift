//
//  ViewController.swift
//  mitty
//
//  Created by tyori on 2016/10/15.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import UIKit

class MittyViewController: UIViewController, UITableViewDelegate {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let goStartBtn = UIButton()
        goStartBtn.frame = CGRect(x: 85, y: 480, width: 200, height: 75)
        goStartBtn.tintColor = UIColor.blue
        goStartBtn.setTitle("Go start Mitty!", for: UIControlState.normal)
        goStartBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
        goStartBtn.addTarget(self, action: #selector(self.goStartBtnDo), for: .touchUpInside)
        
        self.view.addSubview(goStartBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goStartBtnDo() {
        let nextViewController: RegistViewController = RegistViewController()
        present(nextViewController, animated:true, completion:nil)
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
