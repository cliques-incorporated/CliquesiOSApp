//
//  FirestoreController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Firebase
import FirebaseFirestore

class FirestoreController {
    private let firestoreDatabase: Firestore
    private let FirestoreUsersCollection = "users"
    
    init() {
        firestoreDatabase = Firestore.firestore()
        let settings = firestoreDatabase.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firestoreDatabase.settings = settings
    }
    
    func addUserData(phoneNumber: String, firstName: String, lastName: String, bio: String, photoURL: URL, completionHandler: @escaping (Error?)->()) {
        firestoreDatabase.collection(FirestoreUsersCollection).document(phoneNumber).setData([
            "id": phoneNumber,
            "first": firstName,
            "last": lastName,
            "bio": bio,
            "profileImageURL": photoURL.absoluteString
        ]) { err in
            completionHandler(err)
        }
    }
    
    func doesUserProfileExist(phoneNumber: String, completionHandler: @escaping (Bool?) -> ()){
        firestoreDatabase.collection(FirestoreUsersCollection).document(phoneNumber).getDocument { (document, error) in
            completionHandler(document?.exists)
        }
    }
}
