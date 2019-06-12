//
//  ProfileViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/10/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//
import UIKit
import FirebaseUI

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var BioLabel: UILabel!
    @IBOutlet weak var UserPostsCollectionView: UICollectionView!
    
    private var userModel: UserModelSingleton!
    
    private let editProfileOptionMenu = UIAlertController(title: nil, message: "Edit Profile", preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserPostsCollectionView.delegate = self
        UserPostsCollectionView.dataSource = self
        
        userModel = UserModelSingleton.GetInstance()
        
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
        BioLabel.text = userModel.getBio()
        ProfileImageView.sd_setImage(with: userModel.getProfileImageRef())
        userModel.updatePosts(completionHandler: postsUpdate)
    }
    
    private func postsUpdate(success: Bool) {
        guard success else { return }
        UserPostsCollectionView.reloadData()
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
        if let editProfileVC = segue.destination.children.first as? NewUserViewController {
            editProfileVC.newProfile = false
            editProfileVC.firstName = userModel.getFirstName()
            editProfileVC.lastName = userModel.getLastName()
            editProfileVC.bio = userModel.getBio()
            editProfileVC.phoneNumber = userModel.getPhoneNumber()
            editProfileVC.profileImage = ProfileImageView.image
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let clique = CliqueUtility.GetCliqueForIndex(index: section) else {
            fatalError("Invalid section index.")
        }
        
        return userModel.getPosts(clique: clique).count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UserFeedHeader", for: indexPath) as? UserFeedHeaderViewCell else {
            fatalError("The dequeued cell is not an instance of UserFeedHeaderViewCell.")
        }
        
        guard let clique = CliqueUtility.GetCliqueForIndex(index: indexPath.section) else {
            fatalError("Invalid section index.")
        }
        
        cell.headerText.text = clique.rawValue
        cell.headerText.textColor = CliqueUtility.GetCliqueColor(clique: clique)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserFeedCell", for: indexPath) as? UserFeedCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of UserFeedCollectionViewCell.")
        }
        
        guard let clique = CliqueUtility.GetCliqueForIndex(index: indexPath.section) else {
            fatalError("Invalid section index.")
        }
        
        guard indexPath.row < userModel.getPosts(clique: clique).count else { return cell }
        cell.image.sd_setImage(with: userModel.getPosts(clique: clique)[indexPath.row].postImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 3 - 5, height: UIScreen.main.bounds.width / 3 - 5)
    }
}
