//
//  ChangePasswordPopUp.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 26/12/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Toast
import KAPinField

class ChangePasswordPopUp:UIViewController{
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var showEmail: UIView!
    @IBOutlet var showPin: UIView!
    @IBOutlet var btnChange: UIButton!
    @IBOutlet var emailTF: UITextField!
    
    @IBOutlet var statusView: UIView!
    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var lblStatusTitle: UILabel!
    @IBOutlet var lblStatusSubtitle: UILabel!
    
    @IBOutlet var pinTF: KAPinField!{
        didSet{
            
            pinTF.updateProperties { properties in
                properties.delegate = self
                properties.animateFocus = true // Animate the currently focused token
                properties.isSecure = false // Secure pinField will hide actual input
                properties.isUppercased = false // You can set this to convert input to uppercased.
            }
            
            pinTF.updateAppearence { appearance in
                
                appearance.textColor = UIColor.customDarkGreen // Default to nib color or black if initialized programmatically.
                appearance.tokenColor = UIColor.systemGray5 // token color, default to text color
                appearance.tokenFocusColor = UIColor.customDarkGreen  // token focus color, default to token color
                appearance.backOffset = 8 // Backviews spacing between each other
                appearance.backColor = UIColor.white
                appearance.backBorderWidth = 1
                appearance.backBorderColor = UIColor.systemGray5
                appearance.backCornerRadius = 4
                appearance.backFocusColor = UIColor.white
                appearance.backBorderFocusColor = UIColor.white.withAlphaComponent(0.8)
                appearance.backActiveColor = UIColor.clear
                appearance.backBorderActiveColor = UIColor.white
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    
    var titleString = BehaviorRelay.init(value: "")
    var subtitleString = BehaviorRelay.init(value: "")
    
    var showEmailView = BehaviorRelay.init(value: false)
    var showPinView = BehaviorRelay.init(value: false)
    var passwordUpdated = BehaviorRelay.init(value: false)
    
    var validationCompleted = PublishSubject<Void>()
    
    
    override func viewDidLoad() {
        
        
        self.passwordUpdated
            .skip(1)
            .bind(onNext: { [self] value in
                
                self.showEmail.isHidden = true
                self.showPin.isHidden = true
                self.statusView.isHidden = false
                self.btnChange.isHidden = true
                
                self.lblTitle.isHidden = true
                self.lblSubtitle.isHidden = true
                
                if(value){
                    self.lblStatusTitle.text = "Successfully Change Password"
                    self.lblStatusSubtitle.text = "Kindly login with your new password."
                    self.statusImage.image = UIImage(named: "success_icon")
                }else{
                    self.lblStatusTitle.text = "Unsuccessfully Change Password"
                    self.lblStatusSubtitle.text = "Kindly login with your new password."
                    self.statusImage.image = UIImage(named: "failed_icon")
                }
                
            }).disposed(by: disposeBag)
        
        
        self.titleString.bind(onNext: { [self] value in
            self.lblTitle.text = value
        }).disposed(by: disposeBag)
        
        self.subtitleString.bind(onNext: { [self] value in
            self.lblSubtitle.text = value
        }).disposed(by: disposeBag)
        
        self.showEmailView.bind(onNext: { [self] value in
            showEmail.isHidden = !value
            showPin.isHidden = value
            statusView.isHidden = true
            btnChange.setTitle("Send", for: .normal)
        }).disposed(by: disposeBag)
        
        self.showPinView.bind(onNext: { [self] value in
            showEmail.isHidden = value
            showPin.isHidden = !value
            statusView.isHidden = true
            btnChange.setTitle("Continue", for: .normal)
        }).disposed(by: disposeBag)
        
        self.btnChange.rx.tap.throttle(RxTimeInterval.milliseconds(Int(0.3)), scheduler: MainScheduler.instance).bind(onNext: { [weak self] _ in
            guard let `self` = self else {return}
            if(showPin.isHidden){
                
                if((emailTF.text ?? "").isValidEmail()){
                    self.showPinView.accept(true)
                }else{
                    self.view.makeToast("Invalid email", duration: 3.0, position: .bottom)
                }
                
            }else{
                
            }
        }).disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        
        self.view.isUserInteractionEnabled = true
        
        tapGesture.rx.event.bind(onNext: { tap in
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
    }
}
extension ChangePasswordPopUp:KAPinFieldDelegate{
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        validationCompleted.onNext(())
    }
}
