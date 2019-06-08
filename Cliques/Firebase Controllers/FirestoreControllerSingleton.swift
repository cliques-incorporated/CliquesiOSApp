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
    
    private init() {
        firestoreDatabase = Firestore.firestore()
        let settings = firestoreDatabase.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firestoreDatabase.settings = settings
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
    
    func getUserFeed(userID: String, usersInFeed: [String], clique: CliqueUtility.CliqueTitles, completion: ([Post])) {
        let postRef = firestoreDatabase.collection(FirestorePostsCollection)
        let feedQuery = postRef.whereField("sharedWith", arrayContains: userID)
            .limit(to: 30)
            .order(by: "timestamp")
        
    
        let personalQuery = postRef.whereField("authorID", isEqualTo: userID)
            .whereField(CliqueUtility.GetDatabaseString(clique: clique), isEqualTo: true)
            .limit(to: 30)
            .order(by: "timestamp")
        
        feedQuery.getDocuments() { (feedSnapshot, error) in
            guard let feedSnapshot = feedSnapshot, error == nil else {
                return
            }
            
            personalQuery.getDocuments() { (personalSnapshot, error) in
                guard let personalSnapshot = personalSnapshot, error == nil else {
                    return
                }
                
                do {
                    let documents = personalSnapshot.documents + feedSnapshot.documents
                    var
                    
                    for item in feed {
                        let post = try FirestoreDecoder().decode(Post.self, from: item.data())
                        
                    }
                    
                    //var feed = feedPosts + personalPosts
                    //feed.sort(by: {$0.timestamp > $1.timestamp})
                    
                
                } catch {
                    
                }
            }
        }
    }
}
