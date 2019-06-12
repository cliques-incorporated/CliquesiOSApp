//
//  MockFirestoreController.swift
//  CliquesTests
//
//  Created by Ethan Kusters on 6/12/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation

class MockFirestoreController: FirestoreControllerProtocol {
    static var MockInstance = MockFirestoreController()
    static func GetInstance() -> FirestoreControllerProtocol {
        return MockInstance
    }
    
    var userDataResponse = false
    func addUserData(profile: UserProfile, completionHandler: @escaping (Bool) -> ()) {
        completionHandler(userDataResponse)
    }
    
    var doesUserProfileExistResponse = false
    func doesUserProfileExist(uniqueID: String, completionHandler: @escaping (Bool?) -> ()) {
        completionHandler(doesUserProfileExistResponse)
    }
    
    var mockUserProfile = UserProfile.init()
    func getUserProfileData(uniqueID: String, completionHandler: @escaping (UserProfile?) -> ()) {
        completionHandler(mockUserProfile)
    }
    
    var mockPostUniqueID = "12345"
    func uploadPost(authorID: String, post: Post, completionHandler: @escaping (String?) -> ()) {
        completionHandler(mockPostUniqueID)
    }
    
    var mockUserPosts:[UserPostItem]? = nil
    func getUserPosts(userID: String, completion: @escaping ([UserPostItem]?) -> ()) {
        completion(mockUserPosts)
    }
    
    var mockUserFeed:[FeedItem]? = nil
    func getUserFeed(userID: String, completion: @escaping ([FeedItem]?) -> ()) {
        completion(mockUserFeed)
    }
    
    var mockConnections:[Connection]?
    func getConnections(completion: @escaping ([Connection]?) -> ()) {
        completion(mockConnections)
    }
}
