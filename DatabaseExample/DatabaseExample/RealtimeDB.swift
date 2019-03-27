//
//  RealtimeDB.swift
//  DatabaseExample
//
//  Created by Kevin Kruusi on 2019-02-28.
//  Copyright © 2019 com.kevin.MetalWarriorsTribute. All rights reserved.
//

import Foundation
import FirebaseDatabase

class RealtimeDB {

    var rootReference: DatabaseReference
    var actionsReference: DatabaseReference
    
    init() {
        rootReference = Database.database().reference()
        actionsReference = rootReference.child("Actions")
        print(rootReference)
        print(actionsReference)
    }
    
    func getActions(complete: @escaping ([String: Any]) -> Void) {
        let value = actionsReference.observe(.value) { (snapshot) in
            guard let userDict = snapshot.value as? [String: Any] else {
                print("Failed to find any actions.")
                return
            }
            complete(userDict)
        }
        print(value)
    }
    
    func add(action: Action) {

        let actionRef = actionsReference.child(action.name)
        actionRef.setValue(action.toAnyObject())
    }
}
