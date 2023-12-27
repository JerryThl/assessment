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

class HomeVM:BaseViewModel, ViewModelType{
    
    var listItems: BehaviorRelay<[AccountItems]> = .init(value: [])
    var getItemsListTrigger: () -> Void = {  }

    struct Input {
    }
    
    struct Output {
        let listItems: BehaviorRelay<[AccountItems]>
    }
    
    func transform(input: HomeVM.Input) -> HomeVM.Output {

        getItemsListTrigger = { [weak self] in
            guard let `self` = self else { return }
            self.listItems.accept(RealmManager.shared.realm.objects(AccountItems.self).toArray())
        }
        return Output(listItems: listItems)
    }
}

