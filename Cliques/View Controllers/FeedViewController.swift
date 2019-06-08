//
//  FirstViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 4/9/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class FeedViewController: UICollectionViewController {
    private var userModel: UserModelSingleton!
    private var publicFeedModel: FeedModel?
    private var familyFeedModel: FeedModel?
    private var closeFriendsFeedModel: FeedModel?
    private var friendsFeedModel: FeedModel?
    
    @IBOutlet var FeedSelectionButton: SelectFeedButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userModel = UserModelSingleton.GetInstance()
        FeedSelectionButton.FeedSelectionChanged = FeedSelectionChanged
        
        publicFeedModel = FeedModel(clique: .Public, updateCompletionHandler: feedUpdated)
        familyFeedModel = FeedModel(clique: .Family, updateCompletionHandler: feedUpdated)
        closeFriendsFeedModel = FeedModel(clique: .CloseFriends, updateCompletionHandler: feedUpdated)
        friendsFeedModel = FeedModel(clique: .Friends, updateCompletionHandler: feedUpdated)
        
        updateFeeds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard userModel.loggedIn() else {
            performSegue(withIdentifier: "GoToLogin", sender: self)
            return
        }
    }
    
    @IBAction func NewPostButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToNewPost", sender: self)
    }
    
    private func FeedSelectionChanged(selectedClique: CliqueUtility.CliqueTitles) {
        debugPrint(selectedClique.rawValue)
    }
    
    
    private func feedUpdated(success: Bool) {
        guard success else {
            return
        }
        
        
        
    }
    
    private func updateFeeds() {
        publicFeedModel?.update()
        friendsFeedModel?.update()
        familyFeedModel?.update()
        closeFriendsFeedModel?.update()
    }
}

