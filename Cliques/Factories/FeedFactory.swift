//
//  FeedFactory.swift
//  Cliques
//
//  Created by Jasmine on 6/8/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI

class FeedFactory{
    private let feedUpdatedHandler: (_ success: Bool) -> ()
    
    init(feedUpdatedHandler: @escaping (_ success: Bool) -> ()) {
        self.feedUpdatedHandler = feedUpdatedHandler
    }
    
    public func makeFeedModel(clique: CliqueUtility.CliqueTitles) -> FeedModel{
        switch clique {
        case .Public:
            return FeedModel(clique: .Public, updateCompletionHandler: feedUpdatedHandler)
        case .Friends:
            return FeedModel(clique: .Friends, updateCompletionHandler: feedUpdatedHandler)
        case .CloseFriends:
            return FeedModel(clique: .CloseFriends, updateCompletionHandler: feedUpdatedHandler)
        case .Family:
            return FeedModel(clique: .Family, updateCompletionHandler: feedUpdatedHandler)
        }
    }
    

}
    

    

