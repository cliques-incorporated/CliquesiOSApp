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
    
    private var LoginController = FirebaseLoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SendMyLoginCodePressed(_ sender: Any) {
        ErrorLabel.isHidden = true
        LoginController.verifyPhoneNumber(phoneNumber: PhoneNumberField.text ?? "", verificationRequestSuccess: VerificationRequestComplete)
    }
    
    @IBAction func SubmitVerificationCodePressed(_ sender: Any) {
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
            if let presentingViewController = presentingViewController as? LoginViewController {
                presentingViewController.ErrorLabel?.isHidden = false
            }
            
            dismiss(animated: true, completion: nil)
        } else {
            // User is logged in successfully
            performSegue(withIdentifier: "GoToFeed", sender: self)
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
    
}
