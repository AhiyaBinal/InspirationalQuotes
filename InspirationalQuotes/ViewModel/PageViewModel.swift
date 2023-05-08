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

    var apiDataRequest: APIRequestProtocol!
    init(apiDataRequest: APIRequestProtocol) {
        self.apiDataRequest = apiDataRequest
    }

    lazy var dataObject: Observable<PageElements> = {
        return self.apiDataRequest.getJSONData(for: PageElements.self)
    }()
    func loadFirstData() -> PageElements {
        let dictOriginator = PageModel(id: 0, master_id: 0, name: "", language_code: "", description: "", url: "")
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
}
