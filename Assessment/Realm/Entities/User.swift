//
//  User.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 25/12/2023.
//

import Foundation
import UIKit
import RxRealm
import Realm
import RealmSwift

enum AppLoginType:String{
    case Apple = "Apple"
    case Google = "Google"
    case Normal = "Normal"
}


class User: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var accessToken: String = ""
    @objc dynamic var loginType:AppLoginType.RawValue = ""
    @objc dynamic var userid: Int = 0 //primary key

    override static func primaryKey() -> String? {
        return "userid"
    }
    
    func incrementID() -> Int {
        return (RealmManager.shared.realm.objects(User.self).max(ofProperty: "userid") as Int? ?? 0) + 1
    }
    
}
