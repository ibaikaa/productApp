//
//  CategoryCollectionViewCell.swift
//  productsApp
//
//  Created by ibaikaa on 19/1/23.
//

import UIKit
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let reuseID = String(describing: CategoryCollectionViewCell.self)
    
    //Верстка, добавление элементов
    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.tintColor = .customYellow
        return imageView
    }()
    
    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir Next", size: 10)
        label.backgroundColor = .clear
        return label
    }()
    
    //Configure
    public func configure(category: Category) {
        initUI(imageViewRectangleSize: category.rectangleIcon)

        configureImageView (
            categoryImageView,
            withIconNamed: category.categoryImage,
            cell: CategoryCollectionViewCell.reuseID
        )
        categoryNameLabel.text = category.categoryName
    }
    
    private func initUI(imageViewRectangleSize: Bool) {
        //Constraints
        self.layer.backgroundColor = UIColor.white.cgColor
        addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
        }
        
        switch imageViewRectangleSize {
        case true:
            categoryImageView.snp.makeConstraints { make in
                make.width.height.equalTo(60)
            }
        case false:
            categoryImageView.snp.makeConstraints { make in
                make.width.equalTo(80)
                make.height.equalTo(60)
            }
        }

        addSubview(categoryNameLabel)
        categoryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
}
