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
struct StrcutParsedData: Decodable {
    let id: Int
    let language_code: String
    let content: String
    let url: String
    let originator: Structoriginator
    let tags:[String]
}
struct Structoriginator:Decodable {
    let id: Int
    let name: String
    let url: String
}
class DisplayQuotePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var arrViewControllerList = [UIViewController]()
    var arrParsedDataList = [StrcutParsedData]()
    var arrDataList = [StrQuote]()
    var arrHeader = [String: String]()
    var currentIndex : Int = 0
    var previousIndex : Int = 0
    var nextIndex: Int = 0
    var checkNextPageTransition = Bool()
    let dispatchGroup = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchGroup.enter()
        self.loadJSON(index: currentIndex,completion: {
            self.dispatchGroup.leave()
            self.dispatchGroup.enter()
            self.loadJSON(index: self.nextIndex + 1, completion: {
                self.dispatchGroup.leave()
            })
        })
        self.reloadDataSourceDelegate()

    }
    func loadJSON(index: Int,completion: @escaping () -> Void) {
        let headers = self.loadHeaders()
        var request = URLRequest(url: NSURL(string: "https://quotes15.p.rapidapi.com/quotes/random/")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    if let dictDataList = try? JSONDecoder().decode(StrcutParsedData.self, from: data) {
                        print("data got")
                            let dictValue = StrcutParsedData(id: dictDataList.id,language_code: dictDataList.language_code,content: dictDataList.content, url: dictDataList.url,originator: dictDataList.originator,tags: dictDataList.tags)
                            self.arrParsedDataList.append(dictValue)
                            self.displayViewController(indexItem: index)
                        completion()
                } else {
                        print("Invalid Response")
                    }
                }
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                }
           }.resume()
        print("Check...")
    }
    func loadHeaders() -> [String : String] {
        var arrHeaderList = [String: String]()
        if let infoPlistPath = Bundle.main.url(forResource: "URLHeader", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: String]? {
                    arrHeaderList = dict!
                }
            } catch {
                arrHeaderList = ["X-RapidAPI-Host": "quotes15.p.rapidapi.com",
                                 "X-RapidAPI-Key": "aedfa8ecf5mshc5d574796af4a20p1d4569jsn0badb1845350"]
            }
        }
        return arrHeaderList
    }
    /*
    func getViewControllers(indexItem : Int) {
            arrViewControllerList.append(self.getInstance(index: indexItem))
   }*/
    func getInstance(index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objVC  = storyboard.instantiateViewController(withIdentifier: "DisplayQuoteDataViewController")
        objVC.index(ofAccessibilityElement: index)
        return objVC
    }
    func reloadDataSourceDelegate() {
        self.dataSource = self
        self.delegate = self
    }
    func displayViewController(indexItem: Int) {
        guard let obj: DisplayQuoteDataViewController = self.getInstance(index: indexItem) as? DisplayQuoteDataViewController else {
            return
        }
            let strFirstValue = arrParsedDataList[indexItem]
            obj.strValue = strFirstValue.content
            arrViewControllerList.append(obj)
        if indexItem == 0 {
            setViewControllers([arrViewControllerList[indexItem]], direction: .forward, animated: true)
          //  self.loadJSON(index: nextIndex + 1)
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        checkNextPageTransition = false
    if currentIndex == 0 {
        return nil // To show there is no previous page
    } else {
        // Previous UIViewController instance
        previousIndex = currentIndex - 1
        currentIndex = previousIndex
        guard let obj: DisplayQuoteDataViewController = arrViewControllerList[previousIndex] as? DisplayQuoteDataViewController else {
            let obj: UIViewController = arrViewControllerList[previousIndex]
            return obj
        }
        let strQuote = arrParsedDataList[previousIndex]
        obj.strValue = strQuote.content
        return obj
    }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Next UIViewController instance
        checkNextPageTransition = true
        nextIndex = currentIndex + 1
        currentIndex = nextIndex
        guard let obj: DisplayQuoteDataViewController = arrViewControllerList[nextIndex] as? DisplayQuoteDataViewController else {
            let obj: UIViewController = arrViewControllerList[nextIndex]
            return obj
        }
            let strQuote = arrParsedDataList[nextIndex]
            obj.strValue = strQuote.content
        return obj
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if completed {
            if checkNextPageTransition {
                dispatchGroup.enter()
                self.loadJSON(index: nextIndex,completion: {
                    self.dispatchGroup.leave()
                })
            }
        }
    }
}
