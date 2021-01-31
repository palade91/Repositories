//
//  NetworkManager.swift
//  Repositories
//
//  Created by Catalin Palade on 29/01/2021.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    let searchRepo   = "https://api.github.com/search/repositories"
    
    private let cache = NSCache<NSString, UIImage>()
    
    // Search Repo request
    func searchRepo(searchText: String, page: Int, completed: @escaping (Result<GitResponse, GRError>) -> Void) {
        
        let stringUrl = searchRepo + "?q=\(searchText)&per_page=20&page=\(page)"
        guard let url = URL(string: stringUrl) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(GitResponse.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    // download image from url string
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        guard  let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
