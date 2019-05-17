//
//  FirebaseLoginController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/9/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import FirebaseAuth
import Firebase

class FirebaseLoginController {
    func verifyPhoneNumber(phoneNumber: String, verificationRequestSuccess:@escaping (Error?)->()) {
        let number = "+1" + phoneNumber
        
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                debugPrint(error.localizedDescription);
            } else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
            
            verificationRequestSuccess(error)
        }
    }
    
    func signInWithVerificationCode(verificationCode: String, signInSuccess:@escaping(Error?, AuthDataResult?)->()) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            signInSuccess(nil, nil)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            signInSuccess(error, authResult)
        }
    }
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            debugPrint(error)
        }
    }
}
