//
//  DisplayQuoteDataViewController.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-21.
//

import UIKit

class DisplayQuoteDataViewController: UIViewController {
    @IBOutlet var viewDisplay: UIView!
    @IBOutlet weak var lblQuote: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewShare: UIView!
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
            btnShare.isHidden = true
            lblQuote.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            lblQuote.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    @IBAction func btnSharePressed(_ sender: UIButton) {
        let imgToShare :UIImage = self.createImageFromQuote()!
                let objectsToShare: [Any] = [imgToShare]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = sender
                activityVC.popoverPresentationController?.sourceRect = sender.frame
                present(activityVC, animated: true, completion: nil)
          //  }
    }
    func createImageFromQuote() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(viewShare.frame.size, true, 0)
        _ = viewShare.drawHierarchy(in: viewShare.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
