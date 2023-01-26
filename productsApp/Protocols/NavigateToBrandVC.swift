//
//  NavigateToBrandVC.swift
//  productsApp
//
//  Created by ibaikaa on 23/1/23.
//

import UIKit

protocol NavigateToBrandVC {
    func passData(to destinationVC: BrandViewController, brandName: String)
    func goToBrandViewController(destinationVC: BrandViewController)
}

