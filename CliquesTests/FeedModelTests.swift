//
//  FileModelTests.swift
//  CliquesTests
//
//  Created by Jasmine on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import XCTest
import FirebaseUI

class FeedModelTests: XCTestCase {
    
    override func setUp() {
    
    }
    
    override func tearDown() {
        FeedModelSingleton.GetInstance().tearDown()
    }
    /*
    func testUpdateFalse(){
        let mockFirestore = MockFirestoreController()
        mockFirestore.mockUserFeed = nil
        let fms = FeedModelSingleton.GetInstance(firestoreController: MockFirestoreController.GetInstance(storageController: mockFirestore as! FirebaseStorageControllerProtocol))
        fms.update() { success in
            XCTAssertFalse(success)
        }
        
    
    }
 */
    /*

    func testUpdateTrue(){
        let mockFirestore = MockFirestoreController()
        
        let firstItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        let fms = FeedModelSingleton.GetInstance(firestoreController: MockFirestoreController.GetInstance(storageController: mockFirestore as! FirebaseStorageControllerProtocol))
        fms.update() { success in
            XCTAssertFalse(success)
        }
    }
 */
    // Tests the family clique
    func testFamilyClique() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        mockUserModel.mockFamilyClique = ["0", "1", "4"]
        mockUserModel.mockFriendsClique = ["3", "4"]
        
        let firstItem = FeedItem.init(post: Post(authorID: "0", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "1", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let thirdItem = FeedItem.init(post: Post(authorID: "3", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fourthItem = FeedItem.init(post: Post(authorID: "4", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fifthItem = FeedItem.init(post: Post(authorID: "5", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let sixthItem = FeedItem.init(post: Post(authorID: "6", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        
        let fms = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        let fms2 = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        
        // Public tests
        XCTAssertEqual(fms.getFeed(clique: .Family).count, fms2.getFeed(clique: .Family).count)
        
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 2)
        mockFirestore.mockUserFeed = [fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 0)
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 2)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 3)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 3)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem, sixthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 3)
        
        
        
    }
    // Tests the close friends clique
    func testCloseFriendsClique() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        mockUserModel.mockCloseFriendsClique = ["0", "1", "4"]
        mockUserModel.mockFamilyClique = ["3", "4"]
        
        let firstItem = FeedItem.init(post: Post(authorID: "0", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "1", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let thirdItem = FeedItem.init(post: Post(authorID: "3", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fourthItem = FeedItem.init(post: Post(authorID: "4", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fifthItem = FeedItem.init(post: Post(authorID: "5", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let sixthItem = FeedItem.init(post: Post(authorID: "6", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        
        
        let fms = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        let fms2 = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        
        // Public tests
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, fms2.getFeed(clique: .CloseFriends).count)
        
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 2)
        mockFirestore.mockUserFeed = [fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 0)
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 2)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 3)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 3)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem, sixthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 3)
        
        
        
    }
    // Tests the friends clique
    func testFriendsClique() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        mockUserModel.mockFriendsClique = ["0", "1", "4"]
        mockUserModel.mockFamilyClique = ["3", "4"]
        
        let firstItem = FeedItem.init(post: Post(authorID: "0", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "1", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let thirdItem = FeedItem.init(post: Post(authorID: "3", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fourthItem = FeedItem.init(post: Post(authorID: "4", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fifthItem = FeedItem.init(post: Post(authorID: "5", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let sixthItem = FeedItem.init(post: Post(authorID: "6", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        
        
        let fms = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        let fms2 = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        
        // Public tests
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, fms2.getFeed(clique: .Friends).count)
        
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 2)
        mockFirestore.mockUserFeed = [fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 0)
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 2)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 3)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 3)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem, sixthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 3)
        
        
        
    }
        
    // Tests the public clique
    func testPublicClique() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        mockUserModel.mockPublicClique = ["0", "1", "4"]
        mockUserModel.mockFamilyClique = ["3", "4"]
        
        let firstItem = FeedItem.init(post: Post(authorID: "0", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "1", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let thirdItem = FeedItem.init(post: Post(authorID: "3", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fourthItem = FeedItem.init(post: Post(authorID: "4", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fifthItem = FeedItem.init(post: Post(authorID: "5", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let sixthItem = FeedItem.init(post: Post(authorID: "6", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
    
        
        let fms = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        let fms2 = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        
        // Public tests
        XCTAssertEqual(fms.getFeed(clique: .Public).count, fms2.getFeed(clique: .Public).count)
       
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 2)
        mockFirestore.mockUserFeed = [fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 0)
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 2)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 3)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 3)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem, sixthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 3)
        
        
        
    }
    func testFamilyFullPublicEmpty(){
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        mockUserModel.mockPublicClique = []
        mockUserModel.mockFamilyClique = ["0", "1", "2", "3", "4", "5"]
        
        let firstItem = FeedItem.init(post: Post(authorID: "0", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "1", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let thirdItem = FeedItem.init(post: Post(authorID: "3", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fourthItem = FeedItem.init(post: Post(authorID: "4", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fifthItem = FeedItem.init(post: Post(authorID: "5", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let sixthItem = FeedItem.init(post: Post(authorID: "6", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        
        
        let fms = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        let fms2 = FeedModelSingleton.GetInstance(firestoreController: mockFirestore, userModel: mockUserModel)
        
        // FamilyFull PublicEmpty
        XCTAssertEqual(fms.getFeed(clique: .Public).count, fms2.getFeed(clique: .Public).count)
        
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 0)
        mockFirestore.mockUserFeed = [fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 1)
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 0)
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 2)
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 0)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 4)
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 0)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 5)
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 0)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem, sixthItem]
        fms.update() { success in
            XCTAssertTrue(success)
        }
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 5)
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 0)
        
        
        
    
    }
    
   
}

