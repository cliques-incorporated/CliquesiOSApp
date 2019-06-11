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

class FeedModelSingleton {
    private static var uniqueInstance: FeedModelSingleton?
    private let user: UserModelSingleton
    private let firestoreController: FirestoreControllerSingleton
    private var feed = [FeedItem]()
    
    private init() {
        user = UserModelSingleton.GetInstance()
        firestoreController = FirestoreControllerSingleton.GetInstance()
    }
    
    public static func GetInstance() -> FeedModelSingleton {
        if let initializedUniqueInstance = uniqueInstance {
            return initializedUniqueInstance
        } else {
            uniqueInstance = FeedModelSingleton()
            return uniqueInstance!
        }
    }
    
    public func update(completionHandler: @escaping (_ success: Bool) -> ()) {
        firestoreController.getUserFeed(userID: user.getPhoneNumber()) { feed in
            guard let feed = feed else {
                completionHandler(false)
                return
            }
            
            self.feed = feed
            completionHandler(true)
        }
    }
    
    
    public func getFeed(clique: CliqueUtility.CliqueTitles) -> [FeedItem] {
        switch clique {
        case .Public:
            var publicFeed = feed.filter{user.getPublicClique().contains($0.post.authorID)}
            publicFeed.append(contentsOf: feed.filter{$0.post.authorID == user.getPhoneNumber() && $0.post.publicClique})
            publicFeed.sort(by: {$0.post.timestamp > $1.post.timestamp})
            return publicFeed
        case .Friends:
            var friendsFeed = feed.filter{user.getFriendsClique().contains($0.post.authorID)}
            friendsFeed.append(contentsOf: feed.filter{$0.post.authorID == user.getPhoneNumber() && $0.post.friendsClique})
            friendsFeed.sort(by: {$0.post.timestamp > $1.post.timestamp})
            return friendsFeed
        case .CloseFriends:
            var closeFriendsFeed = feed.filter{user.getCloseFriendsClique().contains($0.post.authorID)}
            closeFriendsFeed.append(contentsOf: feed.filter{$0.post.authorID == user.getPhoneNumber() && $0.post.closeFriendsClique})
            closeFriendsFeed.sort(by: {$0.post.timestamp > $1.post.timestamp})
            return closeFriendsFeed
        case .Family:
            var familyFeed = feed.filter{user.getFamilyClique().contains($0.post.authorID)}
            familyFeed.append(contentsOf: feed.filter{$0.post.authorID == user.getPhoneNumber() && $0.post.familyClique})
            familyFeed.sort(by: {$0.post.timestamp > $1.post.timestamp})
            return familyFeed
        }
    }
    
}
