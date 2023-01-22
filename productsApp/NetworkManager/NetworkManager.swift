//
//  NetworkManager.swift
//  productsApp
//
//  Created by ibaikaa on 22/1/23.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    func fetchData(completion: @escaping (Result<Products, Error>) -> Void) {
        let urlPath: String = "https://dummyjson.com/products"
        guard let url = URL(string: urlPath) else { print("URL Error in Network Manager"); return }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else { print("Data is nil!"); return }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Success. Status code: \(httpResponse.statusCode)")
                } else {
                    print("Got an unexpected status code in response: \(httpResponse.statusCode)")
                }
            }
            
            guard error == nil else { print("Some error occured! \(error!.localizedDescription)"); return }
            
            do {
                let products = try JSONDecoder().decode(Products.self, from: data)
                completion(.success(products))
            } catch {
                print("Error occured while trying to get data from JSON. \n \(error.localizedDescription)")
                completion(.failure(error))
            }
            
        }
        
        task.resume()
        
    }
}
