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

class SignUpVC:UIViewController{
        
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!
    @IBOutlet var btnSIgnUp: UIButton!
    @IBOutlet var btnGoogle: UIButton!
    @IBOutlet var btnApple: UIButton!
    @IBOutlet var lblLogIn: UILabel!
    
    private var disposeBag = DisposeBag()
    
    private let vm = SignUpVM()
    
    private var emailValidation = ValidationModel()
    private var confirmPasswordValidation = ValidationModel()

    lazy var user: Results<User> = { RealmManager.shared.realm.objects(User.self) }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVM()
    }
    
    private func bindVM(){
        
        let input = SignUpVM.Input()
        let output = vm.transform(input: input)
        
        output.navigateToHome.subscribe(onNext: { [weak self](_) in
            guard let `self` = self else { return }
//            GIDSignIn.sharedInstance.signOut()
//            RealmManager.shared.delete(RealmManager.shared.realm.objects(User.self).toArray())

            let _ = BaseNavigationController(rootViewController: HomeVC())
            
            appDelegate_const.window?.rootViewController = BaseTabBarController()
            appDelegate_const.window?.makeKeyAndVisible()
            
        }).disposed(by: disposeBag)
        
        nameTF.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(nameTF.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                self.vm.name.accept(text)
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
        
        confirmPasswordTF.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(confirmPasswordTF.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                self.vm.confirmPassword.accept(text)
        }).disposed(by: disposeBag)
        
        _ = self.vm.isValid.asObservable().subscribe(onNext: { [weak self] status in
            guard let `self` = self else { return }
            self.btnSIgnUp.isEnabled = status
            self.btnSIgnUp.isUserInteractionEnabled = status
        }).disposed(by: disposeBag)

        self.vm.emailValidation.bind{ [weak self] (value) in
            guard let `self` = self else { return }
            if(value.status == .Error){
                self.view.makeToast(value.message, duration: 3.0, position: .bottom)
            }
        }.disposed(by: disposeBag)
        
        self.vm.confirmPasswordValidation.bind{ [weak self] (value) in
            guard let `self` = self else { return }
            if(value.status == .Error){
                self.view.makeToast(value.message, duration: 3.0, position: .bottom)
            }
        }.disposed(by: disposeBag)
        
        self.btnSIgnUp.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            self.vm.signUpPressed()
        }).disposed(by: disposeBag)
        
        self.btnGoogle.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [self] _ in
            self.vm.googleSignUpPressed(self)

        }).disposed(by: disposeBag)
        
        self.btnApple.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [self] _ in
            self.vm.appleSignUpPressed(self)
        }).disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        lblLogIn.addGestureRecognizer(tapGesture)
        lblLogIn.isUserInteractionEnabled = true
        
        tapGesture.rx.event.bind(onNext: { tap in
            self.navigationController?.pushViewController(SignInVC(), animated: true)
            guard let navigationController = self.navigationController else { return }
            var navigationArray = navigationController.viewControllers
            navigationArray.remove(at: navigationArray.count - 2)
            self.navigationController?.viewControllers = navigationArray
        }).disposed(by: disposeBag)
        
    }
}
