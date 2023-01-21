//
//  MainTabBarController.swift
//  productsApp
//
//  Created by ibaikaa on 21/1/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //Method to create VC
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
    
    //Method that generates tab bar
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
    
    //Method that sets up UI of the tab bar
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
        
        //Setting bezier
        roundLayer.path = bezierPath.cgPath
        //Setting layer to tabBar
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        //Setting up tabBar width
        tabBar.itemWidth = width / 5
        //Setting up items positioning
        tabBar.itemPositioning = .centered
        //Background of custom layer
        roundLayer.fillColor = UIColor.white.cgColor
        //Setting up tint color of chosen item
        tabBar.tintColor = .tabBarItemAccent
        //Setting up tint color for non-chosen item
        tabBar.unselectedItemTintColor = .tabBarItemLight
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }    
   
}
