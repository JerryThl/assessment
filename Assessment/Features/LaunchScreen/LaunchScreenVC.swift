//
//  LaunchScreenVC.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 20/12/2023.
//

import Foundation
import UIKit
import RxSwift

class LaunchScreenVC:UIViewController{
    
    let disposeBag = DisposeBag()
    
    let countdown = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(countdown + 1)
            .subscribe(onNext: {_ in
            }, onCompleted: {
                appDelegate_const.initRootVC()
            }).disposed(by: disposeBag)
    }
}
