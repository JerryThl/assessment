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

class SignUpVM:BaseViewModel, ViewModelType{
    
    var isValid: Observable<Bool>!
    var name = BehaviorRelay.init(value: "")
    var email = BehaviorRelay.init(value: "")
    var password = BehaviorRelay.init(value: "")
    var confirmPassword = BehaviorRelay.init(value: "")

    var emailValidation = BehaviorRelay.init(value: ValidationModel())
    var confirmPasswordValidation = BehaviorRelay.init(value: ValidationModel())
    
    var signUpPressed: () -> Void = {  }
    var googleSignUpPressed: (SignUpVC) -> Void = {vc in}
    var appleSignUpPressed: (SignUpVC) -> Void = {vc in}

    struct Input {
    }
    
    struct Output {
        let navigateToHome: PublishSubject<Void>
    }
    
    func transform(input: SignUpVM.Input) -> SignUpVM.Output {
        let navigateToHome = PublishSubject<Void>()
                
        signUpPressed = { [weak self] in
            guard let `self` = self else { return }
            if !self.validate(){
                return
            }
            
            let userObj = User()
            userObj.userid = User().incrementID()
            userObj.email = email.value
            userObj.name = name.value
            userObj.password = password.value
            userObj.loginType = AppLoginType.Normal.rawValue
            
            RealmManager.shared.add([userObj])
            
            navigateToHome.onNext(())
        }
        
        googleSignUpPressed = { vc in
            GIDSignIn.sharedInstance.signIn(withPresenting: vc) { signInResult, error in
                guard error == nil else { return }
                
                let userObj = User()
                userObj.userid = User().incrementID()
                userObj.accessToken = signInResult?.user.idToken?.tokenString ?? ""
                userObj.loginType = AppLoginType.Google.rawValue
                
                RealmManager.shared.add([userObj])
                navigateToHome.onNext(())
            }
        }
        
        appleSignUpPressed = { vc in
            vc.view.makeToast("Sign In With Apple Not Available on free account", duration: 3.0, position: .bottom)
        }
        
        self.isValid = Observable.combineLatest(name.asObservable(), email.asObservable(), password.asObservable(), confirmPassword.asObservable()){ (name, email, password, c_password) in
            
            let nameValid = !name.isEmpty
            let emailValid = !email.isEmpty
            let pValid = !password.isEmpty
            let c_pValid = !c_password.isEmpty
            
            return (nameValid && emailValid && pValid && c_pValid)
        }
        
        
        return Output(navigateToHome: navigateToHome)
    }
}
extension SignUpVM {
    
    func validate() -> Bool {
        email
            .map { $0.count > 0 }
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                
                if(!email.value.isValidEmail()){
                    self.emailValidation.accept(ValidationModel(message: "Invalid Email", status: .Error))
                }else{
                    self.emailValidation.accept(ValidationModel(message: "Invalid Email", status: .Success))
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
        
        let result = [emailValidation.value, confirmPasswordValidation.value].filter { $0.status == .Error }
        return result.count == 0
    }
    
}
