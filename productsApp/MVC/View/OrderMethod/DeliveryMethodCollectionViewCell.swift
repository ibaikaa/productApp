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
        icon.tintColor = UIColor(red: 0.361, green: 0.588, blue: 0.157, alpha: 1)
        icon.backgroundColor = .clear
        return icon
    }()
    
    private lazy var deliveryMethodNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.361, green: 0.588, blue: 0.157, alpha: 1)
        label.font = UIFont(name: "Avenir Next", size: 16)
        return label
    }()
    
    public func getDeliveryMethodNameLabel () -> UILabel { deliveryMethodNameLabel }
    
    
    public func configure(method: DeliveryMethod) {
        configureImageView(deliveryMethodIconImageView, withIconNamed: method.iconName, cell: DeliveryMethodCollectionViewCell.reuseID)
        deliveryMethodNameLabel.text = method.name
        
        if method.isCurrentMethod {
            deliveryMethodNameLabel.textColor = .white
            deliveryMethodIconImageView.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.87)
        } else {
            deliveryMethodNameLabel.textColor = UIColor(red: 0.361, green: 0.588, blue: 0.157, alpha: 1)
            deliveryMethodIconImageView.tintColor = UIColor(red: 0.361, green: 0.588, blue: 0.157, alpha: 1)
        }
        initUI()
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
    
    
    
}
