//
//  CommonFunctions.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2022-06-22.
//

import UIKit
class CommonFunctions: NSObject {
    static let objCommonFunction = CommonFunctions()
    func loadJSON(fromURLString objUrlString: String, completion: @escaping(Result<Data,Error>) -> Void) {
            if let objURL = URL(string: objUrlString) {
                let objUrlSession = URLSession(configuration: .default).dataTask(with: objURL){ (data, response, error) in
                    if let error = error {
                        completion(.failure(error))
                    }
                    if let data = data {
                        completion(.success(data))
                    }
                }
                objUrlSession.resume()
            }
    }
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
