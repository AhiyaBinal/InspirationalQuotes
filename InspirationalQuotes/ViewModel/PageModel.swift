//
//  PageModel.swift
//  InspirationalQuotes
//
//  Created by Binal Manek on 2023-02-21.
//

import Foundation

struct PageModel: Codable {
    let id: Int
    let master_id: Int
    let name: String
    let language_code: String
    let description: String
    let url: String
}
struct PageElements: Codable {
    let id: Int
    let language_code: String
    let content: String
    let url: String
    let originator: PageModel
    let tags:[String]
}
