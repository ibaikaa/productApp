//
//  MainPageController.swift
//  productsApp
//
//  Created by ibaikaa on 18/1/23.

import UIKit
import SnapKit

class MainPageController: UIViewController {
    
    //MARK: Models
    //productModel
    private var deliveryMethodModel = DeliveryMethodGroup.deliveryMethods()
    private var categoryModel = CategoryGroup.categories()
    
    //MARK: Delivery Methods UICollectionView
    //Setting up order methods collection view
    private lazy var deliveryMethodsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(
            DeliveryMethodCollectionViewCell.self,
            forCellWithReuseIdentifier: DeliveryMethodCollectionViewCell.reuseID
        )
        return collectionView
    }()
    
    //Method to conform collection view DeliveryMethodsCollectionView Delegate and DataSource protocols
    private func configureDeliveryMethodsCollectionView () {
        deliveryMethodsCollectionView.dataSource = self
        deliveryMethodsCollectionView.delegate = self
    }
    
    //MARK: Categories UICollectionView
    //Setting up order categories collection view
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register (
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseID
        )
        return collectionView
    }()
    
    //Method to conform collection view CategoriesMethodsCollectionView Delegate and DataSource protocols
    private func configureCategoriesCollectionView () {
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
    }
    
    //productsTableView
    //configureProductsTableView
    //extend with 2 protocols
    //custom tableview cell
    //networklayer
    //parse
    //productmodel
    
    
    //MARK: Method to make constraints
    private func updateUI () {
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(deliveryMethodsCollectionView)
        deliveryMethodsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(4)
            make.height.equalTo(40)
        }
        
        view.addSubview(categoriesCollectionView)
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(deliveryMethodsCollectionView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            make.height.equalTo(120)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting up background color and constraints of UI-elements for this page
        updateUI()
        //Calling the method that configures DeliveryMethodsCollectionView
        configureDeliveryMethodsCollectionView()
        //Calling the method that configures CategoriesCollectionView
        configureCategoriesCollectionView()
    }
}

//Extending Controller to two protocols to configure collection view
extension MainPageController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    )
    -> Int {
        if collectionView == deliveryMethodsCollectionView {
            return deliveryMethodModel.deliveryMethods.count
        } else {
            return categoryModel.categories.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    )
    -> UICollectionViewCell {
        if collectionView == deliveryMethodsCollectionView {
            guard let cell = deliveryMethodsCollectionView
                .dequeueReusableCell (
                    withReuseIdentifier: DeliveryMethodCollectionViewCell.reuseID,
                    for: indexPath
                ) as? DeliveryMethodCollectionViewCell else {
                fatalError()
            }
            let method = deliveryMethodModel.deliveryMethods[indexPath.row]
            cell.configure(method: method)
            return cell
        } else {
            guard let cell = categoriesCollectionView
                .dequeueReusableCell(
                    withReuseIdentifier: CategoryCollectionViewCell.reuseID,
                    for: indexPath
                ) as? CategoryCollectionViewCell else {
                fatalError()
            }
            let category = categoryModel.categories[indexPath.row]
            cell.configure(category: category)
            return cell
        }
    }
}

extension MainPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    )
    -> CGSize {
        if collectionView == deliveryMethodsCollectionView {
            return CGSize(width: 150, height: 40)
        } else {
            return CGSize(width: 110, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == deliveryMethodsCollectionView {
            //creating cell by indexPath
            guard let cell = deliveryMethodsCollectionView.cellForItem(at: indexPath) as? DeliveryMethodCollectionViewCell else {
                fatalError()
            }
            
            avoidUnchoosingAllDeliveryMethods(currentCell: cell)
            
            //Switching state for tapped cell
            deliveryMethodModel.deliveryMethods[indexPath.row].isCurrentMethod = !deliveryMethodModel.deliveryMethods[indexPath.row].isCurrentMethod
            
            //Switching methods if needed
            switchMethodState(for: cell)
            
            //Reloading data for this collection view
            deliveryMethodsCollectionView.reloadData()
        } else {
            guard let _ = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else {
                fatalError()
            }
        }
    }
}


//MARK: Extend MainPageController for all the necessary methods and properties for the Extension of DeliveryMethodsCollectionView Delegate
extension MainPageController {
    //This method allows to avoid unchoosing all the methods that are given
    private func avoidUnchoosingAllDeliveryMethods(currentCell: DeliveryMethodCollectionViewCell) {
        for method in deliveryMethodModel.deliveryMethods {
            if method.name == currentCell.getDeliveryMethodNameLabel().text {
                guard !method.isCurrentMethod else {
                    present(self.errorAlertInDeliveryMethodsCollectionView, animated: true)
                    return
                }
            }
        }
    }
    
    //Alert
    private var errorAlertInDeliveryMethodsCollectionView: UIAlertController {
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
        return errorAlert
    }
    
    private func switchMethodState(for cell: DeliveryMethodCollectionViewCell) {
        for i in 0..<deliveryMethodModel.deliveryMethods.count {
            if deliveryMethodModel.deliveryMethods[i].isCurrentMethod && deliveryMethodModel.deliveryMethods[i].name != cell.getDeliveryMethodNameLabel().text {
                deliveryMethodModel.deliveryMethods[i].isCurrentMethod = !deliveryMethodModel.deliveryMethods[i].isCurrentMethod
            }
        }
    }
}

