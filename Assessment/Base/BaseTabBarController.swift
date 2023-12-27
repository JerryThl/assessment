//
//  BaseTabBarController.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 25/12/2023.
//

import Foundation
import UIKit

enum TabItem: Int {
    case home = 0
    case settings
    
    var image: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "home_tabbar")?.withRenderingMode(.alwaysOriginal)
        case .settings:
            return UIImage(named: "settings_tabbar")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "home_selected_tabbar")?.withRenderingMode(.alwaysOriginal)
        case .settings:
            return UIImage(named: "settings_selected_tabbar")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    var itemText: String?{
        switch self {
        case .home:
            return "Home"
        case .settings:
            return "Settings"
        }
    }
    
}

class BaseTabBarController: UITabBarController {
    
    let homeVC = BaseNavigationController(rootViewController: HomeVC())
    let settingsVC = BaseNavigationController(rootViewController: SettingsVC())

    var items: [TabItem] = [.home, .settings]
    var selectedTabItem: Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupItem()
    }
    private func setupItem() {
        let vcs: [UIViewController] = [self.homeVC, self.settingsVC]
        
        for (i, item) in items.enumerated() {
            var tabBarItem = UITabBarItem()
            
            if i == selectedTabItem {
                tabBarItem = UITabBarItem(title: item.itemText, image: item.image, selectedImage: item.selectedImage)
            } else {
                tabBarItem = UITabBarItem(title: item.itemText, image: item.image, selectedImage: item.selectedImage)
            }
            tabBarItem.tag = i
            
            vcs[i].tabBarItem = tabBarItem
        }
        self.viewControllers = vcs
        self.selectedIndex = self.selectedTabItem ?? 0
    }
}
