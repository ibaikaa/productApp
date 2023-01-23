//
//  Category.swift
//  productsApp
//
//  Created by ibaikaa on 19/1/23.
//

import UIKit

public struct Category {
    let categoryName, categoryImage: String
}

public struct CategoryGroup {
    var productsOfCategory: [String: [Product]]
}

extension CategoryGroup {

    internal static func productsOfCategory(data: Products) -> CategoryGroup {
        var categoryAndProducts: [String: [Product]] = [:]
        
        for product in data.products {
            categoryAndProducts[product.category] = []
        }
        
        for product in data.products {
            guard categoryAndProducts[product.category] != nil else {
                print("some mess in producsOfCategory() method. Returned empty dict.")
                return CategoryGroup(productsOfCategory: [:])
            }
            categoryAndProducts[product.category]!.append(product)
        }
        
        return CategoryGroup(productsOfCategory: categoryAndProducts)
    }
}
