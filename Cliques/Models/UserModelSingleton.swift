//
//  UserModel.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

struct Connection {
    let profile: UserProfile
    let profileImage: StorageReference
    var clique: CliqueUtility.CliqueTitles?
}

struct UserProfile : Codable {
    var first: String?
    var last: String?
    var bio: String?
    var uniqueID: String?
    var friendsClique: [String]?
    var familyClique: [String]?
    var closeFriendsClique: [String]?
    var publicClique: [String]?
}

struct UserPostItem {
    let post: Post
    let postImage: StorageReference
}

class UserModelSingleton {
    private static var uniqueInstance: UserModelSingleton?
    private var userProfile = UserProfile()
    private var profileImageRef: StorageReference?
    private var profileInitialized = false
    private var profileLoading = false
    private let loginController: FirebaseLoginControllerSingleton
    private let firestoreController: FirestoreControllerProtocol
    private let firebaseStorageController: FirebaseStorageControllerProtocol
    private var notifyList = [((Bool)->())]()
    private var posts = [UserPostItem]()
    private var existingConnections = [Connection]()
    private var possibleConnections = [Connection]()
    private var notifyChangeList = [(()->())]()
    
    private init(firestoreController: FirestoreControllerProtocol, firebaseStorageController: FirebaseStorageControllerProtocol) {
        loginController = FirebaseLoginControllerSingleton.GetInstance()
        self.firebaseStorageController = firebaseStorageController
        self.firestoreController = firestoreController
        
        if loggedIn() {
            initializeProfile()
        }
    }
    
    public static func GetInstance(firestoreController: FirestoreControllerProtocol = FirestoreControllerSingleton.GetInstance(), firebaseStorageController: FirebaseStorageControllerProtocol = FirebaseStorageControllerSingleton.GetInstance()) -> UserModelSingleton {
        if let initializedUniqueInstance = uniqueInstance {
            return initializedUniqueInstance
        } else {
            uniqueInstance = UserModelSingleton(firestoreController: firestoreController,
                                                firebaseStorageController: firebaseStorageController)
            return uniqueInstance!
        }
    }
    
    public func RequestLoginWithPhoneNumber(phoneNumber: String, loginRequestComplete: @escaping (Bool)->()) {
        loginController.verifyPhoneNumber(phoneNumber: phoneNumber) { (error) in
            loginRequestComplete(error == nil)
        }
    }
    
    public func LoginWithVerificationCode(verificationCode: String,
                                          loginComplete: @escaping (_ success: Bool, _ profileExists: Bool) -> ()) {
        loginController.signInWithVerificationCode(verificationCode: verificationCode) { (error, result) in
            guard error == nil, result != nil else {
                // Sign in failed
                loginComplete(false, false)
                return
            }
            
            self.userProfile.uniqueID = result?.user.phoneNumber
            self.firestoreController.getUserProfileData(uniqueID: self.userProfile.uniqueID ?? "") { (downloadedUserProfile) in
                guard let downloadedUserProfile = downloadedUserProfile else {
                    // Sign in successful, user profile has not been created
                    loginComplete(true, false)
                    return
                }
                
                self.userProfile = downloadedUserProfile
                self.profileInitialized = true
                
                // Sign in successful, user profile exists
                loginComplete(true, true)
            }
        }
    }
    
    public func LogOut() {
        FirebaseLoginControllerSingleton.signOut()
        profileInitialized = false
    }
    
    public func getFirstName() -> String {
        return (userProfile.first ?? "")
    }
    
    public func getLastName() -> String {
        return (userProfile.last ?? "")
    }
    
    public func getName() -> String {
        return (userProfile.first ?? "") + " " + (userProfile.last ?? "")
    }
    
    public func getPhoneNumber() -> String {
        return (userProfile.uniqueID ?? "")
    }
    
    public func getBio() -> String {
        return (userProfile.bio ?? "")
    }
    
    public func getProfileImageRef() -> StorageReference {
        return firebaseStorageController.getProfileImageRef(userID: userProfile.uniqueID ?? "")
    }
    
    public func getCloseFriendsClique() -> [String] {
        return userProfile.closeFriendsClique ?? []
    }
    
    public func getFriendsClique() -> [String] {
        return userProfile.friendsClique ?? []
    }
    
    public func getFamilyClique() -> [String] {
        return userProfile.familyClique ?? []
    }
    
    public func getPublicClique() -> [String] {
        return userProfile.publicClique ?? []
    }
    
    public func getConnections() -> [Connection] {
        return existingConnections
    }
    
    public func getPossibleConnections() -> [Connection] {
        return possibleConnections
    }
    
    public func notifyOnConnectionChange(handler: @escaping (()->())) {
        notifyChangeList.append(handler)
    }
    
    public func updateConnections() {
        firestoreController.getConnections() { connections in
            guard let connections = connections else {
                return
            }
            
            self.possibleConnections = connections.filter{$0.profile.uniqueID != nil && $0.profile.uniqueID != self.userProfile.uniqueID}
            self.possibleConnections.sort(by: {$0.profile.first ?? "" < $1.profile.first ?? ""})

            for (index, connection) in self.possibleConnections.enumerated() {
                let id = connection.profile.uniqueID!
                
                if self.getCloseFriendsClique().contains(id) {
                    self.possibleConnections[index].clique = .CloseFriends
                } else if self.getFriendsClique().contains(id) {
                    self.possibleConnections[index].clique = .Friends
                } else if self.getFamilyClique().contains(id) {
                    self.possibleConnections[index].clique = .Family
                } else if self.getPublicClique().contains(id) {
                    self.possibleConnections[index].clique = .Public
                }
            }

            
            self.existingConnections = self.possibleConnections.filter{$0.clique != nil}
            self.notifyConnectionChange()
        }
        
    }
    
    private func notifyConnectionChange() {
        for handler in notifyChangeList {
            handler()
        }
    }
    
    public func editConnection(connection: Connection) {
        guard let id = connection.profile.uniqueID else { return }
        
        if let index = userProfile.closeFriendsClique?.firstIndex(where: {$0 == id}) {
            userProfile.closeFriendsClique?.remove(at: index)
        } else if let index = userProfile.friendsClique?.firstIndex(where: {$0 == id}) {
            userProfile.friendsClique?.remove(at: index)
        } else if let index = userProfile.familyClique?.firstIndex(where: {$0 == id}) {
            userProfile.familyClique?.remove(at: index)
        } else if let index = userProfile.publicClique?.firstIndex(where: {$0 == id}) {
            userProfile.publicClique?.remove(at: index)
        }
        
        if let clique = connection.clique {
            switch clique {
            case .CloseFriends:
                userProfile.closeFriendsClique?.append(id)
            case .Public:
                userProfile.publicClique?.append(id)
            case .Family:
                userProfile.familyClique?.append(id)
            case .Friends:
                userProfile.friendsClique?.append(id)
            }
        }
        
        firestoreController.addUserData(profile: userProfile) { success in
            guard success else { return }
            let connectionExists = connection.profile.closeFriendsClique?.contains(self.userProfile.uniqueID!) ?? false || connection.profile.publicClique?.contains(self.userProfile.uniqueID!) ?? false || connection.profile.familyClique?.contains(self.userProfile.uniqueID!) ?? false || connection.profile.friendsClique?.contains(self.userProfile.uniqueID!) ?? false
            
            if !connectionExists {
                self.firestoreController.addUserData(profile: connection.profile) { success in
                    guard success else { return }
                    self.notifyConnectionChange()
                }
            } else {
                self.notifyConnectionChange()
            }
        }
        
        
        
    }
    
    public func notifyWhenInitialized(handler: @escaping (_ success: Bool) -> ()) {
        guard !profileInitialized else {
            handler(true)
            return
        }
        
        notifyList.append(handler)
        
        if !profileLoading {
            initializeProfile()
        }
    }
    
    public func profileIsInitialized() -> Bool {
        return profileInitialized
    }
    
    public func loggedIn() -> Bool {
        userProfile.uniqueID = Auth.auth().currentUser?.phoneNumber
        return !(userProfile.uniqueID?.isEmpty ?? true)
    }
    
    public func initializeProfile() {
        guard loggedIn(), !profileLoading else { return }
        profileLoading = true
        
        self.firestoreController.getUserProfileData(uniqueID: self.userProfile.uniqueID ?? "") { (downloadedUserProfile) in
            guard let downloadedUserProfile = downloadedUserProfile else {
                while let handler = self.notifyList.popLast() {
                    handler(false)
                }
                
                self.profileLoading = false
                return
            }
            
            self.userProfile = downloadedUserProfile
            self.profileInitialized = true
            
            while let handler = self.notifyList.popLast() {
                handler(true)
            }
            
            self.profileLoading = false;
        }
    }
    
    public func updatePosts(completionHandler: @escaping (_ success: Bool) -> ()) {
        firestoreController.getUserPosts(userID: getPhoneNumber()) { posts in
            guard let posts = posts else {
                completionHandler(false)
                return
            }
            
            self.posts = posts
            completionHandler(true)
        }
    }
    
    public func getPosts(clique: CliqueUtility.CliqueTitles) -> [UserPostItem] {
        var cliquePosts: [UserPostItem]
        switch clique {
        case .Public:
            cliquePosts = posts.filter{$0.post.publicClique}
        case .Friends:
            cliquePosts = posts.filter{$0.post.friendsClique}
        case .CloseFriends:
            cliquePosts = posts.filter{$0.post.closeFriendsClique}
        case .Family:
            cliquePosts = posts.filter{$0.post.familyClique}
        }
        
        return cliquePosts
    }
    
    
}
