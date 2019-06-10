//
//  ConnectionsViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 4/9/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class ConnectionsViewController: UICollectionViewController {
    private var searchController: UISearchController!
    private var searchResultsController = AddConnectionSearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.definesPresentationContext = true
        searchController = UISearchController(searchResultsController: searchResultsController)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Add a Connection"
        searchController.searchResultsUpdater = searchResultsController
    }

    @IBAction func SearchButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToSearch", sender: self)
    }
}

