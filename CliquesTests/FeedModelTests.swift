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

    }
    func testUpdateFalse(){
        let mockFirestore = MockFirestoreController()
        mockFirestore.mockUserFeed = nil
        let fms = FeedModelSingleton.GetInstance(firestoreController: MockFirestoreController.GetInstance())
        fms.update() { success in
            XCTAssertFalse(success)
        }
        
    
    }
    func testUpdateTrue(){
        let mockFirestore = MockFirestoreController()
        
        let firstItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        let fms = FeedModelSingleton.GetInstance(firestoreController: MockFirestoreController.GetInstance())
        fms.update() { success in
            XCTAssertTrue(success)
        }
        
        
    }
    // Tests the public clique
    func testPublicClique() {
        let mockFirestore = MockFirestoreController()
        let firstItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let thirdItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fourthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fifthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let sixthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        
        MockFirestoreController.MockInstance = mockFirestore
        
        let fms = FeedModelSingleton.GetInstance(firestoreController: MockFirestoreController.GetInstance())
        let fms2 = FeedModelSingleton.GetInstance(firestoreController: MockFirestoreController.GetInstance())
        
        // Public tests
        XCTAssertEqual(fms.getFeed(clique: .Public).count, fms2.getFeed(clique: .Public).count)
       
     
        mockFirestore.mockUserFeed = []
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 0)
        mockFirestore.mockUserFeed = [fifthItem]
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 1)
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 2)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem]
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 4)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem]
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 5)
        mockFirestore.mockUserFeed = [firstItem, secondItem, thirdItem, fourthItem, fifthItem, sixthItem]
        XCTAssertEqual(fms.getFeed(clique: .Public).count, 6)
        
        
        
    }
    //Tests the friends clique
    func testFriendsClique() {
        let mockFirestore = MockFirestoreController()
        let firstItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let thirdItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fourthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fifthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let sixthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        
        MockFirestoreController.MockInstance = mockFirestore
        
        let fms = FeedModelSingleton.GetInstance(firestoreController: MockFirestoreController.GetInstance())
        
        //Close friends tests
        mockFirestore.mockUserFeed = []
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 0)
        mockFirestore.mockUserFeed = [firstItem]
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 1)
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 2)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem]
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 3)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem, fifthItem]
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 4)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem, secondItem, fifthItem]
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 5)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem, secondItem, fifthItem, sixthItem]
        XCTAssertEqual(fms.getFeed(clique: .Friends).count, 6)
    }
    //Tests the close friends clique
    func testCloseFriendsClique() {
        let mockFirestore = MockFirestoreController()
        let firstItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let thirdItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fourthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fifthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let sixthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        
        MockFirestoreController.MockInstance = mockFirestore
        
        let fms = FeedModelSingleton.GetInstance(firestoreController: MockFirestoreController.GetInstance())
        
        //Close friends tests
        mockFirestore.mockUserFeed = []
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 0)
        mockFirestore.mockUserFeed = [firstItem]
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 1)
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 2)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem]
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 3)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem, fifthItem]
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 4)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem, secondItem, fifthItem]
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 5)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem, secondItem, fifthItem, sixthItem]
        XCTAssertEqual(fms.getFeed(clique: .CloseFriends).count, 6)
    }
    //Tests the Family Clique
    func testFamilyClique() {
        let mockFirestore = MockFirestoreController()
        let firstItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 0, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let secondItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let thirdItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fourthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let fifthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        let sixthItem = FeedItem.init(post: Post(authorID: "", authorName: "", timestamp: 1, caption: "", publicClique: true, friendsClique: true, closeFriendsClique: true, familyClique: true, sharedWith: [""]), postImage: StorageReference(), profileImage: StorageReference())
        
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        
        MockFirestoreController.MockInstance = mockFirestore
        
        let fms = FeedModelSingleton.GetInstance(firestoreController: MockFirestoreController.GetInstance())
        
        //Close friends tests
        mockFirestore.mockUserFeed = []
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 0)
        mockFirestore.mockUserFeed = [firstItem]
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 1)
        mockFirestore.mockUserFeed = [firstItem, secondItem]
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 2)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem]
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 3)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem, fifthItem]
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 4)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem, secondItem, fifthItem]
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 5)
        mockFirestore.mockUserFeed = [firstItem, thirdItem, fourthItem, secondItem, fifthItem, sixthItem]
        XCTAssertEqual(fms.getFeed(clique: .Family).count, 6)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

