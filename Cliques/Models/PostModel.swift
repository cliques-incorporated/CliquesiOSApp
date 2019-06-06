//
//  PostModel.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/30/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import UIKit

struct Post: Codable {
    var caption: String
    var publicClique: Bool
    var friendsClique: Bool
    var closeFriendsClique: Bool
    var familyClique: Bool
}

class PostModel {
    private let post: Post
    private let image: UIImage
    private let authorID: String
    private let firestoreController: FirestoreControllerSingleton
    private let firebaseStorageController: FirebaseStorageControllerSingleton
    private var completionHandler: ((_ success: Bool) -> ())?
    
    init(image: UIImage, caption: String, publicClique: Bool = false, friendsClique: Bool = false, closeFriendsClique: Bool = false, familyClique: Bool = false) {
        firestoreController = FirestoreControllerSingleton.GetInstance()
        firebaseStorageController = FirebaseStorageControllerSingleton.GetInstance()
        
        post = Post(caption: caption, publicClique: publicClique, friendsClique: friendsClique, closeFriendsClique: closeFriendsClique, familyClique: familyClique)
        
        self.image = image
        self.authorID = UserModelSingleton.GetInstance().getPhoneNumber()
    }
    
    
    func upload(completionHandler: @escaping (_ success: Bool) -> ()) {
        self.completionHandler = completionHandler
        firestoreController.uploadPost(authorID: authorID, post: post, completionHandler: postUploadComplete)
    }
    
    private func postUploadComplete(uniqueID: String?) {
        guard let uniqueID = uniqueID else {
            completionHandler?(false);
            return
        }
        
        firebaseStorageController.uploadPostImage(userID: authorID, postID: uniqueID, image: image) { success in
            self.completionHandler?(success)
        }
    }
}