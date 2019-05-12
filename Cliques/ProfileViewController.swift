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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        editProfileOptionMenu.addAction((UIAlertAction(title: "Edit Profile", style: .default, handler: nil)))
        editProfileOptionMenu.addAction((UIAlertAction(title: "Sign Out", style: .destructive, handler: signOut)))
        editProfileOptionMenu.addAction((UIAlertAction(title: "Close", style: .cancel, handler: nil)))
        
        firestoreController = FirestoreController()
        storageController = FirebaseStorageController()
        
        let profileImageBorder = CALayer()
        profileImageBorder.borderColor = UIColor.black.cgColor
        let profileImageBorderWidth:CGFloat = 4.0
        profileImageBorder.borderWidth = profileImageBorderWidth
        profileImageBorder.cornerRadius = 2.0
        profileImageBorder.frame = CGRect.init(x: -profileImageBorderWidth + 2, y: -profileImageBorderWidth + 2, width: ProfileImageView.frame.size.width + 2 * profileImageBorderWidth - 4, height: ProfileImageView.frame.size.height + 2 * profileImageBorderWidth - 4)
        
        ProfileImageView.layer.addSublayer(profileImageBorder)
        ProfileImageView.layer.masksToBounds = false
        
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
        NameLabel.text = user.first + " " + user.last
        PhoneNumberLabel.text = user.phoneNumber
        BioLabel.text = user.bio
    }
    
    private func signOut(alert: UIAlertAction) {
        FirebaseLoginController.signOut()
        goToLogin()
    }
    
    func displayEditProfileMenu(gestureRecognizer: UILongPressGestureRecognizer) {
        DispatchQueue.main.async {
            if !self.editProfileOptionMenu.isBeingPresented, !self.editProfileOptionMenu.isBeingDismissed {
                gestureRecognizer.isEnabled = false
                self.present(self.editProfileOptionMenu, animated: true) {
                    gestureRecognizer.isEnabled = true
                }
            }
        }
    }
    
    
    private func goToLogin() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "GoToLogin", sender: self)
        }
    }

}
