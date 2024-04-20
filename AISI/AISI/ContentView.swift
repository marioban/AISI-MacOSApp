//
//  ContentView.swift
//  AISI
//
//  Created by Mario Ban on 09.04.2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductsViewModel()
    @State private var showingAddProductView = false  // State to control the presentation of AddProductView

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.products, id: \.id) { product in
                    NavigationLink(destination: ProductDetailView(productId: product.id ?? "", viewModel: viewModel)) {
                        Text(product.name)
                    }
                }
                .onDelete(perform: deleteProducts)
            }
            .navigationTitle("Products")
            .toolbar {
                Button("Add Product") {
                    showingAddProductView = true
                }
            }
            .sheet(isPresented: $showingAddProductView) {
                AddProductView(isPresented: $showingAddProductView)
                    .environmentObject(viewModel)
            }
            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }

    private func deleteProducts(at offsets: IndexSet) {
        offsets.forEach { index in
            let productId = viewModel.products[index].id
            viewModel.deleteProduct(id: productId ?? "")
        }
    }
}


#Preview {
    ContentView()
}
