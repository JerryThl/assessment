//
//  ValidationModel.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 24/12/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationStatus {
    case None
    case Error
    case Success
}

struct ValidationModel {
    var message: String = ""
    var status: ValidationStatus = .None
}
