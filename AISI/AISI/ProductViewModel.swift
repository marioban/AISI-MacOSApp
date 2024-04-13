//
//  ProductViewModel.swift
//  AISI
//
//  Created by Mario Ban on 12.04.2024..
//

import Foundation

public class ProductsViewModel: ObservableObject {
    @Published public var products: [Product] = []
    private var apiManager = APIManager()

    public init() {}

    public func fetchProducts() {
        apiManager.fetchProducts { [weak self] newProducts in
            DispatchQueue.main.async {
                self?.products = newProducts ?? []
            }
        }
    }

    public func createProduct(product: Product) {
        apiManager.createProduct(product: product) { [weak self] newProduct in
            if newProduct != nil {
                self?.fetchProducts()
            } else {
                print("Error creating product.")
            }
        }
    }

    func updateProduct(_ product: Product, completion: @escaping (Bool) -> Void) {
        guard let productID = product.id else {
                print("Product ID is nil")
                completion(false)
                return
        }
        
        guard let index = products.firstIndex(where: { $0.id == product.id }) else {
            completion(false)  // Call completion with false if the product isn't found
            return
        }
        
        products[index] = product  // Update the product locally
        
        // Now calling the renamed service function
        apiManager.updateProductOnServer(product: product) { success in
            DispatchQueue.main.async {
                if success {
                    // Handle post-update logic if necessary, e.g., refreshing UI components
                    completion(true)
                } else {
                    print("Failed to update product on server.")
                    completion(false)
                }
            }
        }
    }



    public func deleteProduct(id: String) {
        apiManager.deleteProduct(id: id) { [weak self] success in
            if success {
                self?.fetchProducts()
            } else {
                print("Error deleting product.")
            }
        }
    }

}



