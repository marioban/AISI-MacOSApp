//
//  ProductRowView.swift
//  AISI
//
//  Created by Mario Ban on 12.04.2024..
//

import SwiftUI
struct ProductRow: View {
    var product: Product
    var viewModel: ProductsViewModel

    var body: some View {
        NavigationLink(destination: ProductDetailView(productId: product.id ?? "", viewModel: viewModel)) {
            Text(product.name)
        }
    }
}
