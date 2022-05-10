//
//  Model.swift
//  GetPostApp
//
//  Created by Pavel Avlasov on 06.05.2022.
//

import Foundation

struct GetModel: Codable {
    let page, pageSize, totalPages, totalElements: Int
    let content: [Content]
}

struct Content: Codable {
    let id: Int
    let name: String
    let image: URL?
}
