//
//  Model&API.swift
//  AISI
//
//  Created by Mario Ban on 12.04.2024..
//

import SwiftUI

public struct Product: Codable, Identifiable, Hashable {
    public var id: String?
    var name: String
    var quantity: Int
    var price: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case quantity
        case price
    }
    
    public init(id: String? = nil, name: String, quantity: Int, price: Double) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.price = price
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}


class APIManager {
    static let shared = APIManager()
    private let baseURL = "http://localhost:3000/api/products"
    
    public func fetchProducts(completion: @escaping ([Product]?) -> Void) {
        guard let url = URL(string: self.baseURL) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                DispatchQueue.main.async {
                    completion(products)
                }
            } catch {
                print("Decoding error: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    
    
    public func createProduct(product: Product, completion: @escaping (Product?) -> Void) {
        guard let url = URL(string: baseURL),
              let uploadData = try? JSONEncoder().encode(product) else {
            print("Invalid URL or unable to encode the product")
            return completion(nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making POST request: \(error.localizedDescription)")
                return completion(nil)
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Server responded with status code: \(httpResponse.statusCode)")
                // If possible, print the body of the error response
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    print("Server response body: \(body)")
                }
                return completion(nil)
            }
            guard let data = data else {
                print("No data received from server")
                return completion(nil)
            }
            do {
                let result = try JSONDecoder().decode(Product.self, from: data)
                completion(result)
            } catch {
                print("JSON decoding error: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    
    public func updateProductOnServer(product: Product, completion: @escaping (Bool) -> Void) {
        guard let productID = product.id, let url = URL(string: "\(self.baseURL)/\(productID)") else {
            print("Invalid URL or Product ID")
            completion(false)
            return
        }

        do {
            let uploadData = try JSONEncoder().encode(product)
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = uploadData

            URLSession.shared.dataTask(with: request) { _, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    if let error = error {
                        print("Network request failed: \(error.localizedDescription)")
                    } else {
                        print("Unknown network error or invalid response")
                    }
                    completion(false)
                    return
                }

                if httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    print("HTTP Request failed with statusCode: \(httpResponse.statusCode)")
                    completion(false)
                }
            }.resume()
        } catch {
            print("JSON encoding failed: \(error.localizedDescription)")
            completion(false)
        }
    }



    
    public func deleteProduct(id: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            return completion(false)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Delete failed: \(error?.localizedDescription ?? "Unknown error")")
                return completion(false)
            }
            DispatchQueue.main.async {
                completion(true)
            }
        }.resume()
    }
    
}
