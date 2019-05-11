//
//  LoginViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/7/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    @IBOutlet weak var SendLoginCodeButton: UIButton!
    @IBOutlet weak var PhoneNumberField: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var VerificationCodeTextField: UITextField!
    @IBOutlet weak var SubmitProcessingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var SubmitCodeButton: UIButton!
    
    private let LoginController = FirebaseLoginController()
    private let firestoreController = FirestoreController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideProcessingIndicator()
    }
    
    @IBAction func SendMyLoginCodePressed(_ sender: Any) {
        ErrorLabel.isHidden = true
        LoginController.verifyPhoneNumber(phoneNumber: PhoneNumberField.text ?? "", verificationRequestSuccess: VerificationRequestComplete)
    }
    
    @IBAction func SubmitVerificationCodePressed(_ sender: Any) {
        displayProcessingIndicator()
        LoginController.signInWithVerificationCode(verificationCode: VerificationCodeTextField.text ?? "", signInSuccess: SignInComplete)
    }
    
    @IBAction func GoBackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func VerificationRequestComplete(error: Error?) {
        guard error == nil else {
            return
        }
        
        performSegue(withIdentifier: "GoToVerification", sender: self)
    }
    
    private func SignInComplete(error: Error?, authDataResult: AuthDataResult?) {
        if error != nil || authDataResult == nil {
            VerificationCodeTextField.text = nil
            displayErrorMessageAndReturn()
        } else if let phoneNumber = authDataResult?.user.phoneNumber {
            // User is logged in successfully
            firestoreController.doesUserProfileExist(phoneNumber: phoneNumber, completionHandler: userProfileCheckComplete)
        } else {
            displayErrorMessageAndReturn()
        }
    }
    
    private func userProfileCheckComplete(exists: Bool?) {
        guard let exists = exists else {
            displayErrorMessageAndReturn()
            return
        }
        
        if(exists) {
            performSegue(withIdentifier: "GoToFeed", sender: self)
        } else {
            performSegue(withIdentifier: "GoToNewUser", sender: self)
        }
    }
    
    @IBAction func textFieldEditDidBegin(_ sender: Any) {
        if let textField = sender as? UITextField {
            textField.placeholder = nil
        }
    }
    
    @IBAction func textFieldEditDidEnd(_ sender: Any) {
        if let textField = sender as? UITextField {
            if textField.textContentType == UITextContentType.telephoneNumber {
                textField.placeholder = "Phone Number"
            } else {
                textField.placeholder = "Verification Code"
            }
        }
    }
    
    private func displayErrorMessageAndReturn() {
        if let presentingViewController = presentingViewController as? LoginViewController {
            presentingViewController.ErrorLabel?.isHidden = false
        }
        
        hideProcessingIndicator()
        dismiss(animated: true, completion: nil)
    }
    
    private func displayProcessingIndicator() {
        SubmitCodeButton?.isHidden = true
        SubmitProcessingIndicatorView?.startAnimating()
    }
    
    private func hideProcessingIndicator() {
        SubmitCodeButton?.isHidden = false
        SubmitProcessingIndicatorView?.stopAnimating()
    }
}
