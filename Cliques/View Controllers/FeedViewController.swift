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
    @IBOutlet var FeedSelectionButton: SelectFeedButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userModel = UserModelSingleton.GetInstance()
        FeedSelectionButton.FeedSelectionChanged = FeedSelectionChanged
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
}

