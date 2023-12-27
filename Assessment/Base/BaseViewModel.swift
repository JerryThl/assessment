//
//  BaseViewModel.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 24/12/2023.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel: NSObject {
    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()
    let showLoading : BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let showHeaderLoading : BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let errorTracker = ErrorTracker()
    var page = BehaviorRelay<Int>.init(value: 0)
    let itemCount = BehaviorRelay<Int>.init(value: 0)
    
    func count(from: Int, to: Int, quickStart: Bool) -> Observable<Int> {
        return Observable<Int>
            .timer(quickStart ? .seconds(0) : .seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(from - to + 1)
            .map { from - $0 }
    }
    
    
    deinit {
        print(String(describing: type(of: self)) + "-deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
