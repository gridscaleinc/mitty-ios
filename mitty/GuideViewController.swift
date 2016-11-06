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
         let frame = self.view.bounds
        guideView.frame = CGRect(x: 0, y: 600, width: 375,height: 80)
        guideView.backgroundColor = .red
        startButton.frame = CGRect(x: 0, y: 0, width:100, height: 20)
        //startButton.backgroundColor = UIColor.white
        startButton.setTitle("START", for: UIControlState.normal)

        scrollView = UIScrollView(frame: frame)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        //将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scrollView.contentSize = CGSize(width: frame.size.width * CGFloat(numOfPages), height: frame.size.height)
        for index  in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "Guide\(index + 1)"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, width: frame.size.width, height: frame.size.height)
            scrollView.addSubview(imageView)
        }
       
        self.view.insertSubview(scrollView, at: 0)
        
        scrollView.addSubview(guideView)
        guideView.addSubview(startButton)

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

}

// MARK: - UIScrollViewDelegate
extension GuideViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        pageContol.currentPage = Int(offset.x / self.view.bounds.width)
        
        // 因为currentPage是从0开始，所以numOfPages减1
        if pageContol.currentPage == numOfPages - 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.startButton.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.startButton.alpha = 0.0
            })
        }
    }
}
