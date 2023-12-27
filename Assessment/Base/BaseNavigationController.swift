//
//  BaseNavigationController.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 22/12/2023.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        initializeNavBar()
        delegate = self
        navigationBar.isTranslucent = false
        interactivePopGestureRecognizer?.delegate = self
        if #available(iOS 11.0, *) {
            automaticallyAdjustsScrollViewInsets = false
        }
        isNavigationBarHidden = false
        
        let navBar = UINavigationBar.appearance()
        navBar.backgroundColor = UIColor.customWhite
//        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
//        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
//        navBar.tintColor = UIColor.white
//        navigationBar.barTintColor = UIColor.white
//        navBar.shadowImage = UIImage()
    }
    
}

extension BaseNavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if (navigationController.viewControllers.count > 1) {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            // hide tabBar
            viewController.navigationItem.largeTitleDisplayMode = .never
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationController?.isNavigationBarHidden = false
            
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
            view.backgroundColor = .clear
            
            let backBtn = UIButton(type: .custom)
            backBtn.frame = CGRect(x: -10, y: 0, width: 44, height: 44)
            backBtn.backgroundColor = .clear
            backBtn.setImage(UIImage(named: "back_button"), for: .normal)
            backBtn.addTarget(self, action: #selector(pop), for: .touchUpInside)
            
            view.addSubview(backBtn)
            
//            backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let leftBarButtonItem = UIBarButtonItem.init(customView: view)
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
            
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.navigationController?.isNavigationBarHidden = false
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:-6, bottom: 0, right: 0)
        let leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        viewControllerToPresent.navigationItem.leftBarButtonItem = leftBarButtonItem
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    /// 返回&出栈
    @objc private func pop() {
        self.popViewController(animated: true)
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
