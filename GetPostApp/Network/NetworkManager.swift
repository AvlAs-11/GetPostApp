//
//  NetworkManager.swift
//  GetPostApp
//
//  Created by Pavel Avlasov on 06.05.2022.
//

import Foundation
import UIKit

final class NetworkManager {
    
    static let getUrl = "https://junior.balinasoft.com/api/v2/photo/type?page="
    static let postUrl = "https://junior.balinasoft.com/api/v2/photo"
    
    static public func getInfo(with page: Int, completion: @escaping (Result<[Content], Error>) -> Void) {
        
        let pageToString = String(page)
        
        let stringUrl = getUrl + pageToString
        
        guard let url = URL(string: stringUrl) else { return
            
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(GetModel.self, from: data)
                    completion(.success(result.content))
                    if MainViewController.totalPages == nil
                    {
                        MainViewController.totalPages = result.totalPages
                    }
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
