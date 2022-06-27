//
//  DisplayQuoteDataViewController.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-21.
//

import UIKit
struct StrQuote1: Decodable {
    let content: String
    let name: String
}
class DisplayQuoteDataViewController: UIViewController {
    @IBOutlet var viewDisplay: UIView!
    @IBOutlet weak var lblQuote: UILabel!
    var arrParsedJson: [String] = []
    var index = 0
    var strValue: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblQuote.text = strValue
        // Do any additional setup after loading the view.
//        curl --request GET \
//            --url https://quotes15.p.rapidapi.com/quotes/random/ \
//            --header 'X-RapidAPI-Host: quotes15.p.rapidapi.com' \
//            --header 'X-RapidAPI-Key: aedfa8ecf5mshc5d574796af4a20p1d4569jsn0badb1845350'
    }
}
