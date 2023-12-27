//
//  AuthPage.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 21/12/2023.
//

import Foundation
import UIKit
import RxSwift

class AuthPage:UIViewController{
    
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var btnSignIn: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindVM()
    }
    
    private func bindVM(){
        self.btnSignUp.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.navigationController?.pushViewController(SignUpVC(), animated: true)
        }).disposed(by: disposeBag)
        
        self.btnSignIn.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.navigationController?.pushViewController(SignInVC(), animated: true)
        }).disposed(by: disposeBag)

    }
}
