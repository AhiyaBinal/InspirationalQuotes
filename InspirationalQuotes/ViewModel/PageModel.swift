//
//  PageModel.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2023-02-21.
//

import Foundation

struct PageModel: Decodable {
    let id: Int
    let name: String
    let url: String
}
struct PageElements: Decodable {
    let id: Int
    let language_code: String
    let content: String
    let url: String
    let originator: PageModel
    let tags:[String]
}
