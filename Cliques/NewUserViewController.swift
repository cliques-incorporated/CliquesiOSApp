//
//  NewUserViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/10/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import Firebase
import Photos

class NewUserViewController: UIViewController {
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var BioTextField: UITextField!
    @IBOutlet weak var SelectProfileImageButton: UIButton!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var UploadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var LetsGoButton: UIButton!
    
    private var imageSelected = false
    private let imageRequestController = ImageRequestController()
    private let allFieldsRequiredAlert = UIAlertController(title: "We're missing something...", message: "All fields are required!", preferredStyle: .alert)
    private let errorAlert = UIAlertController(title: "Uh oh!", message: "Something went wrong. Please try again.", preferredStyle: .alert)
    
    private var firestoreController: FirestoreController?
    private var firebaseStorageController: FirebaseStorageController?
    
    private var firstName = ""
    private var lastName = ""
    private var bio = ""
    private var phoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firestoreController = FirestoreController()
        firebaseStorageController = FirebaseStorageController()
        
        // Do any additional setup after loading the view.
        allFieldsRequiredAlert.addAction((UIAlertAction(title: "Got It", style: .cancel, handler: nil)))
        
        let profileImageBorder = CALayer()
        profileImageBorder.borderColor = UIColor.black.cgColor
        let profileImageBorderWidth:CGFloat = 15.0
        profileImageBorder.borderWidth = profileImageBorderWidth
        profileImageBorder.cornerRadius = 8.0
        profileImageBorder.frame = CGRect.init(x: -profileImageBorderWidth + 5, y: -profileImageBorderWidth + 5, width: ProfileImageView.frame.size.width + 2 * profileImageBorderWidth - 10, height: ProfileImageView.frame.size.height + 2 * profileImageBorderWidth - 10)
        
        ProfileImageView.layer.addSublayer(profileImageBorder)
        ProfileImageView.layer.masksToBounds = false
    }
    
    @IBAction func FirstNameReturnButtonPressed(_ sender: Any) {
        LastNameTextField.becomeFirstResponder()
    }
    
    @IBAction func LastNameReturnButtonPressed(_ sender: Any) {
        BioTextField.becomeFirstResponder()
    }
    
    @IBAction func BioReturnButtonPressed(_ sender: Any) {
        BioTextField.resignFirstResponder()
    }
    
    @IBAction func SelectProfileImagePressed(_ sender: Any) {
        imageRequestController.requestImage(viewController: self, imageSelected: imageSelected)
    }
    
    private func imageSelected(image: UIImage?) {
        guard let image = image else { return }
        ProfileImageView.image = image
        imageSelected = true
    }
    
    @IBAction func LetsGoButtonPressed(_ sender: Any) {
        firstName = FirstNameTextField.text ?? ""
        lastName = LastNameTextField.text ?? ""
        bio = BioTextField.text ?? ""
        
        guard !(firstName.isEmpty), !(lastName.isEmpty), !(bio.isEmpty), imageSelected, let image = ProfileImageView.image else {
            present(allFieldsRequiredAlert, animated: true, completion: nil)
            return
        }
        
        phoneNumber = Auth.auth().currentUser?.phoneNumber ?? ""
        guard !phoneNumber.isEmpty else {
            return
        }
        
        displayUploadingIndicator()
        firebaseStorageController?.uploadProfileImage(phoneNumber: phoneNumber, profileImage: image, uploadCompletionHandler: profileImageUploaded)
    }
    
    private func profileImageUploaded(imageURL: URL?) {
        guard let imageURL = imageURL else {
            hideUploadingIndicator()
            present(errorAlert, animated: true, completion: nil)
            return
        }
        
        firestoreController?.addUserData(phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, bio: bio, photoURL: imageURL, completionHandler: userProfileDataUploaded)
    }
    
    private func userProfileDataUploaded(error: Error?) {
        guard error == nil else {
            hideUploadingIndicator()
            present(errorAlert, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: "GoToFeed", sender: self)
    }
    
    @IBAction func TextFieldEditingBegan(_ sender: Any) {
        guard let textField = sender as? UITextField else { return }
        textField.placeholder = nil
    }
    
    @IBAction func FirstNameTextFieldEditingDidEnd(_ sender: Any) {
        guard let textField = sender as? UITextField else { return }
        textField.placeholder = "First Name"
    }
    
    @IBAction func LastNameTextFieldEditingDidEnd(_ sender: Any) {
        guard let textField = sender as? UITextField else { return }
        textField.placeholder = "Last Name"
    }
    
    private func displayUploadingIndicator() {
        LetsGoButton.isHidden = true
        UploadingIndicatorView.startAnimating()
    }
    
    private func hideUploadingIndicator() {
        LetsGoButton.isHidden = false
        UploadingIndicatorView.stopAnimating()
    }
}
