//
//  AddProductView.swift
//  AISI
//
//  Created by Mario Ban on 12.04.2024..
//

import SwiftUI

struct AddProductView: View {
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var quantity = ""
    @State private var price = ""
    @EnvironmentObject var viewModel: ProductsViewModel

    var body: some View {
        NavigationView {
            Form {
                TextField("Product Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Quantity", text: $quantity)
                TextField("Price", text: $price)
                Button("Add") {
                    addProduct()
                }
                .disabled(name.isEmpty || quantity.isEmpty || price.isEmpty)
            }
            .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func addProduct() {
        guard let quantityInt = Int(quantity), let priceDouble = Double(price) else {
            return  // Optionally handle the error, e.g., show an alert
        }
        
        let newProduct = Product(name: name, quantity: quantityInt, price: priceDouble)
        viewModel.createProduct(product: newProduct)
        isPresented = false
    }
}
