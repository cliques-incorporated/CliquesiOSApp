//
//  LoginViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/7/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate {
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
        PhoneNumberField?.delegate = self
        VerificationCodeTextField?.delegate = self
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
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func VerificationRequestComplete(error: Error?) {
        guard error == nil else {
            return
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "GoToVerification", sender: self)
        }
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
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "GoToFeed", sender: self)
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "GoToNewUser", sender: self)
            }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string == string.filter("0123456789".contains)
    }
    
    private func displayErrorMessageAndReturn() {
        DispatchQueue.main.async {
            if let presentingViewController = self.presentingViewController as? LoginViewController {
                presentingViewController.ErrorLabel?.isHidden = false
            }
            
            self.hideProcessingIndicator()
            self.dismiss(animated: true, completion: nil)
        }
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
