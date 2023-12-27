//
//  AppDelegate.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 20/12/2023.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let users = RealmManager.shared.realm.objects(User.self)
        if (users.count > 0){
            if (users.first!.loginType != AppLoginType.Normal.rawValue){
                GIDSignIn.sharedInstance.restorePreviousSignIn { [self] user, error in
                    if error != nil || user == nil {
                        // Show the app's signed-out state.
                        initLaunchScreen()
                    } else {
                        initHomeVC()
                    }
                }
            }else{
                initHomeVC()
            }
        }else{
            initLaunchScreen()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        return false
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Assessment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

