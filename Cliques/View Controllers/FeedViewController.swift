//
//  FirstViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 4/9/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
    private var userModel: UserModelSingleton!
    private var publicFeedModel: FeedModel?
    private var familyFeedModel: FeedModel?
    private var closeFriendsFeedModel: FeedModel?
    private var friendsFeedModel: FeedModel?
    @IBOutlet var FeedTableView: UITableView!
    
    @IBOutlet var FeedSelectionButton: SelectFeedButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userModel = UserModelSingleton.GetInstance()
        FeedSelectionButton.FeedSelectionChanged = FeedSelectionChanged
        var feedFactory = FeedFactory(feedUpdatedHandler: feedUpdated(success:))
        
        //using the factory!
        publicFeedModel = feedFactory.makeFeedModel(clique: .Public)
        friendsFeedModel = feedFactory.makeFeedModel(clique: .Friends)
        closeFriendsFeedModel = feedFactory.makeFeedModel(clique: .CloseFriends)
        familyFeedModel = feedFactory.makeFeedModel(clique: .Family)
        
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
        FeedTableView.reloadSections(IndexSet.init(arrayLiteral: 0), with: .fade)
    }
    
    
    private func feedUpdated(success: Bool) {
        guard success else {
            return
        }

        refreshControl?.endRefreshing()
        FeedTableView.reloadSections(IndexSet.init(arrayLiteral: 0), with: .fade)
    }
    
    @IBAction func RefreshControlRefreshing(_ sender: Any) {
        updateFeeds()
    }
    
    private func updateFeeds() {
        publicFeedModel?.update()
        friendsFeedModel?.update()
        familyFeedModel?.update()
        closeFriendsFeedModel?.update()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func getCurrentFeed() -> [FeedItem] {
        switch FeedSelectionButton.getSelectedClique() {
        case .CloseFriends:
            return closeFriendsFeedModel?.getFeed() ?? [FeedItem]()
        case .Public:
            return publicFeedModel?.getFeed() ?? [FeedItem]()
        case .Family:
            return familyFeedModel?.getFeed() ?? [FeedItem]()
        case .Friends:
            return friendsFeedModel?.getFeed() ?? [FeedItem]()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCurrentFeed().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCell", for: indexPath) as? FeedItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FeedViewCell.")
        }

        
        cell.postImage.sd_setImage(with: getCurrentFeed()[indexPath.row].postImage)
        cell.postLabel.text = getCurrentFeed()[indexPath.row].post.caption
        cell.profileImage.sd_setImage(with: getCurrentFeed()[indexPath.row].profileImage)
        cell.authorLabel.text = getCurrentFeed()[indexPath.row].post.authorName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.width + 120
    }
}

