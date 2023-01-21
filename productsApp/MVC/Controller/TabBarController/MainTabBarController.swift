//
//  MainTabBarController.swift
//  productsApp
//
//  Created by ibaikaa on 21/1/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: SearchPageController(),
                title: "Поиск",
                image: UIImage(systemName: "magnifyingglass")
            ),
            generateVC(
                viewController: MainPageController(),
                title: "Главная",
                image: UIImage(systemName: "house.fill")
            ),
            generateVC(
                viewController: AddPageController(),
                title: "Добавление",
                image: UIImage(systemName: "plus.app.fill")
            )
        ]
        self.selectedIndex = 1
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius:  height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.white.cgColor
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
        
    }
    
    private func generateVC (
        viewController: UIViewController,
        title: String,
        image: UIImage?
    )
    -> UINavigationController {
        let vc = UINavigationController(rootViewController: viewController)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        vc.navigationBar.topItem?.title = title
        vc.navigationBar.prefersLargeTitles = true
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }    
   
}
