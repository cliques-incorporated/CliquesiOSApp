//
//  MockFirebaseLoginController.swift
//  CliquesTests
//
//  Created by Ethan Kusters on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import FirebaseAuth

class MockFirebaseLoginController: FirebaseLoginControllerProtocol {
    var verificationRequestErrorResp: Error? = nil
    func verifyPhoneNumber(phoneNumber: String, verificationRequestSuccess: @escaping (Error?) -> ()) {
        verificationRequestSuccess(verificationRequestErrorResp)
    }
    
    var signInErrorResp: Error? = nil
    var signInDataResp: AuthDataResult? = nil
    func signInWithVerificationCode(verificationCode: String, signInSuccess: @escaping (Error?, AuthDataResult?) -> ()) {
        signInSuccess(signInErrorResp, signInDataResp)
    }
    
    static var uniqueID: String? = "123456789"
    static func signOut() {
        uniqueID = nil
    }
    
    func getUniqueIDIfLoggedIn() -> String? {
        return MockFirebaseLoginController.uniqueID
    }
}
