//
//  SettingsVC.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 25/12/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Toast
import RealmSwift
import GoogleSignIn

class SettingsVC:UIViewController{
    
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnPassword: UIButton!
    @IBOutlet var btnLogout: UIButton!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVM()
    }
    
    private func bindVM(){
      
        self.lblUsername.text = RealmManager.shared.realm.objects(User.self).first?.email
        
        self.lblDate.text = Date().formatDate(newFormat: "MMM dd, yyyy")
        
        self.btnPassword.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            
            let users = RealmManager.shared.realm.objects(User.self)
            if (users.first!.loginType != AppLoginType.Normal.rawValue){
                self.view.makeToast("No password needed as you login using 3rd party method", duration: 3.0, position: .bottom)
            }else{
                self.navigationController?.pushViewController(ChangePasswordVC(), animated: true)
            }
            
        }).disposed(by: disposeBag)
        
        self.btnLogout.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            GIDSignIn.sharedInstance.signOut()
            RealmManager.shared.delete(RealmManager.shared.realm.objects(User.self).toArray())
            
            guard let navigationController = self.navigationController else { return }
            var navigationArray = navigationController.viewControllers
            navigationArray.removeAll()
            self.navigationController?.viewControllers = navigationArray
            appDelegate_const.initRootVC()
            
        }).disposed(by: disposeBag)
        
    }
}
