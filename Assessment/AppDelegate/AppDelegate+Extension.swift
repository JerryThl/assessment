//
//  AppDelegate+Extension.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 20/12/2023.
//

import Foundation
import UIKit
import GoogleSignIn

extension AppDelegate{
    
    func initLaunchScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        let launchVC = LaunchScreenVC()
        appDelegate_const.window?.rootViewController = launchVC
        appDelegate_const.window?.makeKeyAndVisible()
    }
    
    func initRootVC() {
        let mainView = BaseNavigationController(rootViewController: AuthPage())
        appDelegate_const.window?.rootViewController = mainView
        appDelegate_const.window?.makeKeyAndVisible()
    }
    
    func initHomeVC() {
        let mainView = BaseNavigationController(rootViewController: HomeVC())
        
        appDelegate_const.window?.rootViewController = BaseTabBarController()
        appDelegate_const.window?.makeKeyAndVisible()
    }
    
}
