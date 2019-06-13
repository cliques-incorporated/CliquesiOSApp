//
//  MockFirebaseStorageController.swift
//  CliquesTests
//
//  Created by Ethan Kusters on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import FirebaseUI

class MockFirebaseStorageController: FirebaseStorageControllerProtocol {
    static var MockInstance: MockFirebaseStorageController!
    static func GetInstance() -> FirebaseStorageControllerProtocol {
        return MockInstance
    }
    
    var mockProfileImageURL: URL? = nil
    func uploadProfileImage(userID: String, profileImage: UIImage, uploadCompletionHandler: @escaping (URL?) -> ()) {
        uploadCompletionHandler(mockProfileImageURL)
    }
    
    var mockProfileImageStorageRef = StorageReference()
    func getProfileImageRef(userID: String) -> StorageReference {
        return mockProfileImageStorageRef
    }
    
    var mockUploadPostImageResp = false
    func uploadPostImage(userID: String, postID: String, image: UIImage, uploadCompletionHandler: @escaping (Bool) -> ()) {
        uploadCompletionHandler(mockUploadPostImageResp)
    }
    
    var mockPostImageStorageRef = StorageReference()
    func getPostImageRef(postID: String) -> StorageReference {
        return mockPostImageStorageRef
    }
}
