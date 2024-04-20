import SwiftUI

struct ProductDetailView: View {
    var productId: String
    @ObservedObject var viewModel: ProductsViewModel

    private var product: Product? {
        viewModel.products.first { $0.id == productId }
    }

    @State private var isEditing = false
    @State private var showConfirmationDialog = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let product = product {
                Text("Product Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Divider()

                Group {
                    DetailRow(label: "Product Name:", value: product.name)
                    DetailRow(label: "Quantity:", value: "\(product.quantity)")
                    DetailRow(label: "Price:", value: String(format: "$%.2f", product.price))
                }
                .padding(.horizontal)

                Spacer()
            } else {
                Text("Product not found or has been deleted")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchProducts()  // Fetches all products when the view appears
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button("Edit") {
                    isEditing = true
                }
                Button("Delete") {
                    showConfirmationDialog = true
                }
                .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $isEditing) {
            if let product = product {
                EditProductView(
                    isPresented: $isEditing,
                    product: product,
                    onSave: { updatedProduct in
                        viewModel.updateProduct(updatedProduct) { success in
                            if success {
                                print("Product successfully updated.")
                            } else {
                                print("Failed to update product.")
                            }
                        }
                        isEditing = false
                    },
                    onCancel: {
                        isEditing = false
                        print("User canceled editing.")
                    }
                )
            }
        }
        .confirmationDialog("Are you sure you want to delete this product?", isPresented: $showConfirmationDialog) {
            Button("Delete", role: .destructive) {
                if let product = product {
                    viewModel.deleteProduct(id: product.id ?? "")
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}



struct DetailRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.title2)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 5)
    }
}
