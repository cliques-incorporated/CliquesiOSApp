//
//  FirebaseStorageController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Firebase

class FirebaseStorageControllerSingleton {
    private static var uniqueInstance: FirebaseStorageControllerSingleton?
    static let ProfileImageDir = "profile_images"
    static let PostImageDir = "post_images"
    let storage = Storage.storage()
    
    private init() {}
    public static func GetInstance() -> FirebaseStorageControllerSingleton {
        if let initializedUniqueInstance = uniqueInstance {
            return initializedUniqueInstance
        } else {
            uniqueInstance = FirebaseStorageControllerSingleton()
            return uniqueInstance!
        }
    }
    
    func uploadProfileImage(userID: String, profileImage: UIImage, uploadCompletionHandler: @escaping (URL?)->()) {
        guard let profileImageData = profileImage.pngData() else { return }
        let profileImageRef = getProfileImageRef(userID: userID)
        profileImageRef.putData(profileImageData, metadata: nil) { metadata, error in
            if let error = error {
                debugPrint(error)
            }
            
            profileImageRef.downloadURL { (url, error) in
                uploadCompletionHandler(url)
            }
        }
    }
    
    func getProfileImageRef(userID: String) -> StorageReference {
        let profileImagesBucketRef = storage.reference().child(FirebaseStorageControllerSingleton.ProfileImageDir)
        return profileImagesBucketRef.child(userID + ".png")
    }
    
    func uploadPostImage(userID: String, postID: String, image: UIImage, uploadCompletionHandler: @escaping(Bool)->()) {
        guard let imageData = image.pngData() else { return }
        let postImageRef = getPostImageRef(userID: userID, postID: postID)
        postImageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                debugPrint(error)
                uploadCompletionHandler(false)
            } else {
                uploadCompletionHandler(true)
            }
        }
    }
    
    func getPostImageRef(userID: String, postID: String) -> StorageReference {
        let postImagesBucket = storage.reference().child(FirebaseStorageControllerSingleton.PostImageDir)
        return postImagesBucket.child(postID + ".png");
        
    }
    
}
