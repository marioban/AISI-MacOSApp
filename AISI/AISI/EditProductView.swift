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
    
    @State private var draftName: String
    @State private var draftQuantity: Int
    @State private var draftPrice: Double
    
    let productID: String
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init(isPresented: Binding<Bool>, product: Product, onSave: @escaping (Product) -> Void, onCancel: @escaping () -> Void) {
        self._isPresented = isPresented
        self.onSave = onSave
        self.onCancel = onCancel
        self.productID = product.id ?? ""
        _draftName = State(initialValue: product.name)
        _draftQuantity = State(initialValue: product.quantity)
        _draftPrice = State(initialValue: product.price)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details").fontWeight(.bold)) {
                    TextField("Product Name", text: $draftName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title2)
                        .padding(.vertical, 10)
                    TextField("Quantity", value: $draftQuantity, formatter: numberFormatter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 10)
                    TextField("Price", value: $draftPrice, formatter: numberFormatter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 10)
                }
                
                Section {
                    Button("Save") {
                        let updatedProduct = Product(id: productID, name: draftName, quantity: draftQuantity, price: draftPrice)
                        onSave(updatedProduct)
                        isPresented = false
                    }
                    .buttonStyle(FilledButtonStyle())
                    .padding(.vertical, 10)
                    
                    Button("Cancel", action: onCancel)
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.vertical, 10)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .navigationTitle("Edit Product")
            .background(Color(.secondarySystemFill))
        }
        .frame(width: 300, height: 290)
        .cornerRadius(12)
        .shadow(radius: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}


// A custom button style for the Save button
struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}



#if canImport(UIKit)
extension View {
    func dismissKeyboardOnTap() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
#endif
