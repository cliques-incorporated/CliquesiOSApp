//
//  FirebaseProtocol.swift
//  Cliques
//
//  Created by Ethan Kusters on 6/12/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreControllerProtocol {
    func addUserData(profile: UserProfile, completionHandler: @escaping (_ success: Bool)->())
    func doesUserProfileExist(uniqueID: String, completionHandler: @escaping (Bool?) -> ())
    func getUserProfileData(uniqueID: String, completionHandler: @escaping (UserProfile?) -> ())
    func uploadPost(authorID: String, post: Post, completionHandler: @escaping (String?) -> ())
    func getUserPosts(userID: String, completion: @escaping ([UserPostItem]?) -> ())
    func getUserFeed(userID: String, completion: @escaping ([FeedItem]?) -> ())
    func getConnections(completion: @escaping ([Connection]?)-> ())
}
