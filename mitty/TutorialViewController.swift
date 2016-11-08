//
//  SimplePageView.swift
//  mitty
//
//  Created by gridscale on 2016/11/08.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit

class TutorialViewController : UIViewController, UIPageViewControllerDataSource {
    
    let colors = [UIColor.red, UIColor.yellow, UIColor.blue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        pageViewController.dataSource = self
        
        let startingViewController = viewControllerAtIndex(index: 0)!
        let viewControllers = [startingViewController]
        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        pageViewController.view.frame = self.view.frame
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view!)
        pageViewController.didMove(toParentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewControllerAtIndex(index: Int) -> PageViewController? {
        if index >= colors.count {
            return nil
        }
        
        let hogeViewController = PageViewController()
        hogeViewController.pageIndex = index
        
        print(index)
        return hogeViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageViewController).pageIndex
        
        if index == 0 {
            print("before nil:: \(index)")
            return nil
        }
        
        index -= 1
        
        print("before's return \(index)")
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageViewController).pageIndex
        
        index += 1
        
        if index == self.colors.count {
            print("after nil")
            return nil
        }
        print("after's return  \(index)")
        return viewControllerAtIndex(index: index)
    }
}
