//
//  ShowProductInDetailed.swift
//  productsApp
//
//  Created by ibaikaa on 25/1/23.
//

import UIKit

protocol ShowProductInDetailed {
    
    func passData(to destinationVC: ProductDetailedViewController, data: Product)
    
    func showProductDetailedViewController(_ destinationVC: ProductDetailedViewController)
}
