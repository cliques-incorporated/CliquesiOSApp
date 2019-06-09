//
//  FeedModel.swift
//  Cliques
//
//  Created by Ethan Kusters on 6/7/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import Firebase

struct FeedItem {
    let post: Post
    let postImage: StorageReference
    let profileImage: StorageReference
}

class FeedModel {
    private let clique: CliqueUtility.CliqueTitles
    private let user: UserModelSingleton
    private let firestoreController: FirestoreControllerSingleton
    private let completionHandler: (_ success: Bool) -> ()
    private var feed = [FeedItem]()
    
    init(clique: CliqueUtility.CliqueTitles, updateCompletionHandler: @escaping (_ success: Bool) -> ()) {
        self.clique = clique
        user = UserModelSingleton.GetInstance()
        firestoreController = FirestoreControllerSingleton.GetInstance()
        self.completionHandler = updateCompletionHandler
    }
    
    public func update() {
        var usersInFeed: [String]
        switch clique {
        case .CloseFriends:
            usersInFeed = user.getCloseFriendsClique()
        case .Public:
            usersInFeed = user.getPublicClique()
        case .Family:
            usersInFeed = user.getFamilyClique()
        case .Friends:
            usersInFeed = user.getFriendsClique()
        }
        
        firestoreController.getUserFeed(userID: user.getPhoneNumber(), usersInFeed: usersInFeed, clique: clique, completion: updateComplete)
    }
    
    private func updateComplete(feed: [FeedItem]?) {
        guard let feed = feed else {
            completionHandler(false)
            return
        }
        
        self.feed = feed
        completionHandler(true)
    }
    
    public func getFeed() -> [FeedItem] {
        return feed
    }
    
}
