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
                Section(header: Text("Add Product").fontWeight(.bold)) {
                    TextField("Product Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title2)
                        .padding(.vertical, 10)
                    TextField("Quantity", text: $quantity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 10)
                    TextField("Price", text: $price)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 10)
                }
                
                    Button("Add") {
                        addProduct()
                    }
                    .disabled(name.isEmpty || quantity.isEmpty || price.isEmpty)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
        .frame(width: 250, height: 260)
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
