//
//  FirebaseManager.swift
//  FoodBook
//
//  Created by Thinh, Nguyen Truong on 15/09/2022.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    var currentUser: ChatUser?
    
    override init() {
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
