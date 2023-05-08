//
//  DisplayQuotePageViewController.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-21.
//

import UIKit
import Foundation
import SystemConfiguration
import RxSwift

class DisplayQuotePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var arrViewControllerList = [UIViewController]()
    var arrParsedDataList = [PageElements]()
    var arrHeader = [String: String]()
    var currentIndex : Int = 0
    var previousIndex : Int = 0
    var nextIndex: Int = 0
    var checkNextPageTransition = Bool()
    let dispatchGroup = DispatchGroup()
    let objPageViewModel = PageViewModel(apiDataRequest: APIDataRequest())
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        arrParsedDataList.append(objPageViewModel.loadFirstData())
        arrViewControllerList.append(self.displayViewController(indexItem: 0, arrItem: arrParsedDataList))
        setViewControllers([arrViewControllerList[0]], direction: .forward, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if objPageViewModel.isConnectedToNetwork() {
            objPageViewModel.dataObject
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { person in
                    self.arrParsedDataList.append(person)
                    self.arrViewControllerList.append(self.displayViewController(indexItem: self.currentIndex + 1, arrItem: self.arrParsedDataList))
                    self.reloadDataSourceDelegate()
                }).disposed(by: disposeBag)
        } else {
            self.enrouteToSettingApp()
        }
    }
    func displayViewController(indexItem: Int, arrItem: [PageElements]) -> DisplayQuoteDataViewController {
        guard let obj: DisplayQuoteDataViewController = self.getInstance(index: indexItem) as? DisplayQuoteDataViewController else { return DisplayQuoteDataViewController() }
        let strFirstValue = arrItem[indexItem]
        obj.strQuote = strFirstValue.content
        return obj
    }
    func getInstance(index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objVC  = storyboard.instantiateViewController(withIdentifier: "DisplayQuoteDataViewController")
        return objVC
    }
    func reloadDataSourceDelegate() {
        self.dataSource = self
        self.delegate = self
    }
    // MARK: - PageViewController Methods.
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
                if objPageViewModel.isConnectedToNetwork() {
                    objPageViewModel.dataObject
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { person in
                            self.arrParsedDataList.append(person)
                            self.arrViewControllerList.append(self.displayViewController(indexItem: self.nextIndex, arrItem: self.arrParsedDataList))
                        }).disposed(by: disposeBag)
                } else {
                    nextIndex = currentIndex - 1
                    currentIndex = nextIndex
                    self.enrouteToSettingApp()
                }
            }
        }
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
