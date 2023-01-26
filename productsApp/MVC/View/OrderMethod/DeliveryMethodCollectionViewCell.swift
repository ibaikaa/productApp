//
//  OrderMethodCollectionViewCell.swift
//  productsApp
//
//  Created by ibaikaa on 18/1/23.
//

import UIKit
import SnapKit

class DeliveryMethodCollectionViewCell: UICollectionViewCell {
    static let reuseID = String(describing: DeliveryMethodCollectionViewCell.self)
    
    private lazy var deliveryMethodIconImageView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .cellLightContent
        icon.backgroundColor = .clear
        return icon
    }()
    
    private lazy var deliveryMethodNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cellLightContent
        label.font = UIFont(name: "Avenir Next", size: 16)
        return label
    }()
    
    public func configure(method: DeliveryMethod) {
        self.layer.cornerRadius = 16
        self.layer.borderColor =  UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1).cgColor

        configureImageView(deliveryMethodIconImageView, withIconNamed: method.iconName, cell: DeliveryMethodCollectionViewCell.reuseID)
        deliveryMethodNameLabel.text = method.name
        
        if method.isCurrentMethod {
            self.layer.borderWidth = 0
            self.backgroundColor = .customYellow
            deliveryMethodNameLabel.textColor = .white
            deliveryMethodIconImageView.tintColor = .white
        } else {
            self.layer.borderWidth = 1
            self.backgroundColor = .clear
            deliveryMethodNameLabel.textColor = .cellLightContent
            deliveryMethodIconImageView.tintColor = .cellLightContent
        }
    }
    
    private func initUI() {
        addSubview(deliveryMethodIconImageView)
        deliveryMethodIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(16)
        }
        
        addSubview(deliveryMethodNameLabel)
        deliveryMethodNameLabel.snp.makeConstraints { make in
            make.left.equalTo(deliveryMethodIconImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
    }
    
}
