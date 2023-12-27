//
//  HomeCellMenuPopUp.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 26/12/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeCellMenuPopUp:UIViewController{
    
    @IBOutlet var lblWebName: UILabel!
    @IBOutlet var btnUsername: UIButton!
    @IBOutlet var btnPassword: UIButton!
    
    private var disposeBag = DisposeBag()
    
    var webname = BehaviorRelay.init(value: "")
    var username = ""
    var password = ""

    override func viewDidLoad() {
        
        self.webname.bind(onNext: { [self] value in
            lblWebName.text = value
        }).disposed(by: disposeBag)
        
        self.btnUsername.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            print(username)
            UIPasteboard.general.string = self.username
        }).disposed(by: disposeBag)
        
        self.btnPassword.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            print(password)
            UIPasteboard.general.string = self.password
        }).disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)

        self.view.isUserInteractionEnabled = true
        
        tapGesture.rx.event.bind(onNext: { tap in
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
    }
}
