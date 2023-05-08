//
//  Mocakble.swift
//  InspirationalQuotesTests
//
//  Created by Binal Manek on 2023-05-04.
//

import Foundation
import RxSwift

protocol Mockable : AnyObject {
    var bundle: Bundle { get }
    func parseJSON<T: Decodable>(filename: String, type: T.Type) -> Observable<T>
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    func parseJSON<T: Decodable>(filename: String, type: T.Type) -> Observable<T> {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON file.")
        }

        return Observable.create { observer in
            do {
                let data = try Data(contentsOf: path)
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                observer.onNext(decodedObject)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
