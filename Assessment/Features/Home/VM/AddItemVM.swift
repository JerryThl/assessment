//
//  AddItemVM.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 22/12/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn

class AddItemVM:BaseViewModel, ViewModelType{
    
    var type = BehaviorRelay.init(value: "")
    var webName = BehaviorRelay.init(value: "")
    var urls = BehaviorRelay.init(value: "")
    var username = BehaviorRelay.init(value: "")
    var email = BehaviorRelay.init(value: "")
    var password = BehaviorRelay.init(value: "")

    var isValid: Observable<Bool>!
    
    var webnameValidation = BehaviorRelay.init(value: ValidationModel())
    var urlsValidation = BehaviorRelay.init(value: ValidationModel())
    var usernameValidation = BehaviorRelay.init(value: ValidationModel())
    var emailValidation = BehaviorRelay.init(value: ValidationModel())
    var passwordValidation = BehaviorRelay.init(value: ValidationModel())
    
    var saveItemPressed: () -> Void = {  }

    struct Input {
    }
    
    struct Output {
        let addItemTrigger: PublishSubject<Void>
    }
    
    func transform(input: AddItemVM.Input) -> AddItemVM.Output {
        let addItemTrigger = PublishSubject<Void>()

        saveItemPressed = { [weak self] in
            guard let `self` = self else { return }
            
            if(!self.validate()){
                return
            }
            
            let item = AccountItems()
            item.itemId = AccountItems().incrementID()
            item.email = email.value
            item.password = password.value
            item.webName = webName.value
            item.urls = urls.value
            item.username = username.value
            item.type = "Login"
            
            RealmManager.shared.add([item])
            addItemTrigger.onNext(())

        }
        
        self.isValid = Observable.combineLatest(type.asObservable(), email.asObservable(), password.asObservable(), username.asObservable(), webName.asObservable(), urls.asObservable()){ (type, email, password, username, webName, urls) in
            
            let typeV = !type.isEmpty
            let emailV = !email.isEmpty
            let passwordV = !password.isEmpty
            let usernameV = !username.isEmpty
            let webnameV = !webName.isEmpty
            let urlsV = !urls.isEmpty

            return (typeV && emailV && passwordV && usernameV && webnameV && urlsV)
        }
        
        
        return Output(addItemTrigger:addItemTrigger)
    }
}

extension AddItemVM {
    
    func validate() -> Bool {
        
        webName
            .map { $0.count > 0 }
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                
                if(webName.value.count < 1){
                    self.webnameValidation.accept(ValidationModel(message: "Web Name cannot be empty", status: .Error))
                }else{
                    self.webnameValidation.accept(ValidationModel(message: "", status: .Success))
                }
                
            }).disposed(by: DisposeBag())
        
        urls
            .map { $0.count > 0 }
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                                
                if(urls.value.count < 1){
                    self.urlsValidation.accept(ValidationModel(message: "URLs cannot be empty", status: .Error))
                }else{
                    self.urlsValidation.accept(ValidationModel(message: "", status: .Success))
                }
                
            }).disposed(by: DisposeBag())
        
        username
            .map { $0.count > 0 }
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                
                if(username.value.count < 1){
                    self.usernameValidation.accept(ValidationModel(message: "Username cannot be empty", status: .Error))
                }else{
                    self.usernameValidation.accept(ValidationModel(message: "", status: .Success))
                }
                
                
            }).disposed(by: DisposeBag())
        
        
        email
            .map { $0.count > 0 }
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                
                if(!email.value.isValidEmail()){
                    self.emailValidation.accept(ValidationModel(message: "Invalid Email", status: .Error))
                }else{
                    self.emailValidation.accept(ValidationModel(message: "", status: .Success))
                }
                
            }).disposed(by: DisposeBag())
        
        password
            .map { $0.count > 0 && $0.count < 6}
            .share(replay: 1)
            .subscribe(onNext: { [weak self](status) in
                guard let `self` = self else { return }
                
                if(password.value.count > 0 && password.value.count < 6){
                    self.passwordValidation.accept(ValidationModel(message: "Password length should be more than 6 characters", status: .Error))
                }else{
                    self.passwordValidation.accept(ValidationModel(message: "", status: .Success))

                }
                
            }).disposed(by: DisposeBag())
        
        let result = [webnameValidation.value,urlsValidation.value,usernameValidation.value,emailValidation.value,passwordValidation.value].filter { $0.status == .Error }

        return result.count == 0
    }
    
}
