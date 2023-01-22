//
//  ProductTableViewCell.swift
//  productsApp
//
//  Created by ibaikaa on 22/1/23.
//

import UIKit
import SnapKit

class ProductTableViewCell: UITableViewCell {
    static let reuseId: String = String(describing: ProductTableViewCell.self)
    
    private func generateLabel(font name: String, size: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: name, size: size)
        label.textColor = textColor
        label.backgroundColor = .clear
        return label
    }
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var productTitleLabel: UILabel = {
        generateLabel(font: "Avenir Next Bold", size: 18, textColor: .black)
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let label = generateLabel(
            font: "Avenir Next Italic",
            size: 14,
            textColor: UIColor(
                red: 0.512,
                green: 0.512,
                blue: 0.512,
                alpha: 1
            )
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        generateLabel(font: "Avenir Next", size: 15, textColor: .black)
    }()
    
    private lazy var discountBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.cornerRadius = view.bounds.size.width / 2
        view.backgroundColor = .green
        return view
    }()
    
    private lazy var discountLabel: UILabel = {
        generateLabel(font: "Avenir Next", size: 16, textColor: .white)
    }()
    
    private lazy var ratingIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = #colorLiteral(red: 1, green: 0.7456430793, blue: 0, alpha: 1)
        imageView.image = UIImage(systemName: "star.fill")
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        generateLabel(
            font: "Avenir Next",
            size: 14,
            textColor: UIColor(
                red: 0.512,
                green: 0.512,
                blue: 0.512,
                alpha: 1
            )
        )
    }()
    
    private lazy var productsInStockLabel: UILabel = {
        generateLabel(
            font: "Avenir Next",
            size: 14,
            textColor: UIColor(
                red: 0.512,
                green: 0.512,
                blue: 0.512,
                alpha: 1
            )
        )
    }()
    
    private lazy var productBrandLabel: UILabel = {
        generateLabel(font: "Avenir Next", size: 16, textColor: .black)
    }()
    
    private lazy var productCategory: UILabel = {
        generateLabel(font: "Avenir Next Italic", size: 14, textColor: .systemBlue)
    }()
    
    private func configureCell(product: Product) {
        //configure
    }
    
    private func initUI() {
        //make constraints
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
        
    }
    
}

extension ProductTableViewCell {
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    private func downloadImage(from url: URL, to imageView: UIImageView) {
      
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }}
