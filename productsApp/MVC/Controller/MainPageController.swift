//
//  MainPageController.swift
//  productsApp
//
//  Created by ibaikaa on 18/1/23.
//

import UIKit
import SnapKit

class MainPageController: UIViewController {
    
    private var deliveryMethodModel = DeliveryMethodGroup.deliveryMethods()
    
    //Setting up order methods collection view
    private lazy var deliveryMethodsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.indicatorStyle = .black
        collectionView.backgroundColor = .clear
        collectionView.register(
            DeliveryMethodCollectionViewCell.self,
            forCellWithReuseIdentifier: DeliveryMethodCollectionViewCell.reuseID
        )
        return collectionView
    }()
    
    
    //categoriesCollectionView
    
    
    private func configureDeliveryMethodsCollectionView () {
        deliveryMethodsCollectionView.dataSource = self
        deliveryMethodsCollectionView.delegate = self
    }
    
    //configCategoriesCollectionView
    
    private func updateUIForDeliveryCell(configure cell: DeliveryMethodCollectionViewCell, with data: Bool) {
        
        if data {
            cell.layer.borderWidth = 0
            cell.backgroundColor = UIColor(red: 0.984, green: 0.737, blue: 0.016, alpha: 1)
        } else {
            cell.layer.borderWidth = 1
            cell.backgroundColor = .clear
        }
    }
    
    //: маркдаун
    private func updateUI () {
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        
        view.addSubview(deliveryMethodsCollectionView)
        
        deliveryMethodsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(10)
            make.height.equalTo(40)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting up background color and constraints of UI-elements for this page
        updateUI()
        //Calling the method that configures DeliveryMethodsCollectionView
        configureDeliveryMethodsCollectionView()
    }
    
    
}


//Extending Controller to two protocols to configure collection view
extension MainPageController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    )
    -> Int {
        return deliveryMethodModel.deliveryMethods.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    )
    -> UICollectionViewCell {
        guard let cell = deliveryMethodsCollectionView
            .dequeueReusableCell (
                withReuseIdentifier: DeliveryMethodCollectionViewCell.reuseID,
                for: indexPath
            ) as? DeliveryMethodCollectionViewCell else {
            fatalError()
        }
        let method = deliveryMethodModel.deliveryMethods[indexPath.row]
        cell.layer.cornerRadius = 16
        cell.configure(method: method)
        cell.layer.borderColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1).cgColor
        updateUIForDeliveryCell(configure: cell, with: method.isCurrentMethod)
        return cell
    }
    
    
}

extension MainPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    )
    -> CGSize {
        CGSize(width: 150, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //creating cell by indexPath
        guard let cell = deliveryMethodsCollectionView.cellForItem(at: indexPath) as? DeliveryMethodCollectionViewCell else {
            fatalError()
        }
        
        //This code allows to avoid unchoosing all the methods that are given
        //1. We are getting over an array to fing the current method that user chose
        //2.1. Using guard, we are expecting that in the best case, user wants to switch current unactive delivery method to active. If it is, we pass and move on
        //2.2 If not, if user wants to unchoose the only active delivery method, we are calling a showAlertIfTryingToUnchooseAll() method, that shows alert and stopping the method.
        for method in deliveryMethodModel.deliveryMethods {
            if method.name == cell.getDeliveryMethodNameLabel().text {
                guard !method.isCurrentMethod else {
                    showAlertIfTryingToUnchooseAll()
                    return
                }
            }
        }
        
        //Switching state for tapped cell
        deliveryMethodModel.deliveryMethods[indexPath.row].isCurrentMethod = !deliveryMethodModel.deliveryMethods[indexPath.row].isCurrentMethod
        
        
        //Switching methods if needed
        switchMethods()
        
        //Reloading data for this collection view
        deliveryMethodsCollectionView.reloadData()
        
        
        func switchMethods() {
            for i in 0..<deliveryMethodModel.deliveryMethods.count {
                if deliveryMethodModel.deliveryMethods[i].isCurrentMethod && deliveryMethodModel.deliveryMethods[i].name != cell.getDeliveryMethodNameLabel().text {
                    deliveryMethodModel.deliveryMethods[i].isCurrentMethod = !deliveryMethodModel.deliveryMethods[i].isCurrentMethod
                }
            }
        }
        
        
        func showAlertIfTryingToUnchooseAll() {
            let errorAlert = UIAlertController (
                title: "Должен быть выбран хотя бы 1 из методов доставки.",
                message: nil,
                preferredStyle: .alert
            )
            
            errorAlert.addAction(
                UIAlertAction (
                    title: "OK",
                    style: .default
                )
            )
            present(errorAlert, animated: true)
        }
        
    }
}
