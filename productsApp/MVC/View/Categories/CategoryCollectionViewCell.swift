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
    
    
    private lazy var categoryImageOutterView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.borderWidth = self.bounds.width / 2
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    //Верстка, добавление элементов
    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.tintColor = .customYellow
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir Next", size: 12)
        label.textAlignment = .center
        return label
    }()
    
    //Configure
    public func configure(category: Category) {
        categoryImageView.image = UIImage(named: category.categoryImage)
        categoryNameLabel.text = category.categoryName
    }
    
    private func initUI() {
        self.backgroundColor = .clear
        addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(categoryImageView.frame.size.width)
            make.height.equalTo(categoryImageView.frame.size.height)
        }

        addSubview(categoryNameLabel)
        categoryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
    }
}
