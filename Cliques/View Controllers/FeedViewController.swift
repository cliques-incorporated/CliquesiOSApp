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
    private var feedModel: FeedModelSingleton!
    @IBOutlet var FeedTableView: UITableView!
    
    @IBOutlet var FeedSelectionButton: SelectFeedButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userModel = UserModelSingleton.GetInstance()
        feedModel = FeedModelSingleton.GetInstance()
        FeedSelectionButton.FeedSelectionChanged = FeedSelectionChanged
        
        
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
        feedModel.update(completionHandler: feedUpdated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func getCurrentFeed() -> [FeedItem] {
        return feedModel.getFeed(clique: FeedSelectionButton.getSelectedClique())
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCurrentFeed().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCell", for: indexPath) as? FeedItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FeedViewCell.")
        }

        if indexPath.row < getCurrentFeed().count {
            cell.postImage.sd_setImage(with: getCurrentFeed()[indexPath.row].postImage)
            cell.postLabel.text = getCurrentFeed()[indexPath.row].post.caption
            cell.profileImage.sd_setImage(with: getCurrentFeed()[indexPath.row].profileImage)
            cell.authorLabel.text = getCurrentFeed()[indexPath.row].post.authorName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.width + 120
    }
}

