//
//  ConnectionsViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 4/9/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class ConnectionsViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func SearchButtonPressed(_ sender: Any) {
        debugPrint("test")
        self.performSegue(withIdentifier: "GoToSearch", sender: self)
    }
}

