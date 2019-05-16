//
//  FirstViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 4/9/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "GoToLogin", sender: self)
        }
    }
}

