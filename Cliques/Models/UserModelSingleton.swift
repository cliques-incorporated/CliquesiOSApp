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

struct UserProfile : Codable {
    var first: String?
    var last: String?
    var bio: String?
    var phoneNumber: String?
    var profileImageURL: URL?
    var friendsClique: [String]?
    var familyClique: [String]?
    var closeFriendsClique: [String]?
    var publicClique: [String]?
}

class UserModelSingleton {
    private static var uniqueInstance: UserModelSingleton?
    private var userProfile = UserProfile()
    private var profileImageRef: StorageReference?
    private var profileInitialized = false
    private var profileLoading = false
    private let loginController: FirebaseLoginControllerSingleton
    private let firestoreController: FirestoreControllerSingleton
    private let firebaseStorageController: FirebaseStorageControllerSingleton
    private var notifyList = [((Bool)->())]()
    
    private init() {
        loginController = FirebaseLoginControllerSingleton.GetInstance()
        firestoreController = FirestoreControllerSingleton.GetInstance()
        firebaseStorageController = FirebaseStorageControllerSingleton.GetInstance()
        
        if loggedIn() {
            initializeProfile()
        }
    }
    
    public static func GetInstance() -> UserModelSingleton {
        if let initializedUniqueInstance = uniqueInstance {
            return initializedUniqueInstance
        } else {
            uniqueInstance = UserModelSingleton()
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
            
            self.userProfile.phoneNumber = result?.user.phoneNumber
            self.firestoreController.getUserProfileData(phoneNumber: self.userProfile.phoneNumber ?? "") { (downloadedUserProfile) in
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
        return (userProfile.phoneNumber ?? "")
    }
    
    public func getBio() -> String {
        return (userProfile.bio ?? "")
    }
    
    public func getProfileImageURL() -> URL? {
        return userProfile.profileImageURL
    }
    
    public func getProfileImageRef() -> StorageReference {
        return firebaseStorageController.getProfileImageRef(phoneNumber: userProfile.phoneNumber ?? "")
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
        userProfile.phoneNumber = Auth.auth().currentUser?.phoneNumber
        return !(userProfile.phoneNumber?.isEmpty ?? true)
    }
    
    public func initializeProfile() {
        guard loggedIn(), !profileLoading else { return }
        profileLoading = true
        
        self.firestoreController.getUserProfileData(phoneNumber: self.userProfile.phoneNumber ?? "") { (downloadedUserProfile) in
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
    
    
}
