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
    private var categoryModel = CategoryGroup.init(productsOfCategory: [:])
    private var productsModel = Products(products: [])
    private var brandsModel = BrandGroup(brandProducts: [:])
    
    private func getProductsData() {
        NetworkManager.shared.fetchData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.productsModel = products
                    self.categoryModel = CategoryGroup.productsOfCategory(data: products)
                    self.brandsModel = BrandGroup.productsOfBrand(data: products)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.categoriesCollectionView.reloadData()
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
    
    private var categories: [String] {
        Array(categoryModel.productsOfCategory.keys).sorted(by: >)
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
            print("Count: \(categoryModel.productsOfCategory.count)")
            return categoryModel.productsOfCategory.count
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
            
            let categoryName = categories[indexPath.row].capitalized
            cell.configure(
                category: Category(categoryName: categoryName, categoryImage: categoryName.lowercased())
            )
            return cell
        }
    }
}

extension MainPageController: UICollectionViewDelegateFlowLayout, NavigateToCategoryVC {
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
    
    func passData(to vc: CategoryViewController, categoryName: String) {
        vc.categoryModel = self.categoryModel
        vc.categoryName = categoryName
        vc.title = categoryName.capitalized
    }
    
    func goToCategoryViewController(vc: CategoryViewController) {
        navigationController?.pushViewController(vc, animated: true)
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
            let categoryName = categories[indexPath.row]
            let categoryViewController = CategoryViewController()
            passData(to: categoryViewController, categoryName: categoryName)
            goToCategoryViewController(vc: categoryViewController)
        }
    }
}

//MARK: Extend MainPageController for all the necessary methods and properties for the Extension of DeliveryMethodsCollectionView Delegate
extension MainPageController {
    
    //Alert
    private var errorAlertInDeliveryMethodsCollectionView: UIAlertController {
        let errorAlert = UIAlertController (
            title: "Must choose at least one of the delivery methods!",
            message: nil,
            preferredStyle: .alert
        )
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        return errorAlert
    }
    
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
    
    private func switchMethodState(for cell: DeliveryMethodCollectionViewCell) {
        for i in 0..<deliveryMethodModel.deliveryMethods.count {
            if deliveryMethodModel.deliveryMethods[i].isCurrentMethod && deliveryMethodModel.deliveryMethods[i].name != cell.getDeliveryMethodNameLabel().text {
                deliveryMethodModel.deliveryMethods[i].isCurrentMethod = !deliveryMethodModel.deliveryMethods[i].isCurrentMethod
            }
        }
    }
    
}

extension MainPageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int { productsModel.products.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath )
    -> UITableViewCell {
        guard let cell = productsTableView.dequeueReusableCell(
            withIdentifier: ProductTableViewCell.reuseId,
            for: indexPath
        ) as? ProductTableViewCell else {
            fatalError()
        }
        
        let product = productsModel.products[indexPath.row]
        cell.configureCell(product: product)
        return cell
    }
    
}

extension MainPageController: UITableViewDelegate, NavigateToBrandVC {
    
    func passData(to vc: BrandViewController, brandName: String) {
        vc.brandModel = brandsModel
        vc.brandName = brandName
        vc.title = brandName
    }
    
    func goToBrandViewController(vc: BrandViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView( _ tableView: UITableView, heightForRowAt indexPath: IndexPath ) -> CGFloat { 380 }
    
    func deleteTheProduct() {
        //delete
    }
    
    func viewBrandsProducts(brandName: String) {
        let brandsVC = BrandViewController()
        passData(to: brandsVC, brandName: brandName)
        goToBrandViewController(vc: brandsVC)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let brandName = productsModel.products[indexPath.row].brand
        let action = UIContextualAction(
            style: .normal, title: "View all \(brandName) products ⭐️" ) { [weak self] (action, view, completion) in
            self?.viewBrandsProducts(brandName: brandName)
            completion(true)
        }
        action.backgroundColor = .customYellow
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath )
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .normal, title: "Delete 🗑️") { [weak self] (action, view, completion) in
            self?.deleteTheProduct()
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


