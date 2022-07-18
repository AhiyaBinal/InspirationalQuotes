//
//  DisplayQuotePageViewController.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-21.
//

import UIKit
struct StructMain: Decodable {
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
    var arrParsedDataList = [StructMain]()
    var arrHeader = [String: String]()
    var currentIndex : Int = 0
    var previousIndex : Int = 0
    var nextIndex: Int = 0
    var checkNextPageTransition = Bool()
    let dispatchGroup = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFirstData()
        self.displayViewController(indexItem: 0)
        setViewControllers([arrViewControllerList[0]], direction: .forward, animated: true)
        self.loadJSON(index: currentIndex + 1)
        self.reloadDataSourceDelegate()
    }
    func loadFirstData() {
        let dictOriginator = Structoriginator(id: 0, name: "", url: "")
        let dictFirstValue = StructMain(id: 1,language_code: "en",content: "Welcome to Inspirational Quotes", url: "",originator: dictOriginator,tags: [])
        arrParsedDataList.append(dictFirstValue)
    }
    // MARK: Parsing Methods.
    func loadJSON(index: Int) {
        let headers = self.loadHeaders()
        var request = URLRequest(url: NSURL(string: "https://quotes15.p.rapidapi.com/quotes/random/")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,response.statusCode == 200 {
                DispatchQueue.main.sync {
                    if let dList = try? JSONDecoder().decode(StructMain.self, from: data!) {
                        print("good Response \(index)")
                            let dValue = StructMain(id: dList.id,language_code: dList.language_code,content: dList.content, url: dList.url,originator: dList.originator,tags: dList.tags)
                            self.arrParsedDataList.append(dValue)
                        self.displayViewController(indexItem: index)
                } else {
                        print("Invalid Response")
                    }
                }
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                    let alert = UIAlertController(title: "Error", message: "An Error Occurred", preferredStyle: UIAlertController.Style.alert)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                           self.loadJSON(index: self.currentIndex + 1)
                       }))
                       alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                       self.present(alert, animated: true, completion: nil)
                }
           }.resume()
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
    func getInstance(index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objVC  = storyboard.instantiateViewController(withIdentifier: "DisplayQuoteDataViewController")
       // objVC.index(ofAccessibilityElement: index)
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
            obj.strQuote = strFirstValue.content
            //obj.strAuthor = "-\(strFirstValue.originator.name)"
            arrViewControllerList.append(obj)
    }
    // MARK: PageViewController Methods.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        checkNextPageTransition = false
    if currentIndex == 0 {
        return nil // To show there is no previous page
    } else {
        // Previous UIViewController instance
        previousIndex = currentIndex - 1
        currentIndex = previousIndex
        print("Before CurrentIndex \(currentIndex)")
        guard let obj: DisplayQuoteDataViewController = arrViewControllerList[previousIndex] as? DisplayQuoteDataViewController else {
            let obj: UIViewController = arrViewControllerList[previousIndex]
            return obj
        }
        let strQuote = arrParsedDataList[previousIndex]
        obj.strQuote = strQuote.content
        if !strQuote.originator.name.isEmpty {
            obj.strAuthor = "-\(strQuote.originator.name)"
        }
        return obj
    }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Next UIViewController instance
        checkNextPageTransition = true
        nextIndex = currentIndex + 1
        currentIndex = nextIndex
        print("After CurrentIndex \(currentIndex)")

        guard let obj: DisplayQuoteDataViewController = arrViewControllerList[nextIndex] as? DisplayQuoteDataViewController else {
            let obj: UIViewController = arrViewControllerList[nextIndex]
            return obj
        }
            let strQuote = arrParsedDataList[nextIndex]
            obj.strQuote = strQuote.content
        if !strQuote.originator.name.isEmpty {
            obj.strAuthor = "-\(strQuote.originator.name)"
        }
        return obj
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if checkNextPageTransition {
                self.loadJSON(index: nextIndex)
            }
        }
    }
}
