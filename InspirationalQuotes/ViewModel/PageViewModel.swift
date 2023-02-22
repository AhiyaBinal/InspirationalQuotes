//
//  PageViewModel.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-09-04.
//

import Foundation
import UIKit
import SystemConfiguration
import RxSwift
import RxCocoa

class PageViewModel {

    lazy var dataObject: Observable<Data> = {
        return self.getJSONData()
    }()
    func loadFirstData() -> PageElements {
        let dictOriginator = PageModel(id: 0, name: "", url: "")
        let dictFirstValue = PageElements(id: 1,language_code: "en",content: "Welcome to Inspirational Quotes", url: "",originator: dictOriginator,tags: [])
        return dictFirstValue
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
    func getJSONData() -> Observable<Data> {
        let url = URL(string: "https://quotes15.p.rapidapi.com/quotes/random/")!
        let headers = self.loadHeaders()
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return URLSession.shared.rx.data(request: request)
    }

}
