//
//  PostModelTests.swift
//  CliquesTests
//
//  Created by Ethan Kusters on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import XCTest

class PostModelTests: XCTestCase {

    func testPost_1(){
        let mockFirestore = MockFirestoreController()
        let mockFirebaseStorage = MockFirebaseStorageController()
        let image = UIImage()
        mockFirebaseStorage.mockUploadPostImageResp = true
        
        let PM = PostModel.init(image: image, caption: "", publicClique: false, friendsClique: false, closeFriendsClique: false, familyClique: false, firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorage)
        
        PM.upload(){
            success in
            XCTAssertTrue(success)
        }
    }
    
    func testPost_2(){
        let mockFirestore = MockFirestoreController()
        let mockFirebaseStorage = MockFirebaseStorageController()
        let image = UIImage()
        mockFirebaseStorage.mockUploadPostImageResp = false
        let PM_one = PostModel.init(image: image, caption: "", publicClique: false, friendsClique: false, closeFriendsClique: false, familyClique: false, firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorage)
        
        PM_one.upload(){
            success in
            XCTAssertFalse(success)
        }
    }

}
