//
//  Product.swift
//  productsApp
//
//  Created by ibaikaa on 19/1/23.
//

import Foundation

struct Products: Codable {
    let products: [Product]
}

struct Product: Codable {
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
}



