# Product Management App

## Overview
This SwiftUI-based iOS app allows users to manage a catalog of products efficiently. It supports CRUD (Create, Read, Update, Delete) operations to handle products dynamically with real-time updates. The app integrates with a Node.js backend via RESTful APIs, ensuring seamless synchronization and robust data management capabilities.

## Features

- **Real-Time Data Updates**: Fetch and display the list of products, with capabilities to add, update, and delete products.
- **SwiftUI Views**:
  - **Product List**: View all products in a list, which updates dynamically as products are added or changed.
  - **Product Details**: Detailed view of each product, allowing for modifications and deletion.
  - **Add Product**: Add new products to the catalog with fields for product name, quantity, and price.
- **Responsive Design**: Built with SwiftUI, ensuring a smooth and responsive user experience that adheres to modern iOS standards.
- **Backend Integration**: Utilizes a Node.js server with MongoDB for persistent storage, handling complex queries and data storage with ease.

## Technology Stack

- **Frontend**: SwiftUI
- **Backend**:
  - **Server**: Node.js with Express
  - **Database**: MongoDB
  - **APIs**: RESTful APIs
- **Other Tools**:
  - **Xcode**: For development and testing
  - **MongoDB Atlas**: For database management

## Getting Started

### Prerequisites
- Xcode 12 or later
- Swift 5.3 or later
- macOS Catalina or later
- An active MongoDB Atlas database

## Screens

1. **Main Screen**:
   - The main screen lists all products.
   - Tap on a product to view details, edit, or delete.
   - Use the "Add Product" button to add new products.

2. **Add/Edit Product**:
   - Enter the name, quantity, and price.
   - Submit to add/update the product in the database.

3. **Delete Product**:
   - From the product details view, a delete option allows the user to remove the product permanently.
