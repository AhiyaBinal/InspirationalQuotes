//
//  InspirationalQuotesTests.swift
//  InspirationalQuotesTests
//
//  Created by Binal Manek on 2022-06-20.
//

import XCTest
@testable import InspirationalQuotes

class InspirationalQuotesTests: XCTestCase {

    var sut: DisplayQuotePageViewController!

    override func setUpWithError() throws {
        sut = DisplayQuotePageViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_viewDidLoad_setsInitialViewController() {
        // Given
        let expectedViewController = sut.arrViewControllerList[0]

        // When
        sut.viewDidLoad()

        // Then
        XCTAssertEqual(sut.viewControllers?.count, 1)
        XCTAssertEqual(sut.viewControllers?.first, expectedViewController)
    }

}
