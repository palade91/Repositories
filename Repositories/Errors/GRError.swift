//
//  GRError.swift
//  Repositories
//
//  Created by Catalin Palade on 29/01/2021.
//

import Foundation

enum GRError: String, Error {
    case invalidURL         = "Invalid URL"
    case invalidResponse    = "Invalid response"
    case invalidData        = "Invalid data"
    case unableToComplete   = "Unable to complete"
}
