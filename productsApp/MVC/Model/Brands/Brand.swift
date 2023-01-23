//
//  Brand.swift
//  productsApp
//
//  Created by ibaikaa on 23/1/23.
//

import Foundation

public struct Brand {
    let brandName: String
}

public struct BrandGroup {
    var brandProducts: [String: [Product]]
}

extension BrandGroup {

    internal static func productsOfBrand(data: Products) -> BrandGroup {
        var brandAndItsProducts: [String: [Product]] = [:]
        
        for product in data.products {
            brandAndItsProducts[product.brand] = []
        }
        
        for product in data.products {
            guard brandAndItsProducts[product.brand] != nil else {
                print("some mess in productsOfBrand() method. Returned empty dict.")
                return BrandGroup(brandProducts: [:])
            }
            brandAndItsProducts[product.brand]!.append(product)
        }
        
        return BrandGroup(brandProducts: brandAndItsProducts)
    }
}
