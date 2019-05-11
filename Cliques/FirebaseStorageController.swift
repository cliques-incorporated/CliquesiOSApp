//
//  FirebaseStorageController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Firebase

class FirebaseStorageController {
    private let storage = Storage.storage()
    
    func uploadProfileImage(phoneNumber: String, profileImage: UIImage, uploadCompletionHandler: @escaping (URL?)->()) {
        guard let profileImageData = profileImage.pngData() else { return }
        let profileImagesBucketRef = storage.reference().child("profile_images")
        let profileImageRef = profileImagesBucketRef.child(phoneNumber + ".png")
        
        profileImageRef.putData(profileImageData, metadata: nil) { metadata, error in
            if let error = error {
                debugPrint(error)
            }
            
            profileImageRef.downloadURL { (url, error) in
                uploadCompletionHandler(url)
            }
        }
    }

}
