//
//  GitResponse.swift
//  Repositories
//
//  Created by Catalin Palade on 29/01/2021.
//

import UIKit

struct GitResponse: Codable {
    
    enum CodingKeys: String, CodingKey {
        case incompleteResults  = "incomplete_results"
        case items              = "items"
        case totalCount         = "total_count"
    }
    
    let items: [Item]?
    let totalCount: Int?
    let incompleteResults: Bool?
}
