//
//  FirstViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 4/9/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FeedViewController: UIViewController {
    private var firestoreController: FirestoreController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firestoreController = FirestoreController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let phoneNumber = Auth.auth().currentUser?.phoneNumber else {
            performSegue(withIdentifier: "GoToLogin", sender: self)
            return
        }
        
        firestoreController?.doesUserProfileExist(phoneNumber: phoneNumber, completionHandler: userProfileCheckComplete)
    }
    
    func userProfileCheckComplete(exists: Bool?) {
        guard exists == true else {
            FirebaseLoginController.signOut()
            performSegue(withIdentifier: "GoToLogin", sender: self)
            return
        }
    }
}

