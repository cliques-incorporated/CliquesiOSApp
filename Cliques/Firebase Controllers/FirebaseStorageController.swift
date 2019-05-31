//
//  FirebaseStorageController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Firebase

class FirebaseStorageController {
    static let ProfileImageDir = "profile_images"
    private let storage = Storage.storage()
    
    func uploadProfileImage(phoneNumber: String, profileImage: UIImage, uploadCompletionHandler: @escaping (URL?)->()) {
        guard let profileImageData = profileImage.pngData() else { return }
        let profileImageRef = getProfileImageRef(phoneNumber: phoneNumber)
        profileImageRef.putData(profileImageData, metadata: nil) { metadata, error in
            if let error = error {
                debugPrint(error)
            }
            
            profileImageRef.downloadURL { (url, error) in
                uploadCompletionHandler(url)
            }
        }
    }
    
    func getProfileImageRef(phoneNumber: String) -> StorageReference {
        let profileImagesBucketRef = storage.reference().child(FirebaseStorageController.ProfileImageDir)
        return profileImagesBucketRef.child(phoneNumber + ".png")
    }
    
    func getFeed() -> Void {
        print("Displaying pictures in a feed format")
        //this is my first swift funtion ever!
    }

}
