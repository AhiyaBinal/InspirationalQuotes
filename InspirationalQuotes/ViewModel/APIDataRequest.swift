//
//  APIRequest.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2023-05-04.
//

import Foundation
import RxSwift

protocol APIRequestProtocol {
    func getJSONData<T: Codable>(for type: T.Type) -> Observable<T>
}
class APIDataRequest: APIRequestProtocol {
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
    func getJSONData<T: Codable>(for type: T.Type) -> Observable<T> {
        let url = URL(string: "https://quotes15.p.rapidapi.com/quotes/random/")!
        let headers = self.loadHeaders()
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return URLSession.shared.rx.data(request: request)
            .map { data in
                try JSONDecoder().decode(T.self, from: data)
            }
    }
}
