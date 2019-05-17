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

class FeedViewController: UICollectionViewController {
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
    
    @IBAction func NewPostButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToNewPost", sender: self)
    }
    
    func userProfileCheckComplete(exists: Bool?) {
        guard exists == true else {
            FirebaseLoginController.signOut()
            performSegue(withIdentifier: "GoToLogin", sender: self)
            return
        }
    }
}

