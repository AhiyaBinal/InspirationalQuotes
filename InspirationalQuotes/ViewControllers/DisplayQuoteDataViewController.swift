//
//  DisplayQuoteDataViewController.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-21.
//

import UIKit

class DisplayQuoteDataViewController: UIViewController {

    @IBOutlet weak var lblQuote: UILabel!
    var index = 0
    static func getInstance(index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objVC = storyboard.instantiateViewController(withIdentifier: "DisplayQuoteDataViewController")
        objVC.index(ofAccessibilityElement: index)
        return objVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
