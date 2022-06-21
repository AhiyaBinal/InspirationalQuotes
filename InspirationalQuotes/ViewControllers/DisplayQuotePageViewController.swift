//
//  DisplayQuotePageViewController.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-21.
//

import UIKit

class DisplayQuotePageViewController: UIPageViewController,UIPageViewControllerDataSource {
    var arrViewControllerList = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        arrViewControllerList = [
            DisplayQuoteDataViewController.getInstance(index: 0),
            DisplayQuoteDataViewController.getInstance(index: 1),
            DisplayQuoteDataViewController.getInstance(index: 2),
            DisplayQuoteDataViewController.getInstance(index: 3)
        ]
        self.dataSource = self
        setViewControllers([arrViewControllerList[0]], direction: .forward, animated: true)
    }
      func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
          let indexOfCurrentPageViewController = arrViewControllerList.firstIndex(of: viewController)!
        if indexOfCurrentPageViewController == 0 {
         return nil // To show there is no previous page
        } else {
          // Previous UIViewController instance
          return arrViewControllerList[indexOfCurrentPageViewController - 1]
        }
      }

      func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let indexOfCurrentPageViewController = arrViewControllerList.firstIndex(of: viewController)!
        if indexOfCurrentPageViewController == arrViewControllerList.count - 1 {
          return nil // To show there is no next page
        } else {
          // Next UIViewController instance
          return arrViewControllerList[indexOfCurrentPageViewController + 1]
        }
      }
}
