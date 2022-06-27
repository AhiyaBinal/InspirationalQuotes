//
//  DisplayQuotePageViewController.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-21.
//

import UIKit
struct StrQuote: Decodable {
    let content: String
    let name: String
}

class DisplayQuotePageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var arrViewControllerList = [UIViewController]()
    var arrDataList = [StrQuote]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.getViewControllers()
        self.dataSource = self
        guard let obj: DisplayQuoteDataViewController = arrViewControllerList[0] as? DisplayQuoteDataViewController else {
            return
        }
            let strFirstValue = arrDataList[0]
            obj.strValue = strFirstValue.content
            setViewControllers([arrViewControllerList[0]], direction: .forward, animated: true)
    }
    func getViewControllers() {
        for (item , data) in arrDataList.enumerated() {
            arrViewControllerList.append(self.getInstance(index: item))
            print(data)
        }
    }
    func getInstance(index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objVC  = storyboard.instantiateViewController(withIdentifier: "DisplayQuoteDataViewController")
        objVC.index(ofAccessibilityElement: index)
        return objVC
    }
    func getData() {
        if let localData = CommonFunctions.objCommonFunction.readLocalFile(forName: "data") {
            do {
                arrDataList = try JSONDecoder().decode([StrQuote].self, from: localData)
            } catch {
                print(error)
            }
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let indexItem = arrViewControllerList.firstIndex(of: viewController)!
    if indexItem == 0 {
        return nil // To show there is no previous page
    } else {
        // Previous UIViewController instance
        guard let obj: DisplayQuoteDataViewController = arrViewControllerList[indexItem - 1] as? DisplayQuoteDataViewController else {
            let obj: UIViewController = arrViewControllerList[indexItem - 1]
            return obj
        }
        let strQuote = arrDataList[indexItem - 1]
        obj.strValue = strQuote.content
        return obj
    }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let indexItem = arrViewControllerList.firstIndex(of: viewController)!
    if indexItem == arrViewControllerList.count - 1 {
        return nil // To show there is no next page
    } else {
        // Next UIViewController instance
        guard let obj: DisplayQuoteDataViewController = arrViewControllerList[indexItem + 1] as? DisplayQuoteDataViewController else {
            let obj: UIViewController = arrViewControllerList[indexItem + 1]
            return obj
        }
        let strQuote = arrDataList[indexItem + 1]
        obj.strValue = strQuote.content
        print(indexItem)
        print(strQuote.name)
        return obj
    }
    }
}
