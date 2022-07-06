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
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var constraintsLblQuotesTop: NSLayoutConstraint!
    var arrParsedJson: [String] = []
    var index = 0
    var strQuote: String = ""
    var strAuthor: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.reveal
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = 4
        lblQuote.layer.add(animation, forKey: nil)
        lblAuthor.layer.add(animation, forKey: nil)
        lblQuote.text = strQuote
        lblQuote.numberOfLines = 0
        lblQuote.sizeToFit()
        lblAuthor.text = strAuthor
        if strAuthor.isEmpty {
            lblQuote.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            lblQuote.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
}
