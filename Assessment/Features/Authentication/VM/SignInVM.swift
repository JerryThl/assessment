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

class SignInVM:BaseViewModel, ViewModelType{
    
    var isValid: Observable<Bool>!
    var email = BehaviorRelay.init(value: "")
    var password = BehaviorRelay.init(value: "")

    var emailValidation = BehaviorRelay.init(value: ValidationModel())
    var passwordValidation = BehaviorRelay.init(value: ValidationModel())

    var signInPressed: () -> Void = {  }
    var googleSignInPressed: (SignInVC) -> Void = {vc in}
    var appleSignInPressed: (SignInVC) -> Void = {vc in}

    struct Input {
    }
    
    struct Output {
        let navigateToHome: PublishSubject<Void>
    }
    
    func transform(input: SignInVM.Input) -> SignInVM.Output {
        let navigateToHome = PublishSubject<Void>()
                
        signInPressed = { [weak self] in
            guard let `self` = self else { return }
            if !self.validate(){
                return
            }
            
            let userObj = User()
            userObj.userid = User().incrementID()
            userObj.email = email.value
            userObj.password = password.value
            userObj.loginType = AppLoginType.Normal.rawValue
            
            RealmManager.shared.add([userObj])
            
            navigateToHome.onNext(())
        }
        
        googleSignInPressed = { vc in
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
        
        appleSignInPressed = { vc in
            vc.view.makeToast("Sign In With Apple Not Available on free account", duration: 3.0, position: .bottom)
        }
        
        self.isValid = Observable.combineLatest(email.asObservable(), password.asObservable()){ (email, password) in
            
            let emailValid = !email.isEmpty
            let pValid = !password.isEmpty
            
            return (emailValid && pValid)
        }
        
        
        return Output(navigateToHome: navigateToHome)
    }
}
extension SignInVM {
    
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
        
        password
            .map { $0.count > 0 && $0.count >= 6}
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                if(password.value.count < 6){
                    self.passwordValidation.accept(ValidationModel(message: "Password not valid", status: .Error))
                }else{
                    self.passwordValidation.accept(ValidationModel(message: "Password not valid", status: .Success))
                }
                
            }).disposed(by: DisposeBag())
        
        let result = [emailValidation.value, passwordValidation.value].filter { $0.status == .Error }
        return result.count == 0
    }
    
}
