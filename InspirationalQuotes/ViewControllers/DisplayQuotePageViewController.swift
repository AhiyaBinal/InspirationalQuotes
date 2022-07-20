//
//  DisplayQuotePageViewController.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-21.
//

import UIKit
import Foundation
import SystemConfiguration

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
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isConnectedToNetwork() {
            self.loadJSON(index: currentIndex + 1)
            self.reloadDataSourceDelegate()
        }
        else {
            self.enrouteToSettingApp()
        }
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
                    self.enrouteToSettingApp()
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
                if self.isConnectedToNetwork() {
                    self.loadJSON(index: nextIndex)
                }else {
                    self.enrouteToSettingApp()
                }
            }
        }
    }
    func isConnectedToNetwork() -> Bool {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)

            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return false
            }

            var flags: SCNetworkReachabilityFlags = []
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                return false
            }
            if flags.isEmpty {
                return false
            }

            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)

            return (isReachable && !needsConnection)
        }
    func enrouteToSettingApp() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please Check Your Internet Connection.", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
