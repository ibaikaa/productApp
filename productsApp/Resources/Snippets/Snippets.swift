//
//  bottomSheetVC.swift
//  productsApp
//
//  Created by ibaikaa on 25/1/23.
//

import UIKit



final class Snippets {
    static let shared = Snippets()
    
    public func createBottomSheetVC(from vc: UIViewController){
        if let bottomSheet = vc.sheetPresentationController {
            bottomSheet.detents = [.medium(), .large()]
            bottomSheet.preferredCornerRadius = 20
            bottomSheet.prefersScrollingExpandsWhenScrolledToEdge = true
            bottomSheet.prefersGrabberVisible = true
        }
    }

}

