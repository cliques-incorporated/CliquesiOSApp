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
    
    public var userModel: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideProcessingIndicator()
        PhoneNumberField?.delegate = self
        VerificationCodeTextField?.delegate = self
        
        if userModel == nil {
            userModel = UserModel()
        }
    }
    
    @IBAction func SendMyLoginCodePressed(_ sender: Any) {
        ErrorLabel.isHidden = true
        userModel?.RequestLoginWithPhoneNumber(phoneNumber: PhoneNumberField.text ?? "", loginRequestComplete: LoginRequestComplete)
    }
    
    private func LoginRequestComplete(success: Bool) {
        guard success else { return }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "GoToVerification", sender: self)
        }
    }
    
    @IBAction func SubmitVerificationCodePressed(_ sender: Any) {
        displayProcessingIndicator()
        userModel?.LoginWithVerificationCode(verificationCode: VerificationCodeTextField.text ?? "", loginComplete: LoginComplete)
    }
    
    private func LoginComplete(success: Bool, profileExists: Bool) {
        guard success else {
            VerificationCodeTextField.text = nil
            displayErrorMessageAndReturn()
            return
        }
        
        if(profileExists) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "GoToFeed", sender: self)
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "GoToNewUser", sender: self)
            }
        }
    }
    
    @IBAction func GoBackPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let editProfileVC = segue.destination as? NewUserViewController {
            editProfileVC.newProfile = true
        } else if let loginViewController = segue.destination as? LoginViewController {
            loginViewController.userModel = self.userModel
        }
    }
}
