//
//  UIViewController+Extensions.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 26/12/2023.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController{
    func presentAlert(title: String?, message: String?, confirmBtn:String? = "Ok", cancelBtn:String? = "Cancel") -> Observable<Void> {
        let result = PublishSubject<Void>()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: confirmBtn, style: .default, handler: { _ in
            result.onNext(())
            result.onCompleted()
        })
        ok.setValue(UIColor.customGreen, forKey: "titleTextColor")
        
        let cancel = UIAlertAction(title:cancelBtn , style: .cancel) { _ in
            result.onCompleted()
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
        return result
    }
}
