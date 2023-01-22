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
    let categories: [Category]
}

extension CategoryGroup {

    public static func categories() -> CategoryGroup {
        let categories: [Category] = [
            .init(categoryName: "Smartphones", categoryImage: "phones"),
            .init(categoryName: "Laptops", categoryImage: "laptops"),
            .init(categoryName: "Fragrances", categoryImage: "fragrances"),
            .init(categoryName: "Home-decoration", categoryImage: "home-decoration"),
            .init(categoryName: "Groceries", categoryImage: "groceries"),
            .init(categoryName: "Skincare", categoryImage: "skin-care"),
        ]
        
        return CategoryGroup(categories: categories)
    }
}
