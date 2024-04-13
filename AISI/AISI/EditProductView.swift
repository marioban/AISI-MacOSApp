//
//  EditProductView.swift
//  AISI
//
//  Created by Mario Ban on 12.04.2024..
//

import SwiftUI

struct EditProductView: View {
    @Binding var isPresented: Bool
    var onSave: (Product) -> Void
    var onCancel: () -> Void

    // Editable state for product properties
    @State private var draftName: String
    @State private var draftQuantity: Int
    @State private var draftPrice: Double

    // The product's ID doesn't change, so it can be a constant
    let productID: String

    init(isPresented: Binding<Bool>, product: Product, onSave: @escaping (Product) -> Void, onCancel: @escaping () -> Void) {
        self._isPresented = isPresented
        self.onSave = onSave
        self.onCancel = onCancel
        self.productID = product.id ?? ""

        // Initialize the local state with the product's current values
        _draftName = State(initialValue: product.name)
        _draftQuantity = State(initialValue: product.quantity)
        _draftPrice = State(initialValue: product.price)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Product Name", text: $draftName)
                TextField("Quantity", value: $draftQuantity, formatter: NumberFormatter())
                TextField("Price", value: $draftPrice, formatter: NumberFormatter())

                Button("Save") {
                    // Use the constant `productID` to construct the updated product
                    let updatedProduct = Product(id: productID, name: draftName, quantity: draftQuantity, price: draftPrice)
                    onSave(updatedProduct)
                }
                Button("Cancel", action: onCancel)
            }
            .navigationTitle("Edit Product")
        }
    }
}
