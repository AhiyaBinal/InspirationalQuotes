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
    var indexOfTotalPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        indexOfTotalPage = DisplayQuoteDataViewController.getData()
        self.getData()
        for (item , data) in arrDataList.enumerated() {
//            print(item)
            arrViewControllerList.append(self.getInstance(index: item))
        }
        /*
        if let localData = CommonFunctions.objCommonFunction.readLocalFile(forName: "data"){
            do {
                if let arrJsonData: [StrQuote] = try? JSONDecoder().decode([StrQuote].self, from: localData){
                    for (objIdex, objValue) in arrJsonData.enumerated() {
                        arrViewControllerList.append(DisplayQuoteDataViewController.getInstance(index: objIdex, strQuote: objValue.content, strAuthor: objValue.name))
                    }
                }
            }
        }*/
        self.dataSource = self
        setViewControllers([arrViewControllerList[0]], direction: .forward, animated: true)
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
            }catch {
                print(error)
            }
        }
    }
      func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
          let indexItem = pageViewController.viewControllers!.first!.view.tag
        if indexItem == 0 {
         return nil // To show there is no previous page
        } else {
          // Previous UIViewController instance
            let indexItem = pageViewController.viewControllers!.first!.view.tag
            guard let obj: DisplayQuoteDataViewController = arrViewControllerList[indexItem - 1] as? DisplayQuoteDataViewController else{
                let obj: UIViewController = arrViewControllerList[indexItem - 1]
                return obj
            }
            let strQuote = arrDataList[indexItem - 1]
            obj.strValue = strQuote.name
//
          return obj
        }
      }

      func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
          let indexItem = pageViewController.viewControllers!.first!.view.tag
          print(indexItem)
        if indexItem == arrViewControllerList.count - 1 {
          return nil // To show there is no next page
        } else {
          // Next UIViewController instance
            guard let obj: DisplayQuoteDataViewController = arrViewControllerList[indexItem + 1] as? DisplayQuoteDataViewController else {
                let obj: UIViewController = arrViewControllerList[indexItem + 1]
                return obj
            }
            let strQuote = arrDataList[indexItem + 1]
            obj.strValue = strQuote.name
            print(indexItem)
            print(strQuote.name)
          return obj
        }
      }
}
