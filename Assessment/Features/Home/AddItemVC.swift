//
//  AddItemVC.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 26/12/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Toast
import RealmSwift

class AddItemVC:UIViewController{
    @IBOutlet var typeTF: UITextField!{
        didSet{
            typeTF.text = "Login"
            typeTF.isUserInteractionEnabled = false
        }
    }
    @IBOutlet var webnameTF: UITextField!
    @IBOutlet var urlsTF: UITextField!
    @IBOutlet var usernameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnCopyPassword: UIButton!
    
    private var disposeBag = DisposeBag()
    private let vm = AddItemVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVM()
    }
    
    private func bindVM(){
        
        let input = AddItemVM.Input()
        let output = self.vm.transform(input: input)
                        
        output.addItemTrigger.subscribe(onNext: { [weak self](_) in
            guard let `self` = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        self.vm.type.accept(typeTF.text ?? "Login")
        
        webnameTF.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(webnameTF.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                self.vm.webName.accept(text)
        }).disposed(by: disposeBag)
        
        urlsTF.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(urlsTF.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                self.vm.urls.accept(text)
        }).disposed(by: disposeBag)
        
        usernameTF.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(usernameTF.rx.text.orEmpty)
            .subscribe(onNext: { (text) in
                self.vm.username.accept(text)
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
            self.btnSave.isEnabled = status
            self.btnSave.isUserInteractionEnabled = status
        }).disposed(by: disposeBag)

        self.vm.webnameValidation.bind{ [weak self] (value) in
            guard let `self` = self else { return }
            if(value.status == .Error){
                self.view.makeToast(value.message, duration: 3.0, position: .bottom)
            }
        }.disposed(by: disposeBag)
        
        self.vm.urlsValidation.bind{ [weak self] (value) in
            guard let `self` = self else { return }
            if(value.status == .Error){
                self.view.makeToast(value.message, duration: 3.0, position: .bottom)
            }
        }.disposed(by: disposeBag)
        
        self.vm.usernameValidation.bind{ [weak self] (value) in
            guard let `self` = self else { return }
            if(value.status == .Error){
                self.view.makeToast(value.message, duration: 3.0, position: .bottom)
            }
        }.disposed(by: disposeBag)
        
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
        
        self.btnCopyPassword.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            UIPasteboard.general.string = passwordTF.text.value ?? ""
            self.view.makeToast("Copied to clipboard", duration: 3.0, position: .bottom)
        }).disposed(by: disposeBag)
        
        self.btnSave.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            self.vm.saveItemPressed()
        }).disposed(by: disposeBag)
        
        self.btnCancel.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
    }
    
}
