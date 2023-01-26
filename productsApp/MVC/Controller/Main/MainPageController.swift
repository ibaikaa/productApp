//
//  MainPageController.swift
//  productsApp
//
//  Created by ibaikaa on 18/1/23.

import UIKit
import SnapKit

class MainPageController: UIViewController {
    // MARK: Models
    private var deliveryMethodModel = DeliveryMethodGroup.deliveryMethods()
    private var categoryModel = CategoryGroup.init(productsOfCategory: [:])
    private var productsModel = Products(products: [])
    private var brandsModel = BrandGroup(brandProducts: [:])
    
    private var deliveryMethods: [DeliveryMethod] {
        deliveryMethodModel.deliveryMethods
    }
    
    private var categories: [String] {
        Array(categoryModel.productsOfCategory.keys).sorted(by: >)
    }
    
    private func getProductsDataFromAPI() {
        NetworkManager.shared.fetchData { [weak self] result in
            guard let self = self else { return }
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
    
    // MARK: Delivery Methods UICollectionView
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
    
    // MARK: Categories UICollectionView
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func configureCategoriesCollectionView () {
        categoriesCollectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseID
        )
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
    }
    
    // MARK: Products UITableView
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
    
    // MARK: Method to make constraints
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
        // Setting up background color and constraints of UI-elements for this page
        updateUI()
        // Configuring collectionViews and tableView
        configureDeliveryMethodsCollectionView()
        configureCategoriesCollectionView()
        configureProductsTableView()
        // Getting data from API
        getProductsDataFromAPI()
        
    }
}

// Extending Controller to two protocols to configure collection view
extension MainPageController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    )
    -> Int {
        if collectionView == deliveryMethodsCollectionView {
            return deliveryMethods.count
        } else {
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        if collectionView == deliveryMethodsCollectionView {
            guard let cell = deliveryMethodsCollectionView
                .dequeueReusableCell(
                    withReuseIdentifier: DeliveryMethodCollectionViewCell.reuseID,
                    for: indexPath
                ) as? DeliveryMethodCollectionViewCell else { return UICollectionViewCell() }
            let method = deliveryMethodModel.deliveryMethods[indexPath.row]
            cell.configure(method: method)
            return cell
        } else {
            guard let cell = categoriesCollectionView
                .dequeueReusableCell(
                    withReuseIdentifier: CategoryCollectionViewCell.reuseID,
                    for: indexPath
                ) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            
            let categoryName = categories[indexPath.row].capitalized
            cell.configure(
                category: Category(categoryName: categoryName, categoryImage: categoryName.lowercased())
            )
            return cell
        }
    }
}

// Extend MainPageController to SwitchingDeliveryMethods for
// UICollectionView named deliveryMethodsCollectionView didSelectItemAt method functionality
extension MainPageController: SwitchingDeliveryMethods {
    // Alert
    private var mustHaveOneMethodOnAlert: UIAlertController {
        let alert = UIAlertController(
            title: "Must choose at least one of the delivery methods!",
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }

    func tryingUnchooseAllMethods(method: DeliveryMethod) -> Bool {
        var result = false
        deliveryMethodModel.deliveryMethods.forEach {
            if $0.isCurrentMethod && $0.name == method.name {
                result = true
            }
        }
        return result
    }
    
    func switchDeliveryMethods(newMethod: DeliveryMethod) {
        // Nested function that makes previous method not currently actual
        func turnOffLastMethod() {
            for index in deliveryMethods.indices
            where deliveryMethods[index].isCurrentMethod && deliveryMethods[index].name != newMethod.name {
                deliveryMethodModel.deliveryMethods[index].isCurrentMethod.toggle()
            }
        }
        // Code below switches the methods
        for index in deliveryMethods.indices where deliveryMethods[index].name == newMethod.name {
            turnOffLastMethod()
            deliveryMethodModel.deliveryMethods[index].isCurrentMethod.toggle()
        }
    }
}

// Extend MainPageController to SwitchingDeliveryMethods for
// UICollectionView named categoriesCollectionView didSelectItemAt method functionality
extension MainPageController: NavigateToCategoryVC {
    func passData(to destinationVC: CategoryViewController, categoryName: String) {
        destinationVC.categoryModel = self.categoryModel
        destinationVC.categoryName = categoryName
        destinationVC.title = categoryName.capitalized
    }
    
    func goToCategoryViewController(destinationVC: CategoryViewController) {
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension MainPageController: UICollectionViewDelegateFlowLayout {
    // Setting up the size of cells for UICollectionViews
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
            let chosenMethod = deliveryMethods[indexPath.row]
            guard !tryingUnchooseAllMethods(method: chosenMethod) else {
                present(mustHaveOneMethodOnAlert, animated: true)
                return
            }
            switchDeliveryMethods(newMethod: chosenMethod)
            deliveryMethodsCollectionView.reloadData()
        } else {
            let categoryName = categories[indexPath.row]
            let categoryViewController = CategoryViewController()
            passData(to: categoryViewController, categoryName: categoryName)
            goToCategoryViewController(destinationVC: categoryViewController)
        }
    }
}

// Configuring productsTableView, conforming to UITableViewDataSource protocol
extension MainPageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int )
    -> Int { productsModel.products.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        guard let cell = productsTableView
            .dequeueReusableCell(
                withIdentifier: ProductTableViewCell.reuseId,
                for: indexPath
            ) as? ProductTableViewCell else { return UITableViewCell() }
        let product = productsModel.products[indexPath.row]
        cell.configureCell(product: product)
        return cell
    }
    
}

extension MainPageController: NavigateToBrandVC {
    func passData(to destinationVC: BrandViewController, brandName: String) {
        destinationVC.brandModel = brandsModel
        destinationVC.brandName = brandName
        destinationVC.title = brandName
    }
    
    func goToBrandViewController(destinationVC: BrandViewController) {
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func viewBrandsProductsPage(brandName: String) {
        let brandsVC = BrandViewController()
        passData(to: brandsVC, brandName: brandName)
        goToBrandViewController(destinationVC: brandsVC)
    }
}

extension MainPageController: RESTActions {
    func deleteTheProduct() {
        // delete from POST
    }
}

// Signing MainPageController under UITableViewDelegate protocol
// Setting up the height for the row with the corresponding method
extension MainPageController: UITableViewDelegate {
    func tableView( _ tableView: UITableView, heightForRowAt indexPath: IndexPath ) -> CGFloat { 380 }
}

// Configuratin leading and trailing swipe actions
extension MainPageController {
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let brandName = productsModel.products[indexPath.row].brand
        let action = UIContextualAction(
            style: .normal, title: "View all \(brandName) products ⭐️" ) { [weak self] (_, _, completion) in
                self?.viewBrandsProductsPage(brandName: brandName)
                completion(true)
            }
        action.backgroundColor = .customYellow
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .normal, title: "Delete") { [weak self] (_, _, completion) in
                self?.deleteTheProduct()
                completion(true)
            }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


extension MainPageController: ShowProductInDetailed {
    func passData(to destinationVC: ProductDetailedViewController, data: Product) {
        destinationVC.configureVC(with: data)
    }
    
    func showProductDetailedViewController(_ destinationVC: ProductDetailedViewController) {
        Snippets.shared.createBottomSheetVC(from: destinationVC)
        present(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedVC = ProductDetailedViewController()
        passData(to: detailedVC, data: productsModel.products[indexPath.row])
        showProductDetailedViewController(detailedVC)
    }
}
