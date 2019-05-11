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
    
    private var imageSelected = false
    private let imageRequestController = ImageRequestController()
    private let allFieldsRequiredAlert = UIAlertController(title: "We're missing something...", message: "All fields are required!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard !(FirstNameTextField.text?.isEmpty ?? true), !(LastNameTextField.text?.isEmpty ?? true), !(BioTextField.text?.isEmpty ?? true), imageSelected else {
            present(allFieldsRequiredAlert, animated: true, completion: nil)
            return
        }
        
        
    }
    
    @IBAction func TextFieldEditingBegan(_ sender: Any) {
        if let textField = sender as? UITextField {
            textField.placeholder = nil
        }
    }
    
    @IBAction func FirstNameTextFieldEditingDidEnd(_ sender: Any) {
        if let textField = sender as? UITextField {
            textField.placeholder = "First Name"
        }
    }
    
    @IBAction func LastNameTextFieldEditingDidEnd(_ sender: Any) {
        if let textField = sender as? UITextField {
            textField.placeholder = "Last Name"
        }
    }
}
