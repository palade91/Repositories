//
//  Owner.swift
//  Repositories
//
//  Created by Catalin Palade on 29/01/2021.
//

import UIKit

struct Owner: Codable, Hashable {
    
    static func == (lhs: Owner, rhs: Owner) -> Bool {
        lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id         = "id"
        case name       = "login"
        case avatarURL  = "avatar_url"
    }
    
    let id: Int
    let name: String
    let avatarURL: String?
}
