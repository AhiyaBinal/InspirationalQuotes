//
//  CommonFunctions.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-22.
//

import UIKit

class CommonFunctions: NSObject {
    static let objCommonFunction = CommonFunctions()
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)}
        return nil
    }
}
