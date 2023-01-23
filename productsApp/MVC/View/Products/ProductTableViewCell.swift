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
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var productTitleLabel: UILabel = {
        generateLabel(font: "Avenir Next Bold", size: 16, textColor: .black)
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let label = generateLabel(
            font: "Avenir Next Italic",
            size: 12,
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
        generateLabel(font: "Avenir Next Bold", size: 20, textColor: .black)
    }()
    
    private lazy var discountBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        view.layer.cornerRadius = view.bounds.size.width / 2
        view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.737254902, blue: 0.01568627451, alpha: 1)
        return view
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = generateLabel(font: "Avenir Next Bold", size: 16, textColor: .white)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
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
            size: 12,
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
            font: "Avenir Next Italic",
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
        let label = generateLabel(font: "Avenir Next", size: 16, textColor: .systemBlue)
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemBlue.cgColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var productCategory: UILabel = {
        let label = generateLabel(font: "Avenir Next Italic", size: 16, textColor: .systemGreen)
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGreen.cgColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.hidesWhenStopped = true
        return view
    }()
    
    public func configureCell(product: Product) {
        guard let imageURLPath = URL(string: product.thumbnail) else {
            print("Incorrect url for image url path")
            return
        }
        downloadImage(from: imageURLPath, to: productImageView)
        
        productTitleLabel.text = product.title
        productDescriptionLabel.text = product.description
        productPriceLabel.text = "\(product.price) $"
        discountLabel.text = "\(product.discountPercentage)% off!"
        ratingLabel.text = "\(product.rating)"
        productsInStockLabel.text = "(\(product.stock) in stock)"
        productBrandLabel.text = product.brand
        productCategory.text = "#\(product.category)"
    }
    
    private func initUI() {
        self.backgroundColor = .white
        //Constraints
    
        addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(200)
        }
        
        addSubview(discountBackgroundView)
        discountBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.top).offset(10)
            make.right.equalTo(productImageView.snp.right).offset(-10)
            make.width.height.equalTo(80)
        }
        
        addSubview(discountLabel)
        discountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(discountBackgroundView.snp.centerX)
            make.centerY.equalTo(discountBackgroundView.snp.centerY)
            make.width.lessThanOrEqualTo(discountBackgroundView.frame.size.width)
            make.height.equalTo(discountBackgroundView.frame.size.height)
        }
        
        addSubview(productTitleLabel)
        productTitleLabel.snp.contentHuggingHorizontalPriority = 252
        productTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.height.lessThanOrEqualTo(20)
            make.width.lessThanOrEqualTo(200)
        }
        
        addSubview(productsInStockLabel)
        productsInStockLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(10)
            make.left.equalTo(productTitleLabel.snp.right).offset(8)
            make.height.equalTo(productTitleLabel.snp.height)
            make.width.lessThanOrEqualTo(100)
        }
        
        addSubview(ratingIconImageView)
        ratingIconImageView.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(20)
        }
        
        addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(10)
            make.right.equalTo(ratingIconImageView.snp.left).offset(-4)
            make.height.equalTo(ratingIconImageView.snp.height)
        }
        
        addSubview(productDescriptionLabel)
        productDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.lessThanOrEqualTo(100)
        }
        
        addSubview(productPriceLabel)
        productPriceLabel.snp.contentHuggingHorizontalPriority += 1
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productDescriptionLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-16)
        }
        
        addSubview(productBrandLabel)
        productBrandLabel.snp.makeConstraints { make in
            make.top.equalTo(productDescriptionLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(productPriceLabel.snp.left).offset(-30)
            make.height.equalTo(30)
        }
        
        addSubview(productCategory)
        productCategory.snp.makeConstraints { make in
            make.top.equalTo(productBrandLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(30)
        }
        
        
        
     
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
    }
    
}

extension ProductTableViewCell {
    private func getData(
        from url: URL,
        completion: @escaping (
            Data?,
            URLResponse?,
            Error?
        ) -> ()
    ) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL, to imageView: UIImageView) {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            
            //Hide UI-elements
            self.productImageView.isHidden = true
            self.productTitleLabel.isHidden = true
            self.productDescriptionLabel.isHidden = true
            self.productCategory.isHidden = true
            self.productBrandLabel.isHidden = true
            self.ratingIconImageView.isHidden = true
            self.ratingLabel.isHidden = true
            self.productsInStockLabel.isHidden = true
            self.discountBackgroundView.isHidden = true
            self.discountLabel.isHidden = true
            self.productPriceLabel.isHidden = true
         
      
            
        }
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
                self.loadingIndicator.stopAnimating()
                
                //Show UI-elements
                self.productImageView.isHidden = false
                self.productTitleLabel.isHidden = false
                self.productDescriptionLabel.isHidden = false
                self.productCategory.isHidden = false
                self.productBrandLabel.isHidden = false
                self.ratingIconImageView.isHidden = false
                self.ratingLabel.isHidden = false
                self.productsInStockLabel.isHidden = false
                self.discountBackgroundView.isHidden = false
                self.discountLabel.isHidden = false
                self.productPriceLabel.isHidden = false
            }
        }
    }
}
