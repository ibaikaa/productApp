//
//  MainPageController.swift
//  productsApp
//
//  Created by ibaikaa on 18/1/23.

import UIKit
import SnapKit

class MainPageController: UIViewController {
    
    //MARK: Models
    private var deliveryMethodModel = DeliveryMethodGroup.deliveryMethods()
    private var categoryModel = CategoryGroup.categories()
    private var productsModel = Products(products: [])
    
    private func getProductsData() {
        NetworkManager.shared.fetchData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.productsModel = products
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.productsTableView.reloadData()
            }
        }
    }
    
    //MARK: Delivery Methods UICollectionView
    private lazy var deliveryMethodsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func configureDeliveryMethodsCollectionView () {
        deliveryMethodsCollectionView.register(
            DeliveryMethodCollectionViewCell.self,
            forCellWithReuseIdentifier: DeliveryMethodCollectionViewCell.reuseID
        )
        deliveryMethodsCollectionView.dataSource = self
        deliveryMethodsCollectionView.delegate = self
    }
    
    
    //MARK: Categories UICollectionView
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func configureCategoriesCollectionView () {
        categoriesCollectionView.register (
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseID
        )
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
    }
    
    //MARK: Products UITableView
    private lazy var productsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private func configureProductsTableView() {
        productsTableView.register(
            ProductTableViewCell.self,
            forCellReuseIdentifier: ProductTableViewCell.reuseId
        )
        productsTableView.dataSource = self
        productsTableView.delegate = self
    }
    
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
        
        view.addSubview(productsTableView)
        productsTableView.snp.makeConstraints { make in
            make.top.equalTo(categoriesCollectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting up background color and constraints of UI-elements for this page
        updateUI()
        //Configuring collectionViews and tableView
        configureDeliveryMethodsCollectionView()
        configureCategoriesCollectionView()
        configureProductsTableView()
        //Getting data from API
        getProductsData()
        
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
            guard let cell = deliveryMethodsCollectionView
                .cellForItem(at: indexPath) as? DeliveryMethodCollectionViewCell else {
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

extension MainPageController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    )
    -> Int {
        return productsModel.products.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    )
    -> UITableViewCell {
        guard let cell = productsTableView
            .dequeueReusableCell(
                withIdentifier: ProductTableViewCell.reuseId,
                for: indexPath
            ) as? ProductTableViewCell else {
            print("error in cell")
            fatalError()
        }
        let product = productsModel.products[indexPath.row]
        cell.configureCell(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete 🗑️") { action, view, completion in
            print("delete")
        }
        delete.backgroundColor = .red
        
        let actions = UISwipeActionsConfiguration(actions: [delete])
        return actions
    }
    
}

extension MainPageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
}
