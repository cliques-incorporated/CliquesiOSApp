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
    let firestoreDatabase: Firestore
    init() {
        firestoreDatabase = Firestore.firestore()
        let settings = firestoreDatabase.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firestoreDatabase.settings = settings
    }
    
    func AddUserData(phoneNumber: String, firstName: String, lastName: String, bio: String, photo: UIImage) {
        firestoreDatabase.collection("users").document(phoneNumber).setData([
            "id": phoneNumber,
            "first": firstName,
            "last": lastName,
            "bio": bio
        ])
    }
}
