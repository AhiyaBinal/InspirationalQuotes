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
    static func getInstance(index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objVC  = storyboard.instantiateViewController(withIdentifier: "DisplayQuoteDataViewController")
        objVC.index(ofAccessibilityElement: index)
        return objVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblQuote.text = strValue
        // Do any additional setup after loading the view.
    }
    static func getData() -> Int {
        if let localData = CommonFunctions.objCommonFunction.readLocalFile(forName: "data") {
            do {
                if let arrJsonData: [StrQuote1] = try? JSONDecoder().decode([StrQuote1].self, from: localData) {
                    return arrJsonData.count
                }
            }
        }
        return 0
    }
}
