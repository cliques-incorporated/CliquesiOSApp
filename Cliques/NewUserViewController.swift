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
    @IBOutlet weak var SelectProfileImageButton: UIButton!
    let imageRequestController = ImageRequestController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func FirstNameReturnButtonPressed(_ sender: Any) {
        LastNameTextField.becomeFirstResponder()
    }
    
    @IBAction func LastNameReturnButtonPressed(_ sender: Any) {
        SelectProfileImageButton.becomeFirstResponder()
    }
    
    @IBAction func SelectProfileImagePressed(_ sender: Any) {
        imageRequestController.requestImage(viewController: self, imageSelected: imageSelected)
    }
    
    private func imageSelected(image: UIImage?) {
        
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
