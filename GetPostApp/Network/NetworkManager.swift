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
        
        guard let url = URL(string: stringUrl) else { return }
        
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
    
    static public func uploadInfo(with id: Int?, image: UIImage?, completion: @escaping (Result<HTTPURLResponse?, Error>) -> Void) {
        
        let name = "AvlAs"
        let fileName = "Image.jpeg"
        let url = URL(string: postUrl)
        
        guard let url = url, let image = image else { return }
        
        let nameField = "name"
        let nameValue = name
        
        let idField = "typeId"
        guard let idValue = id else { return }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(nameField)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(nameValue)".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append((image.jpegData(compressionQuality: 1))!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(idField)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(idValue)".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: request, from: data) { responseData, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            else if responseData != nil {
                let httpResponse = response as? HTTPURLResponse
                completion(.success(httpResponse))
            }
        }.resume()
    }
}
