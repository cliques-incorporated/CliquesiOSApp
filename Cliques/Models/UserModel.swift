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
    var first: String
    var last: String
    var bio: String
    var phoneNumber: String
    var profileImageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case first = "first"
        case last = "last"
        case bio = "bio"
        case phoneNumber = "id"
        case profileImageURL = "profileImageURL"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first = try values.decodeIfPresent(String.self, forKey: .first) ?? ""
        last = try values.decodeIfPresent(String.self, forKey: .last) ?? ""
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? ""
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        profileImageURL = URL.init(string: try values.decodeIfPresent(String.self, forKey: .profileImageURL) ?? "")
    }
    
    init(from dictionary: [String:Any]) {
        first = dictionary[CodingKeys.first.stringValue] as? String ?? ""
        last = dictionary[CodingKeys.last.stringValue] as? String ?? ""
        bio = dictionary[CodingKeys.bio.stringValue] as? String ?? ""
        phoneNumber = dictionary[CodingKeys.phoneNumber.stringValue] as? String ?? ""
        profileImageURL = URL.init(string: dictionary[CodingKeys.profileImageURL.stringValue] as? String ?? "")
    }
    
}

class UserModel {
    private var first: String?
    private var last: String?
    private var bio: String?
    private var phoneNumber: String?
    private var profileImageURL: URL?
    private var profileImageRef: StorageReference?
    private var profileInitialized = false
    private let loginController = FirebaseLoginController()
    private let firestoreController = FirestoreController()
    private let firebaseStorageController = FirebaseStorageController()
    
    public init() {
        if loggedIn() {
            initializeProfile()
        }
    }
    
    public func RequestLoginWithPhoneNumber(phoneNumber: String, loginRequestComplete: @escaping (Bool)->()) {
        loginController.verifyPhoneNumber(phoneNumber: phoneNumber) { (error) in
            loginRequestComplete(error == nil)
        }
    }
    
    public func LoginWithVerificationCode(verificationCode: String, loginComplete: @escaping (_ success: Bool, _ profileExists: Bool) -> ()) {
        loginController.signInWithVerificationCode(verificationCode: verificationCode) { (error, result) in
            guard error == nil, result != nil else {
                // Sign in failed
                loginComplete(false, false)
                return
            }
            
            self.phoneNumber = result?.user.phoneNumber
            self.firestoreController.getUserProfileData(phoneNumber: self.phoneNumber ?? "") { (userProfile) in
                guard let userProfile = userProfile else {
                    // Sign in successful, user profile has not been created
                    loginComplete(true, false)
                    return
                }
                
                self.first = userProfile.first
                self.last = userProfile.last
                self.bio = userProfile.bio
                self.profileImageURL = userProfile.profileImageURL
                self.profileInitialized = true
                
                // Sign in successful, user profile exists
                loginComplete(true, true)
            }
        }
    }
    
    public func LogOut() {
        loginController.signOut()
        profileInitialized = false
    }
    
    public func getFirstName() -> String {
        return (first ?? "")
    }
    
    public func getLastName() -> String {
        return (last ?? "")
    }
    
    public func getName() -> String {
        return (first ?? "") + " " + (last ?? "")
    }
    
    public func getPhoneNumber() -> String {
        return (phoneNumber ?? "")
    }
    
    public func getBio() -> String {
        return (bio ?? "")
    }
    
    public func getProfileImageURL() -> URL? {
        return profileImageURL
    }
    
    public func getProfileImageRef() -> StorageReference {
        return firebaseStorageController.getProfileImageRef(phoneNumber: phoneNumber ?? "")
    }
    
    public func profileIsInitialized() -> Bool {
        return profileInitialized
    }
    
    public func loggedIn() -> Bool {
        phoneNumber = Auth.auth().currentUser?.phoneNumber
        return !(phoneNumber?.isEmpty ?? true)
    }
    
    public func initializeProfile() {
        guard loggedIn() else { return }
        self.firestoreController.getUserProfileData(phoneNumber: self.phoneNumber ?? "") { (userProfile) in
            guard let userProfile = userProfile else {
                // User profile does not exist
                return
            }
            
            self.first = userProfile.first
            self.last = userProfile.last
            self.bio = userProfile.bio
            self.profileImageURL = userProfile.profileImageURL
            self.profileInitialized = true
        }
    }
    
    
}
