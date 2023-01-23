//
//  CategoryViewController.swift
//  productsApp
//
//  Created by ibaikaa on 23/1/23.
//

import UIKit
import SnapKit

class CategoryViewController: UIViewController {
    
    public var categoryModel = CategoryGroup(productsOfCategory: [:])
    
    public var categoryName: String  = ""
    
    private var categoryProducts: [Product] {
        return self.categoryModel.productsOfCategory[categoryName] ?? []
    }
    
    private lazy var categoryProductsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private func configureCategoryProductsTableView () {
        categoryProductsTableView.dataSource = self
        categoryProductsTableView.delegate = self
        categoryProductsTableView
            .register(
                ProductTableViewCell.self,
                forCellReuseIdentifier: ProductTableViewCell.reuseId
            )
    }
    
    private func updateUI () {
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(categoryProductsTableView)
        categoryProductsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCategoryProductsTableView()
        updateUI()
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    )
    -> Int {
        return categoryProducts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    )
    -> UITableViewCell {
        guard let cell = categoryProductsTableView
            .dequeueReusableCell(
                withIdentifier: ProductTableViewCell.reuseId,
                for: indexPath
            ) as? ProductTableViewCell else {
            fatalError()
        }
        let product = categoryProducts[indexPath.row]
        cell.configureCell(product: product)
        return cell
    }
    
    
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    )
    -> CGFloat { 380 }
}
