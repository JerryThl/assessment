//
//  SignUpVM.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 22/12/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn

class ChangePasswordVM:BaseViewModel, ViewModelType{
    
    var isValid: Observable<Bool>!
    
    var currentPassword = BehaviorRelay.init(value: "")
    var password = BehaviorRelay.init(value: "")
    var confirmPassword = BehaviorRelay.init(value: "")

    var passwordValidation = BehaviorRelay.init(value: ValidationModel())
    var currentPasswordValidation = BehaviorRelay.init(value: ValidationModel())
    var confirmPasswordValidation = BehaviorRelay.init(value: ValidationModel())

    var changedPressed: () -> Void = {  }
    var initiateUpdate: () -> Void = {  }

    struct Input {
    }
    
    struct Output {
        let changedPassword: PublishSubject<Void>
    }
    
    func transform(input: ChangePasswordVM.Input) -> ChangePasswordVM.Output {
        let changedPassword = PublishSubject<Void>()
                
        changedPressed = { [weak self] in
            guard let `self` = self else { return }
            if !self.validate(){
                return
            }
            
//            let user = RealmManager.shared.realm.objects(User.self).first
//            RealmManager.shared.update {
//                user?.password = self.password.value
//            }
            changedPassword.onNext(())
        }
        
        initiateUpdate = { [weak self] in
            guard let `self` = self else { return }
            let user = RealmManager.shared.realm.objects(User.self).first
            RealmManager.shared.update {
                user?.password = self.password.value
            }
        }
        
        self.isValid = Observable.combineLatest(currentPassword.asObservable(), password.asObservable(), confirmPassword.asObservable()){ (current_password, password, confirm_password) in
            
            let passwordValid = !current_password.isEmpty
            let pValid = !password.isEmpty
            let confirmPValid = !confirm_password.isEmpty
            
            return (passwordValid && pValid && confirmPValid)
        }
        
        
        return Output(changedPassword: changedPassword)
    }
}
extension ChangePasswordVM {
    
    func validate() -> Bool {
        currentPassword
            .map { $0.count > 0}
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                if(password.value.count < 6){
                    self.currentPasswordValidation.accept(ValidationModel(message: "Password not valid", status: .Error))
                }else{
                    self.currentPasswordValidation.accept(ValidationModel(message: "Password not valid", status: .Success))

                }
                
                if(RealmManager.shared.realm.objects(User.self).first!.password != self.currentPassword.value){
                    print(RealmManager.shared.realm.objects(User.self).first!.password)
                    print(self.currentPassword.value)
                    self.currentPasswordValidation.accept(ValidationModel(message: "Current password incorrect", status: .Error))
                }else{
                    self.currentPasswordValidation.accept(ValidationModel(message: "Password not valid", status: .Success))

                }
                
            }).disposed(by: DisposeBag())
        
        password
            .map { $0.count > 0}
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                if(password.value.count < 6){
                    self.passwordValidation.accept(ValidationModel(message: "Password not valid", status: .Error))
                }else{
                    self.passwordValidation.accept(ValidationModel(message: "Password not valid", status: .Success))
                }
                
            }).disposed(by: DisposeBag())
        
        confirmPassword
            .map { $0.count > 0 }
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                
                if(confirmPassword.value != password.value){
                    self.confirmPasswordValidation.accept(ValidationModel(message: "Password does not match", status: .Error))
                }else{
                    self.confirmPasswordValidation.accept(ValidationModel(message: "Password does not match", status: .Success))
                }
                
            }).disposed(by: DisposeBag())
        
        let result = [currentPasswordValidation.value, passwordValidation.value, passwordValidation.value].filter { $0.status == .Error }
        print(result)
        return result.count == 0
    }
    
}
