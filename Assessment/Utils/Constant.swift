//
//  Constant.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 20/12/2023.
//

import Foundation
import UIKit
import RealmSwift

let appDelegate_const = UIApplication.shared.delegate as! AppDelegate
let rootView_const = appDelegate_const.window?.rootViewController?.view

struct Constant{
    static func isUserLoggedIn() -> Bool {
        //        if !getUsername().isEmpty && !getUserid().isEmpty {
        //            return true
        //        }
        
        if RealmManager.shared.getDataForObject(User.self).count > 0{
            return true
        }
        
        return false
    }
}

