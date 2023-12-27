//
//  SignUpVC.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 21/12/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Toast
import RealmSwift
import GoogleSignIn

class SignInVC:UIViewController{
        
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnGoogle: UIButton!
    @IBOutlet var btnApple: UIButton!
    @IBOutlet var lblSignUp: UILabel!
    
    private var disposeBag = DisposeBag()
    
    private let vm = SignInVM()
    
    private var emailValidation = ValidationModel()
    private var confirmPasswordValidation = ValidationModel()

    lazy var user: Results<User> = { RealmManager.shared.realm.objects(User.self) }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindVM()
    }
    
    private func bindVM(){
        
        let input = SignInVM.Input()
        let output = vm.transform(input: input)
        
        output.navigateToHome.subscribe(onNext: { [weak self](_) in
            guard let `self` = self else { return }
//            GIDSignIn.sharedInstance.signOut()
//            RealmManager.shared.delete(RealmManager.shared.realm.objects(User.self).toArray())
            
            let _ = BaseNavigationController(rootViewController: HomeVC())
            
            appDelegate_const.window?.rootViewController = BaseTabBarController()
            appDelegate_const.window?.makeKeyAndVisible()
            

        }).disposed(by: disposeBag)
        
        emailTF.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(emailTF.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                self.vm.email.accept(text)
        }).disposed(by: disposeBag)
        
        passwordTF.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(passwordTF.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                self.vm.password.accept(text)
        }).disposed(by: disposeBag)
        
        _ = self.vm.isValid.asObservable().subscribe(onNext: { [weak self] status in
            guard let `self` = self else { return }
            self.btnSignIn.isEnabled = status
            self.btnSignIn.isUserInteractionEnabled = status
        }).disposed(by: disposeBag)

        self.vm.emailValidation.bind{ [weak self] (value) in
            guard let `self` = self else { return }
            if(value.status == .Error){
                self.view.makeToast(value.message, duration: 3.0, position: .bottom)
            }
        }.disposed(by: disposeBag)
        
        self.vm.passwordValidation.bind{ [weak self] (value) in
            guard let `self` = self else { return }
            if(value.status == .Error){
                self.view.makeToast(value.message, duration: 3.0, position: .bottom)
            }
        }.disposed(by: disposeBag)
        
        self.btnSignIn.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            self.vm.signInPressed()
        }).disposed(by: disposeBag)
        
        self.btnGoogle.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [self] _ in
            self.vm.googleSignInPressed(self)

        }).disposed(by: disposeBag)
        
        self.btnApple.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [self] _ in
            self.vm.appleSignInPressed(self)
        }).disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        lblSignUp.addGestureRecognizer(tapGesture)
        lblSignUp.isUserInteractionEnabled = true
        
        tapGesture.rx.event.bind(onNext: { tap in
            self.navigationController?.pushViewController(SignUpVC(), animated: true)
            guard let navigationController = self.navigationController else { return }
            var navigationArray = navigationController.viewControllers
            navigationArray.remove(at: navigationArray.count - 2)
            self.navigationController?.viewControllers = navigationArray
        }).disposed(by: disposeBag)
        
    }
}
