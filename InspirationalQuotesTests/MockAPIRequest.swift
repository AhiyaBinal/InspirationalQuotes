//
//  MockAPIRequest.swift
//  InspirationalQuotesTests
//
//  Created by Binal Manek on 2023-05-04.
//

import Foundation
import RxSwift
@testable import InspirationalQuotes

final class MockAPIRequest: APIRequestProtocol, Mockable {
    func getJSONData<T: Codable>(for type: T.Type) -> RxSwift.Observable<T> {
        return parseJSON(filename: "MockData", type: T.self)
    }
}
