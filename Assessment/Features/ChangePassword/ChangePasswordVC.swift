//
//  ChangePasswordVC.swift
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

class ChangePasswordVC:UIViewController{
    
    @IBOutlet var currentPasswordTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!
    @IBOutlet var btnChange: UIButton!
    
    private var disposeBag = DisposeBag()
    
    private let vm = ChangePasswordVM()
    
    lazy var user: Results<User> = { RealmManager.shared.realm.objects(User.self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVM()
    }
    
    private func bindVM(){
        
        let input = ChangePasswordVM.Input()
        let output = vm.transform(input: input)
        
        output.changedPassword.subscribe(onNext: {
            //            self.view.makeToast("Password has been updated!", duration: 3.0, position: .bottom)
            let popup = ChangePasswordPopUp()
            popup.subtitleString.accept("Enter your email for the verification proccess, we will send 4 digits code to your email.")
            popup.titleString.accept("Enter 4 Digits Code")
            popup.showEmailView.accept(true)
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            self.present(popup, animated: true)
            
            popup.validationCompleted.subscribe(onNext: { _ in
                self.vm.initiateUpdate()
                popup.passwordUpdated.accept(true)
            }).disposed(by: self.disposeBag)
            
            
        }).disposed(by: disposeBag)
        
        currentPasswordTF.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(currentPasswordTF.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                self.vm.currentPassword.accept(text)
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
        
        self.vm.currentPasswordValidation.bind{ [weak self] (value) in
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
        
        self.vm.confirmPasswordValidation.bind{ [weak self] (value) in
            guard let `self` = self else { return }
            if(value.status == .Error){
                self.view.makeToast(value.message, duration: 3.0, position: .bottom)
            }
        }.disposed(by: disposeBag)
        
        _ = self.vm.isValid.asObservable().subscribe(onNext: { [weak self] status in
            guard let `self` = self else { return }
            self.btnChange.isEnabled = status
            self.btnChange.isUserInteractionEnabled = status
        }).disposed(by: disposeBag)
        
        self.btnChange.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            self.vm.changedPressed()
        }).disposed(by: disposeBag)
        
    }
}
