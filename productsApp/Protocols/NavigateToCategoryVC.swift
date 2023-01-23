//
//  getCategoryData.swift
//  productsApp
//
//  Created by ibaikaa on 23/1/23.
//

import Foundation

protocol NavigateToCategoryVC {
    func passData(to vc: CategoryViewController, categoryName: String)
    func goToCategoryViewController(vc: CategoryViewController)
}
