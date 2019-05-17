//
//  ProfileViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/10/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class ProfileViewController: UIViewController {
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PhoneNumberLabel: UILabel!
    @IBOutlet weak var BioLabel: UILabel!
    
    var firestoreController: FirestoreController?
    var storageController: FirebaseStorageController?
    
    private let editProfileOptionMenu = UIAlertController(title: nil, message: "Edit Profile", preferredStyle: .actionSheet)
    private var user: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        editProfileOptionMenu.addAction((UIAlertAction(title: "Edit Profile", style: .default, handler: editProfile)))
        editProfileOptionMenu.addAction((UIAlertAction(title: "Sign Out", style: .destructive, handler: signOut)))
        editProfileOptionMenu.addAction((UIAlertAction(title: "Close", style: .cancel, handler: nil)))
        
        firestoreController = FirestoreController()
        storageController = FirebaseStorageController()
        
        guard let currentUser = Auth.auth().currentUser else {
            goToLogin()
            return
        }
        
        guard let phoneNumber = currentUser.phoneNumber, !phoneNumber.isEmpty, let storageController = storageController else { return }
        firestoreController?.getUserProfileData(phoneNumber: phoneNumber, completionHandler: userProfileDataReceived)
        ProfileImageView.sd_setImage(with: storageController.getProfileImageRef(phoneNumber: phoneNumber))
    }
    
    private func userProfileDataReceived(user: UserModel?) {
        guard let user = user else { return }
        self.user = user
        NameLabel.text = user.first + " " + user.last
        PhoneNumberLabel.text = user.phoneNumber
        BioLabel.text = user.bio
    }
    
    private func signOut(alert: UIAlertAction) {
        FirebaseLoginController.signOut()
        goToLogin()
    }
    
    private func editProfile(alert: UIAlertAction) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "GoToEditProfile", sender: self)
        }
    }
    
    @IBAction func EditProfileButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            guard !self.editProfileOptionMenu.isBeingPresented else { return }
            self.present(self.editProfileOptionMenu, animated: true, completion: nil)
        }
    }
    
    private func goToLogin() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "GoToLogin", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let editProfileVC = segue.destination.children.first as? NewUserViewController {
            editProfileVC.newProfile = false
            editProfileVC.firstName = user?.first ?? ""
            editProfileVC.lastName = user?.last ?? ""
            editProfileVC.bio = user?.bio ?? ""
            editProfileVC.phoneNumber = user?.phoneNumber ?? ""
            editProfileVC.profileImage = ProfileImageView.image
        }
    }
}
