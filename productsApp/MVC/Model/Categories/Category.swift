//
//  Category.swift
//  productsApp
//
//  Created by ibaikaa on 19/1/23.
//

import Foundation

public struct Category {
    let categoryName, categoryImage: String
}


public struct CategoryGroup {
    let categories: [Category]
}

extension CategoryGroup {
    
    public static func categories() -> CategoryGroup {
        let categories: [Category] = [
            .init(categoryName: "Smartphones", categoryImage: "person.circle.fill"),
            .init(categoryName: "Laptops", categoryImage: "person.circle.fill"),
            .init(categoryName: "Fragrances", categoryImage: "person.circle.fill"),
            .init(categoryName: "Home-decoration", categoryImage: ""),
            .init(categoryName: "Groceries", categoryImage: "")
        ]
        
        return CategoryGroup(categories: categories)
    }
}
