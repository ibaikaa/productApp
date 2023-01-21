//
//  Category.swift
//  productsApp
//
//  Created by ibaikaa on 19/1/23.
//

import Foundation

public struct Category {
    let categoryName, categoryImage: String
    let rectangleIcon: Bool
}


public struct CategoryGroup {
    let categories: [Category]
}

extension CategoryGroup {
    
    public static func categories() -> CategoryGroup {
        let categories: [Category] = [
            .init(categoryName: "Smartphones", categoryImage: "iphone.homebutton", rectangleIcon: true),
            .init(categoryName: "Laptops", categoryImage: "laptopcomputer",rectangleIcon: false),
            .init(categoryName: "Fragrances", categoryImage: "sparkles", rectangleIcon: true),
            .init(categoryName: "Home-decoration", categoryImage: "sofa.fill", rectangleIcon: false),
            .init(categoryName: "Groceries", categoryImage: "cart.fill", rectangleIcon: false),
            .init(categoryName: "Skincare", categoryImage: "theatermask.and.paintbrush.fill", rectangleIcon: false)
        ]
        
        return CategoryGroup(categories: categories)
    }
}
