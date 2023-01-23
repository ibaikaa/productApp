//
//  NavigateToBrandVC.swift
//  productsApp
//
//  Created by ibaikaa on 23/1/23.
//

import UIKit

protocol NavigateToBrandVC {
    func passData(to vc: BrandViewController, brandName: String)
    func goToBrandViewController(vc: BrandViewController)
}

