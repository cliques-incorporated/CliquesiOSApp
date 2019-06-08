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
    let postID: String
    let postImage: StorageReference
}

class FeedModel {
    let clique: CliqueUtility.CliqueTitles
    let user: UserModelSingleton
    let completionHandler: (_ feed: [FeedItem]?) -> ()
    
    init(clique: CliqueUtility.CliqueTitles, updateCompletionHandler: @escaping (_ feed: [FeedItem]?) -> ()) {
        self.clique = clique
        user = UserModelSingleton.GetInstance()
        self.completionHandler = updateCompletionHandler
    }
    
    public func update() {
        
        
    }
    
    
}
