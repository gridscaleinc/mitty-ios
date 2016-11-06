//
//  GuideViewController.swift
//  mitty
//
//  Created by tyori on 2016/11/03.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

@objc (GuideViewController)
class GuideViewController: UIViewController {
    
    var guideView = UIView.newAutoLayout()
    var scrollView: UIScrollView!
    
    var pageContol = UIPageControl.init()
    let numOfPages = 3
    
    //開始ボータン
    var startButton : UIButton = UIButton.init()
    
    // Autolayout済みフラグ
    var didSetupConstraints = false
    
    override func loadView() {
        super.loadView()
       
    
    }
    //Viewの表示処理
    override func viewDidLoad() {
        super.viewDidLoad()
        pageContol.numberOfPages = numOfPages
        let frame = self.view.bounds
        guideView.frame = CGRect(x: 0, y: 600, width: frame.size.width, height: 80)
        guideView.backgroundColor = .red
        guideView.isUserInteractionEnabled = true
        startButton.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 80)
        startButton.backgroundColor = UIColor.clear
        startButton.setTitle("START", for: UIControlState.normal)
        startButton.isUserInteractionEnabled = true
        startButton.addTarget(self, action: #selector(GuideViewController.start), for: .touchUpInside)
        guideView.addSubview(startButton)

        scrollView = UIScrollView(frame: frame)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.contentOffset = CGPoint.zero
        //将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scrollView.contentSize = CGSize(width: frame.size.width * CGFloat(numOfPages), height: frame.size.height)
        for index  in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "Guide\(index + 1)"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, width: frame.size.width, height: frame.size.height)
            if index == numOfPages - 1 {
                imageView.isUserInteractionEnabled = true
                imageView.addSubview(guideView)
            }
            scrollView.addSubview(imageView)
        }
       
        self.view.insertSubview(scrollView, at: 0)
        
        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        //self.view.setNeedsUpdateConstraints()

    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            
            //guideView.autoPinEdgesToSuperviewEdges(with: self.view.widthAnchor)
            //guideView.autoMatch(.width, to: .width, of: self.view)
            startButton.autoPinEdge(.bottom, to: .bottom, of: guideView)
            startButton.autoPinEdge(.left, to: .right, of: guideView, withOffset: 10)
            startButton.autoSetDimension(.width, toSize:50)
            startButton.autoSetDimension(.height, toSize:50)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    //メモリ障害警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func start() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mainTabBarController.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        self.present(appDelegate.mainTabBarController, animated: true, completion: nil)
    }

}

// MARK: - UIScrollViewDelegate
extension GuideViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        pageContol.currentPage = Int(offset.x / self.view.bounds.width)
        
        // 因为currentPage是从0开始，所以numOfPages减1
        if pageContol.currentPage == numOfPages - 1{
            UIView.animate(withDuration: 0.5, animations: {
                self.guideView.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.guideView.alpha = 0.0
            })
        }
    }
}
