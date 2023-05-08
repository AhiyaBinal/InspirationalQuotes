//
//  PageViewModelTests.swift
//  InspirationalQuotesTests
//
//  Created by Binal Manek on 2023-05-05.
//

import XCTest
import RxSwift
@testable import InspirationalQuotes

class PageViewModelTests: XCTestCase {
    var viewModel: PageViewModel!
    var disposeBag : DisposeBag!
    override func setUp() {
        super.setUp()
        viewModel = PageViewModel(apiDataRequest: MockAPIRequest())
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        disposeBag = nil
    }
    func testFetchJson() {
        viewModel.dataObject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { person in
                XCTAssertEqual(person.originator.name, "Emma Watson")
            })
            .disposed(by: disposeBag)
    }
}
