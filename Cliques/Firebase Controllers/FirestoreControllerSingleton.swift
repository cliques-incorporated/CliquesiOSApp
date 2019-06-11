//
//  FirestoreController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Firebase
import FirebaseFirestore
import CodableFirebase

class FirestoreControllerSingleton {
    private static var uniqueInstance: FirestoreControllerSingleton?
    private let firestoreDatabase: Firestore
    private let FirestoreUsersCollection = "users"
    private let FirestorePostsCollection = "posts"
    private let storageController: FirebaseStorageControllerSingleton
    
    private init() {
        firestoreDatabase = Firestore.firestore()
        let settings = firestoreDatabase.settings
        settings.isPersistenceEnabled = true
        firestoreDatabase.settings = settings
        storageController = FirebaseStorageControllerSingleton.GetInstance()
    }
    
    public static func GetInstance() -> FirestoreControllerSingleton {
        if let initializedUniqueInstance = uniqueInstance {
            return initializedUniqueInstance
        } else {
            uniqueInstance = FirestoreControllerSingleton()
            return uniqueInstance!
        }
    }
    
    func addUserData(profile: UserProfile, completionHandler: @escaping (_ success: Bool)->()) {
        guard let uniqueID = profile.uniqueID else {
            completionHandler(false)
            return
        }
        
        do {
            let profileData = try FirestoreEncoder().encode(profile);
    firestoreDatabase.collection(FirestoreUsersCollection).document(uniqueID).setData(profileData) { err in
                completionHandler(err == nil)
            }
        } catch {
            completionHandler(false)
        }
    }
    
    func doesUserProfileExist(uniqueID: String, completionHandler: @escaping (Bool?) -> ()){
        firestoreDatabase.collection(FirestoreUsersCollection).document(uniqueID).getDocument { (document, error) in
            completionHandler(document?.exists)
        }
    }
    
    func getUserProfileData(uniqueID: String, completionHandler: @escaping (UserProfile?) -> ()) {
        firestoreDatabase.collection(FirestoreUsersCollection).document(uniqueID).getDocument { (document, error) in
            guard let document = document, document.exists, let data = document.data() else {
                completionHandler(nil)
                return
            }
            
            do {
                let profile = try FirestoreDecoder().decode(UserProfile.self, from: data)
                completionHandler(profile)
            } catch {
                completionHandler(nil)
            }
        }
    }
    
    func uploadPost(authorID: String, post: Post, completionHandler: @escaping (String?) -> ()) {
        do {
            let postData = try FirestoreEncoder().encode(post);
            var ref: DocumentReference? = nil
            ref = firestoreDatabase.collection(FirestorePostsCollection).addDocument(data: postData) { err in
                    if(err == nil) {
                        completionHandler(ref?.documentID)
                    } else {
                        completionHandler(nil)
                    }
            }
        } catch {
            completionHandler(nil)
        }
    }
    
    func getUserPosts(userID: String, completion: @escaping ([UserPostItem]?) -> ()) {
        let postRef = firestoreDatabase.collection(FirestorePostsCollection)
        let postsQuery = postRef.whereField("authorID", isEqualTo: userID)
            .limit(to: 200)
            .order(by: "timestamp", descending: true)
        
        postsQuery.getDocuments() { (postsSnapshot, error) in
            guard let postsSnapshot = postsSnapshot, error == nil else {
                completion(nil)
                return
            }
            
            do {
                var feed = [UserPostItem]()
                
                for item in postsSnapshot.documents {
                    let data = item.data()
                    debugPrint(data.debugDescription)
                    
                    let post = try FirestoreDecoder().decode(Post.self, from: data)
                    feed.append(UserPostItem(post: post, postImage: self.storageController.getPostImageRef(postID: item.documentID)))
                }
                
                completion(feed)
            } catch let error {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
            
        }
        
    }
    
    func getUserFeed(userID: String, completion: @escaping ([FeedItem]?) -> ()) {
        let postRef = firestoreDatabase.collection(FirestorePostsCollection)
        let feedQuery = postRef.whereField("sharedWith", arrayContains: userID)
            .limit(to: 200)
            .order(by: "timestamp", descending: true)
        
    
        let personalQuery = postRef.whereField("authorID", isEqualTo: userID)
            .limit(to: 30)
            .order(by: "timestamp", descending: true)
        
        feedQuery.getDocuments() { (feedSnapshot, error) in
            guard let feedSnapshot = feedSnapshot, error == nil else {
                completion(nil)
                return
            }
            
            personalQuery.getDocuments() { (personalSnapshot, error) in
                guard let personalSnapshot = personalSnapshot, error == nil else {
                    completion(nil)
                    return
                }
                
                do {
                    let documents = personalSnapshot.documents + feedSnapshot.documents
                    var feed = [FeedItem]()
                    
                    for item in documents {
                        let data = item.data()
                        let post = try FirestoreDecoder().decode(Post.self, from: data)
                        
                        feed.append(FeedItem(post: post, postImage: self.storageController.getPostImageRef(postID: item.documentID), profileImage: self.storageController.getProfileImageRef(userID: post.authorID)))
                    }
                    
                    completion(feed)
                } catch let error {
                    debugPrint(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
    
    func getConnections(completion: @escaping ([Connection]?)-> ()) {
        let usersRef = firestoreDatabase.collection(FirestoreUsersCollection)
        usersRef.getDocuments() { (usersSnapshot, error) in
            guard let usersSnapshot = usersSnapshot, error == nil else {
                completion(nil)
                return
            }
            
            do {
                var connections = [Connection]()
                
                for item in usersSnapshot.documents {
                    let user = try FirestoreDecoder().decode(UserProfile.self, from: item.data())
                    connections.append(Connection(profile: user, profileImage: self.storageController.getProfileImageRef(userID: user.uniqueID ?? ""), clique: nil))
                }
                
                completion(connections)
            } catch let error {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }
        
    }
    
}
