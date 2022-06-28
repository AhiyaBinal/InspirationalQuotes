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
class DisplayQuotePageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var arrViewControllerList = [UIViewController]()
    var arrDataList = [StrQuote]()
    var arrHeader = [String: String]()
    //var dictDataList = StrcutParsedData()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.getViewControllers()
        self.loadJSON()
        self.dataSource = self
        guard let obj: DisplayQuoteDataViewController = arrViewControllerList[0] as? DisplayQuoteDataViewController else {
            return
        }
            let strFirstValue = arrDataList[0]
            obj.strValue = strFirstValue.content
            setViewControllers([arrViewControllerList[0]], direction: .forward, animated: true)
    }
    func loadJSON() {
        let headers = self.loadHeaders()
        var request = URLRequest(url: NSURL(string: "https://quotes15.p.rapidapi.com/quotes/random/")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                    if let books = try? JSONDecoder().decode(StrcutParsedData.self, from: data) {
                        print("Now Check this\(books)")
                       // dictDataList = books
                    } else {
                        print("Invalid Response")
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
       // print(indexItem)
       // print(strQuote.name)
        return obj
    }
    }
}
