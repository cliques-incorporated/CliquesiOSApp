//
//  UserModelFeedModelIntegrationTests.swift
//  CliquesTests
//
//  Created by Ethan Kusters on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import XCTest
import FirebaseUI

class UserModelFeedModelIntegrationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserModelSingleton.GetInstance().tearDown()
        FeedModelSingleton.GetInstance().tearDown()
    }

    func testGetFeedIntegrated() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let mockFirestore = MockFirestoreController()
        let mockFirebaseStorage = MockFirebaseStorageController()
        let mockLoginController = MockFirebaseLoginController()
        
        MockFirebaseLoginController.uniqueID = "0"
        mockFirestore.mockUserProfile.uniqueID = MockFirebaseLoginController.uniqueID
        mockFirestore.mockUserProfile.familyClique = ["1", "2", "3"]
        mockFirestore.mockUserProfile.friendsClique = ["4", "5"]
        
        let userModel = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorage, firebaseLoginController: mockLoginController)
        
        let feedModel = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: userModel)
        
        

        
        let firstPost = Post.init(authorID: "1", authorName: "TestAuthor1", timestamp: 0, caption: "TestCaption1", publicClique: false, friendsClique: false, closeFriendsClique: false, familyClique: false, sharedWith: ["0"])
        
        let secondPost = Post.init(authorID: "2", authorName: "TestAuthor2", timestamp: 1, caption: "TestCaption2", publicClique: false, friendsClique: false, closeFriendsClique: false, familyClique: false, sharedWith: ["0"])
        
        let thirdPost = Post.init(authorID: "3", authorName: "TestAuthor3", timestamp: 2, caption: "TestCaption3", publicClique: false, friendsClique: false, closeFriendsClique: false, familyClique: false, sharedWith: ["0"])
        
         let fourthPost = Post.init(authorID: "5", authorName: "TestAuthor3", timestamp: 2, caption: "TestCaption3", publicClique: false, friendsClique: false, closeFriendsClique: false, familyClique: false, sharedWith: ["0"])
        
        
        mockFirestore.mockUserFeed = [
            FeedItem(post: firstPost, postImage: StorageReference(), profileImage: StorageReference()),
            FeedItem(post: secondPost, postImage: StorageReference(), profileImage: StorageReference()),
            FeedItem(post: thirdPost, postImage: StorageReference(), profileImage: StorageReference()),
            FeedItem(post: fourthPost, postImage: StorageReference(), profileImage: StorageReference())
        ]
        
        
        
        feedModel.update { success in
            XCTAssertTrue(success)
        }
        
        let familyFeed = feedModel.getFeed(clique: .Family)
        
        XCTAssertEqual(familyFeed.count, 3)
        XCTAssertEqual(familyFeed[2].post.caption, "TestCaption1")
        XCTAssertEqual(familyFeed[0].post.authorName, "TestAuthor3")
    }
    
    func testGetFeedWhileLoggedOutIntegrated() {
        let mockFirestore = MockFirestoreController()
        let mockFirebaseStorage = MockFirebaseStorageController()
        let mockLoginController = MockFirebaseLoginController()
        
        MockFirebaseLoginController.uniqueID = "0"
        mockFirestore.mockUserProfile.uniqueID = MockFirebaseLoginController.uniqueID
        mockFirestore.mockUserProfile.familyClique = ["1", "2"]
        mockFirestore.mockUserProfile.friendsClique = ["3", "4"]
        
        let userModel = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorage, firebaseLoginController: mockLoginController)
        
        let feedModel = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: userModel)
        
        userModel.LogOut()
        
        feedModel.update { success in
            XCTAssertFalse(success)
        }
    }
    
    func testUserPostsAppearInFeedIntegrated() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let mockFirestore = MockFirestoreController()
        let mockFirebaseStorage = MockFirebaseStorageController()
        let mockLoginController = MockFirebaseLoginController()
        
        MockFirebaseLoginController.uniqueID = "0"
        mockFirestore.mockUserProfile.uniqueID = MockFirebaseLoginController.uniqueID
        mockFirestore.mockUserProfile.familyClique = ["1", "2", "3"]
        mockFirestore.mockUserProfile.friendsClique = ["4", "5"]
        
        let userModel = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorage, firebaseLoginController: mockLoginController)
        
        let feedModel = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: userModel)
        
        
        
        
        let firstPost = Post.init(authorID: "0", authorName: "User", timestamp: 0, caption: "TestCaption1", publicClique: true, friendsClique: true, closeFriendsClique: false, familyClique: false, sharedWith: [""])
        
        let secondPost = Post.init(authorID: "0", authorName: "User", timestamp: 1, caption: "TestCaption2", publicClique: true, friendsClique: true, closeFriendsClique: false, familyClique: false, sharedWith: [""])
        
        let thirdPost = Post.init(authorID: "0", authorName: "User", timestamp: 2, caption: "TestCaption3", publicClique: false, friendsClique: false, closeFriendsClique: true, familyClique: false, sharedWith: [""])
        
        let fourthPost = Post.init(authorID: "0", authorName: "User", timestamp: 3, caption: "TestCaption4", publicClique: false, friendsClique: false, closeFriendsClique: false, familyClique: true, sharedWith: [""])
        
        
        mockFirestore.mockUserFeed = [
            FeedItem(post: firstPost, postImage: StorageReference(), profileImage: StorageReference()),
            FeedItem(post: secondPost, postImage: StorageReference(), profileImage: StorageReference()),
            FeedItem(post: thirdPost, postImage: StorageReference(), profileImage: StorageReference()),
            FeedItem(post: fourthPost, postImage: StorageReference(), profileImage: StorageReference())
        ]
        
        
        
        feedModel.update { success in
            XCTAssertTrue(success)
        }
        
        let publicFeed = feedModel.getFeed(clique: .Public)
        
        XCTAssertEqual(publicFeed.count, 2)
        XCTAssertEqual(publicFeed[0].post.caption, "TestCaption2")
        XCTAssertEqual(publicFeed[1].post.caption, "TestCaption1")
        
        
        let closeFriendsFeed = feedModel.getFeed(clique: .CloseFriends)
        XCTAssertEqual(closeFriendsFeed.count, 1)
        XCTAssertEqual(closeFriendsFeed[0].post.caption, "TestCaption3")
    }
}
