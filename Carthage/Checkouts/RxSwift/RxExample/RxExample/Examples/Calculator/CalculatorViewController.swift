//
//  CalculatorViewController.swift
//  RxExample
//
//  Created by Carlos García on 4/8/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CalculatorViewController: ViewController {

    @IBOutlet private weak var lastSignLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!

    @IBOutlet private weak var allClearButton: UIButton!
    @IBOutlet private weak var changeSignButton: UIButton!
    @IBOutlet private weak var percentButton: UIButton!

    @IBOutlet private weak var divideButton: UIButton!
    @IBOutlet private weak var multiplyButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var equalButton: UIButton!

    @IBOutlet private weak var dotButton: UIButton!

    @IBOutlet private weak var zeroButton: UIButton!
    @IBOutlet private weak var oneButton: UIButton!
    @IBOutlet private weak var twoButton: UIButton!
    @IBOutlet private weak var threeButton: UIButton!
    @IBOutlet private weak var fourButton: UIButton!
    @IBOutlet private weak var fiveButton: UIButton!
    @IBOutlet private weak var sixButton: UIButton!
    @IBOutlet private weak var sevenButton: UIButton!
    @IBOutlet private weak var eightButton: UIButton!
    @IBOutlet private weak var nineButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        typealias FeedbackLoop = (ObservableSchedulerContext<CalculatorState>) -> Observable<CalculatorCommand>

        let uiFeedback: FeedbackLoop = bind(self) { this, state in
            let subscriptions = [
                state.map { $0.screen }.bind(to: this.resultLabel.rx.text),
                state.map { $0.sign }.bind(to: this.lastSignLabel.rx.text)
            ]

            let events: [Observable<CalculatorCommand>] = [
                this.allClearButton.rx.tap.map { _ in .clear },

                this.changeSignButton.rx.tap.map { _ in .changeSign },
                this.percentButton.rx.tap.map { _ in .percent },

                this.divideButton.rx.tap.map { _ in .operation(.division) },
                this.multiplyButton.rx.tap.map { _ in .operation(.multiplication) },
                this.minusButton.rx.tap.map { _ in .operation(.subtraction) },
                this.plusButton.rx.tap.map { _ in .operation(.addition) },

                this.equalButton.rx.tap.map { _ in .equal },

                this.dotButton.rx.tap.map { _ in  .addDot },

                this.zeroButton.rx.tap.map { _ in .addNumber("0") },
                this.oneButton.rx.tap.map { _ in .addNumber("1") },
                this.twoButton.rx.tap.map { _ in .addNumber("2") },
                this.threeButton.rx.tap.map { _ in .addNumber("3") },
                this.fourButton.rx.tap.map { _ in .addNumber("4") },
                this.fiveButton.rx.tap.map { _ in .addNumber("5") },
                this.sixButton.rx.tap.map { _ in .addNumber("6") },
                this.sevenButton.rx.tap.map { _ in .addNumber("7") },
                this.eightButton.rx.tap.map { _ in .addNumber("8") },
                this.nineButton.rx.tap.map { _ in .addNumber("9") }
            ]

            return Bindings(subscriptions: subscriptions, events: events)
        }

        Observable.system(
            initialState: CalculatorState.initial,
            reduce: CalculatorState.reduce,
            scheduler: MainScheduler.instance,
            scheduledFeedback: uiFeedback
        )
        .subscribe()
        .disposed(by: disposeBag)
    }

    func formatResult(_ result: String) -> String {
        if result.hasSuffix(".0") {
            return String(result[result.startIndex ..< result.index(result.endIndex, offsetBy: -2)])
        } else {
            return result
        }
    }
}
