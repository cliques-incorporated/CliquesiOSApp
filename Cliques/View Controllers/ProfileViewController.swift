//
//  ProfileViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/10/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import FirebaseUI

class ProfileViewController: UIViewController {
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PhoneNumberLabel: UILabel!
    @IBOutlet weak var BioLabel: UILabel!
    
    private var userModel: UserModel!
    
    private let editProfileOptionMenu = UIAlertController(title: nil, message: "Edit Profile", preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let overviewController = tabBarController as? OverviewTabBarController {
            self.userModel = overviewController.getUserModel()
        }
        
        // Do any additional setup after loading the view.
        editProfileOptionMenu.addAction((UIAlertAction(title: "Edit Profile", style: .default, handler: editProfile)))
        editProfileOptionMenu.addAction((UIAlertAction(title: "Sign Out", style: .destructive, handler: signOut)))
        editProfileOptionMenu.addAction((UIAlertAction(title: "Close", style: .cancel, handler: nil)))
        
        guard userModel.loggedIn() else {
            goToLogin()
            return
        }
        
        userModel.notifyWhenInitialized(handler: userModelInitialized)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userModel.notifyWhenInitialized(handler: userModelInitialized)
        super.viewDidAppear(true)
    }
    
    private func userModelInitialized(success: Bool) {
        guard success else {
            userModel.LogOut()
            goToLogin()
            return
        }
        
        NameLabel.text = userModel.getName()
        PhoneNumberLabel.text = userModel.getPhoneNumber()
        BioLabel.text = userModel.getBio()
        ProfileImageView.sd_setImage(with: userModel.getProfileImageRef())
    }
    
    private func signOut(alert: UIAlertAction) {
        userModel.LogOut()
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
            editProfileVC.firstName = userModel.getFirstName()
            editProfileVC.lastName = userModel.getLastName()
            editProfileVC.bio = userModel.getBio()
            editProfileVC.phoneNumber = userModel.getPhoneNumber()
            editProfileVC.profileImage = ProfileImageView.image
        }
    }
}
