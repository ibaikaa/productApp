//
//  ProductDetailedViewController.swift
//  productsApp
//
//  Created by ibaikaa on 24/1/23.
//

import UIKit
import SnapKit

class ProductDetailedViewController: UIViewController {
    
    private func generateLabel(
        font name: String,
        size: CGFloat,
        textColor: UIColor
    )
    -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: name, size: size)
        label.textColor = textColor
        label.backgroundColor = .clear
        return label
    }
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        generateLabel(font: "Avenir Next Bold", size: 20, textColor: .black)
    }()
    
    private lazy var descriptionLabel: UILabel = {
        generateLabel(font: "Avenir Next Italic", size: 16, textColor: .black)
    }()
    
    private lazy var brandWordLabel: UILabel = {
        let label = generateLabel(font: "Avenir Next", size: 16, textColor: .black)
        label.text = "Brand: "
        return label
    }()
    
    private lazy var brandLabel: UILabel = {
        generateLabel(font: "Avenir Next Bold", size: 16, textColor: .black)
    }()
    
    private lazy var categoryWordLabel: UILabel = {
        generateLabel(font: "Avenir Next", size: 16, textColor: .black)
    }()
    
    private lazy var categoryLabel: UILabel = {
        generateLabel(font: "Avenir Next Bold", size: 16, textColor: .black)
    }()
    
    private lazy var stockLabel: UILabel = {
        generateLabel(font: "Avenir Next Bold", size: 16, textColor: .black)
    }()
    
    private lazy var costLabel: UILabel = {
        generateLabel(font: "Avenir Next Bold", size: 18, textColor: .black)
    }()
    
    private lazy var saleLabel: UILabel = {
        generateLabel(font: "Avenir Next Bold", size: 18, textColor: .systemRed)
    }()
    
    
    
    
    public func configureVC(with: Product) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
