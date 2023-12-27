//
//  RealmManager.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 25/12/2023.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import Realm

class RealmManager: NSObject {
    
    static let shared = RealmManager()
    private var configuration: Realm.Configuration? = nil
    private let schemaVersion = 5

    var realm: Realm {
        return try! Realm(configuration: self.configuration!)
    }
    
    override init() {
        super.init()
        checkSchema()
    }
    
    func checkSchema() {
        self.configuration = Realm.Configuration(schemaVersion: UInt64(schemaVersion))
    }
    
    func add(_ objects : [Object]) {
        try? realm.safeWrite {
            realm.add(objects, update: .modified)
        }
    }
    
    func update(_ block: @escaping ()->Void) {
        try? realm.safeWrite(block)
    }
    
    func delete(_ objects : [Object]) {
        try? realm.safeWrite {
            realm.delete(objects)
        }
    }
    
    func getDataForObject(_ T : Object.Type) -> [Object] {
        
        var objects = [Object]()
        for result in realm.objects(T) {
            objects.append(result)
        }
        return objects
    }
    
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
