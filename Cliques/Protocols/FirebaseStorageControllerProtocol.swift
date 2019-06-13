//
//  FirebaseStoragerControllerProtocol.swift
//  Cliques
//
//  Created by Ethan Kusters on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import FirebaseUI

protocol FirebaseStorageControllerProtocol {
    func uploadProfileImage(userID: String, profileImage: UIImage, uploadCompletionHandler: @escaping (URL?)->())
    func getProfileImageRef(userID: String) -> StorageReference
    func uploadPostImage(userID: String, postID: String, image: UIImage, uploadCompletionHandler: @escaping(Bool)->())
    func getPostImageRef(postID: String) -> StorageReference
}
