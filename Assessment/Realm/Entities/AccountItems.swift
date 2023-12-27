//
//  AccountItems.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 26/12/2023.
//

import Foundation
import UIKit
import RxRealm
import Realm
import RealmSwift

class AccountItems: Object {
    @objc dynamic var type: String = ""
    @objc dynamic var webName: String = ""
    @objc dynamic var urls: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""

    @objc dynamic var itemId: Int = 0 //primary key

    override static func primaryKey() -> String? {
        return "itemId"
    }
    
    func incrementID() -> Int {
        return (RealmManager.shared.realm.objects(AccountItems.self).max(ofProperty: "itemId") as Int? ?? 0) + 1
    }
    
}
