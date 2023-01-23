//
//  BrandViewController.swift
//  productsApp
//
//  Created by ibaikaa on 23/1/23.
//

import UIKit
import SnapKit

class BrandViewController: UIViewController {
    
    public var brandModel = BrandGroup(brandProducts: [:])
    
    public var brandName: String = ""
    
    private var brandProducts: [Product] {
        return self.brandModel.brandProducts[brandName] ?? []
    }
    
    
    
    private lazy var brandProductsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private func configureBrandProductsTableView() {
        brandProductsTableView.dataSource = self
        brandProductsTableView.delegate = self
        brandProductsTableView
            .register(
                ProductTableViewCell.self,
                forCellReuseIdentifier: ProductTableViewCell.reuseId
            )
    }
    
    private func updateUI() {
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(brandProductsTableView)
        brandProductsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBrandProductsTableView()
        updateUI()
    }
}

extension BrandViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        brandProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = brandProductsTableView
            .dequeueReusableCell(
                withIdentifier: ProductTableViewCell.reuseId,
                for: indexPath
            ) as? ProductTableViewCell else {
            fatalError()
        }
        let product = brandProducts[indexPath.row]
        cell.configureCell(product: product)
        return cell
    }
}

extension BrandViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    )
    -> CGFloat { 380 }
}

