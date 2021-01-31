//
//  Item.swift
//  Repositories
//
//  Created by Catalin Palade on 29/01/2021.
//

import UIKit

struct Item: Codable, Hashable {
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id && lhs.uuid == rhs.uuid
    }
    
    enum CodingKeys: String, CodingKey {
        case id                 = "id"
        case name               = "name"
        case fullName           = "full_name"
        case itemDescription    = "description"
        
        case owner              = "owner"
        
        case updatedAt          = "updated_at"
        case createdAt          = "created_at"
        
        case openIssues         = "open_issues"
        case forks              = "forks"
        case watchers           = "watchers"
    }
    
    let uuid = UUID()
    
    let id: Int
    let name: String
    let fullName: String
    let itemDescription: String
    
    let owner: Owner?
    
    let createdAt: String
    let updatedAt: String
    
    let forks: Int
    let openIssues: Int
    let watchers: Int
}
